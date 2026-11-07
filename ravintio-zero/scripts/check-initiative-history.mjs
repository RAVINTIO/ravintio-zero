#!/usr/bin/env node
// Checks that an initiative branch holds one titled commit per charted step, then at most one chore commit (0000351).
//
// Usage: node check-initiative-history.mjs [--root dir] [--base ref] [--head ref] [--chart path]
//   --root   the repository folder. Default is the current folder.
//   --base   the base ref. Default origin/main.
//   --head   the head ref. Default HEAD.
//   --chart  the initiative chart. Default is plan/current-initiative/initiative.md under the root.
//            If that file is missing, the script looks for plan/_archive/{id}-*/initiative.md.
//            The {id} is the 7 digits after `initiative/` in the --head value.
//
// The script reads the `## Steps` table of the chart. It finds the `Feature id` and `Title` columns by name.
// The `Version` column is optional. Steps with a Version come first, in ascending semver order, which is merge order (0000378).
// Steps with no Version follow in chart position. If the column is missing or every Version is in chart order, the order is the chart order.
// It lists `git log --first-parent` from the merge base of the base and head to the head, oldest first.
// Those commits must be the steps in merge order, each with the subject
// `{first 7 digits of Feature id}: {Title} (#{n})`.
// At most one more commit may follow, with the subject `{initiative id}: Initiative admin (#{n})`.
// The initiative id comes from the chart heading `# Initiative: {7 digits} - ...`.
// Subjects are compared as strings. The script builds no regular expression from a title.
// It exits 1 and prints the short hash and subject of each failing commit, and a line for each missing step.
// It also exits 1 with a message if a ref, the chart, or a table column is missing. It exits 0 otherwise.

import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';

function fail(message) {
  process.stderr.write(`check-initiative-history: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const opts = { root: process.cwd(), base: 'origin/main', head: 'HEAD', chart: '' };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    const key = arg.replace(/^--/, '');
    if (!arg.startsWith('--') || !(key in opts)) fail(`unknown argument ${arg}`);
    if (i + 1 >= argv.length) fail(`${arg} needs a value`);
    opts[key] = argv[++i];
  }
  return opts;
}

function git(root, args) {
  return execFileSync('git', ['-C', root, ...args], {
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  });
}

const opts = parseArgs(process.argv.slice(2));

for (const ref of [opts.base, opts.head]) {
  try {
    git(opts.root, ['rev-parse', '--verify', '--quiet', `${ref}^{commit}`]);
  } catch {
    fail(`ref not found: ${ref}`);
  }
}

function findChart() {
  if (opts.chart) {
    if (!existsSync(opts.chart)) fail(`chart not found: ${opts.chart}`);
    return opts.chart;
  }
  const tried = [];
  const current = join(opts.root, 'plan', 'current-initiative', 'initiative.md');
  if (existsSync(current)) return current;
  tried.push(current);
  const id = /initiative\/(\d{7})/.exec(opts.head)?.[1];
  if (id) {
    const archive = join(opts.root, 'plan', '_archive');
    tried.push(join(archive, `${id}-*`, 'initiative.md'));
    if (existsSync(archive)) {
      for (const name of readdirSync(archive).sort()) {
        const path = join(archive, name, 'initiative.md');
        if (name.startsWith(`${id}-`) && existsSync(path)) return path;
      }
    }
  } else {
    tried.push('plan/_archive/{id}-*/initiative.md (no 7-digit id after initiative/ in --head)');
  }
  return fail(`no chart found. Tried: ${tried.join(', ')}`);
}

function cells(line) {
  return line.trim().replace(/^\|/, '').replace(/\|$/, '').split('|').map((c) => c.trim());
}

// Reads `1.2.3` or `v1.2` into numbers. Returns an empty list when the cell holds no version.
function parseVersion(text) {
  const match = /^v?(\d+)\.(\d+)(?:\.(\d+))?$/.exec(text.trim());
  return match ? [Number(match[1]), Number(match[2]), Number(match[3] ?? 0)] : [];
}

// Orders versions ascending. A step with no version sorts after every versioned step.
function compareVersions(a, b) {
  if (a.length === 0 || b.length === 0) return a.length === b.length ? 0 : a.length === 0 ? 1 : -1;
  for (let i = 0; i < 3; i++) if (a[i] !== b[i]) return a[i] - b[i];
  return 0;
}

function parseChart(text) {
  const heading = /^# Initiative: (\d{7}) - /m.exec(text);
  if (!heading) fail('chart heading `# Initiative: {7 digits} - ...` not found');
  const lines = text.split('\n');
  const start = lines.findIndex((l) => /^##\s+Steps\s*$/.test(l));
  if (start < 0) fail('chart has no `## Steps` section');
  const rows = [];
  for (let i = start + 1; i < lines.length; i++) {
    if (/^##\s/.test(lines[i])) break;
    if (lines[i].trim().startsWith('|')) rows.push(cells(lines[i]));
  }
  if (rows.length === 0) fail('`## Steps` has no table');
  const header = rows[0];
  const idCol = header.indexOf('Feature id');
  const titleCol = header.indexOf('Title');
  if (idCol < 0) fail('`## Steps` table has no `Feature id` column');
  if (titleCol < 0) fail('`## Steps` table has no `Title` column');
  const versionCol = header.indexOf('Version');
  const steps = rows.slice(1)
    .filter((r) => !r.every((c) => /^:?-+:?$/.test(c)))
    .map((r) => {
      const featureId = /^\d{7}/.exec(r[idCol] ?? '')?.[0];
      if (!featureId) fail(`step row has no 7-digit Feature id: ${r.join(' | ')}`);
      const version = versionCol < 0 ? [] : parseVersion(r[versionCol] ?? '');
      return { subject: `${featureId}: ${r[titleCol] ?? ''}`, version };
    });
  // Array.sort is stable, so steps with equal or no Version keep their chart position.
  steps.sort((a, b) => compareVersions(a.version, b.version));
  return { initiativeId: heading[1], steps: steps.map((s) => s.subject) };
}

// Splits `{prefix} (#{n})` into the prefix. Returns null if the suffix is missing.
function stripNumber(subject) {
  const at = subject.lastIndexOf(' (#');
  if (at < 0) return null;
  const tail = subject.slice(at + 3);
  if (!tail.endsWith(')')) return null;
  const digits = tail.slice(0, -1);
  if (digits.length === 0 || [...digits].some((ch) => ch < '0' || ch > '9')) return null;
  return subject.slice(0, at);
}

let mergeBase;
try {
  mergeBase = git(opts.root, ['merge-base', opts.base, opts.head]).trim();
} catch {
  fail(`no merge base between ${opts.base} and ${opts.head}`);
}

const log = git(opts.root, [
  'log', '--first-parent', '--reverse', '--format=%h%x09%s', `${mergeBase}..${opts.head}`,
]);
const commits = log.split('\n').filter(Boolean).map((line) => {
  const tab = line.indexOf('\t');
  return { hash: line.slice(0, tab), subject: line.slice(tab + 1) };
});

const chartPath = findChart();
const { initiativeId, steps } = parseChart(readFileSync(chartPath, 'utf8'));
const chore = `${initiativeId}: Initiative admin`;

let next = 0;
let choreSeen = false;
const bad = [];
for (const c of commits) {
  const base = stripNumber(c.subject);
  if (base !== null && next < steps.length && base === steps[next]) {
    next++;
  } else if (base !== null && base === chore && next === steps.length && !choreSeen) {
    choreSeen = true;
  } else {
    bad.push(c);
  }
}
const missing = steps.slice(next);

if (bad.length === 0 && missing.length === 0) {
  process.stdout.write(`check-initiative-history: ${commits.length} commit(s) checked, ${steps.length} step(s) matched${choreSeen ? ' and one chore commit' : ''}\n`);
  process.exit(0);
}

process.stderr.write(`check-initiative-history: history does not match the chart ${chartPath}\n`);
for (const c of bad) process.stderr.write(`${c.hash} ${c.subject}\n`);
for (const m of missing) process.stderr.write(`missing step commit: ${m} (#n)\n`);
process.exit(1);
