#!/usr/bin/env node
// Lists and checks the GitHub settings that need repo admin rights
// (0000394 ADR-003).
//
// Usage: node ravintio-zero/scripts/github-settings.mjs list|check [--repo owner/name]
//   list   prints the checklist for the human.
//   check  reads each setting through gh api, prints "on", "off", or "unknown"
//          per item, and exits 1 unless every item is on.

import { execFileSync } from 'node:child_process';

const REQUIRED_CHECK = 'workflow-lint';

const ITEMS = [
  { id: 'secret-scanning', how: 'Settings > Advanced Security > Secret scanning: Enable' },
  { id: 'push-protection', how: 'Settings > Advanced Security > Push protection: Enable' },
  { id: 'dependabot-security-updates', how: 'Settings > Advanced Security > Dependabot security updates: Enable' },
  { id: 'private-vulnerability-reporting', how: 'Settings > Advanced Security > Private vulnerability reporting: Enable' },
  { id: 'topics', how: 'Repository home > About > Topics: add at least one' },
  { id: 'workflow-lint-required', how: `Settings > Rules > Protect Main Branch > Required status checks: add ${REQUIRED_CHECK}` },
];

function gh(args) {
  return execFileSync('gh', args, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
}

function api(path) {
  return JSON.parse(gh(['api', path]));
}

function enabled(block) {
  return block && block.status === 'enabled';
}

function readers(repo) {
  const sec = () => api(`repos/${repo}`).security_and_analysis || {};
  return {
    'secret-scanning': () => enabled(sec().secret_scanning),
    'push-protection': () => enabled(sec().secret_scanning_push_protection),
    'dependabot-security-updates': () => enabled(sec().dependabot_security_updates),
    'private-vulnerability-reporting': () => api(`repos/${repo}/private-vulnerability-reporting`).enabled === true,
    topics: () => (api(`repos/${repo}/topics`).names || []).length > 0,
    'workflow-lint-required': () => api(`repos/${repo}/rules/branches/main`).some(
      (r) => r.type === 'required_status_checks'
        && (r.parameters?.required_status_checks || []).some((c) => c.context === REQUIRED_CHECK),
    ),
  };
}

function main(argv) {
  const cmd = argv[0];
  const at = argv.indexOf('--repo');
  if (cmd === 'list') {
    console.log('Turn on these settings. Each needs repo admin rights.');
    ITEMS.forEach((it, i) => console.log(`${i + 1}. ${it.id}: ${it.how}`));
    return 0;
  }
  if (cmd !== 'check') {
    console.error('Usage: github-settings.mjs list|check [--repo owner/name]');
    return 2;
  }
  let repo = at >= 0 ? argv[at + 1] : '';
  if (!repo) repo = gh(['repo', 'view', '--json', 'nameWithOwner', '--jq', '.nameWithOwner']).trim();
  const read = readers(repo);
  let failed = 0;
  for (const it of ITEMS) {
    let state;
    try {
      state = read[it.id]() ? 'on ' : 'off';
    } catch {
      state = 'unknown';
    }
    if (state !== 'on ') failed += 1;
    console.log(`${state} ${it.id}`);
  }
  return failed === 0 ? 0 : 1;
}

process.exit(main(process.argv.slice(2)));
