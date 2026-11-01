#!/usr/bin/env node
// Exits 1 when a PR into main breaks the branch or commit rule.
// Usage: node check-pr-into-main.mjs --head-ref name --base ref --head ref [--root dir]
// Exit codes: 0 passes, 1 breaks the rule, 2 usage or git error.
// An initiative/ head ref passes before any git call.
// A chore/ or hotfix/ head ref passes with exactly one commit in base..head.
// Any other head ref fails. The output holds the head ref and the count only.
// Reads git only and keeps no state.
import { execFileSync } from 'node:child_process';

const USAGE =
  'check-pr-into-main: usage: check-pr-into-main.mjs --head-ref name --base ref --head ref [--root dir]';
const FLAGS = { '--head-ref': 'headRef', '--base': 'base', '--head': 'head', '--root': 'root' };

const args = process.argv.slice(2);
const opts = { root: process.cwd() };
for (let i = 0; i < args.length; i += 2) {
  const key = FLAGS[args[i]];
  if (!key || !args[i + 1]) {
    console.error(USAGE);
    process.exit(2);
  }
  opts[key] = args[i + 1];
}
if (!opts.headRef || !opts.base || !opts.head) {
  console.error(USAGE);
  process.exit(2);
}

// A value that starts with a dash would reach git as an option.
if (opts.base.startsWith('-') || opts.head.startsWith('-')) {
  console.error(USAGE);
  process.exit(2);
}

if (opts.headRef.startsWith('initiative/')) {
  console.log(`check-pr-into-main: ${opts.headRef} is an initiative branch. Pass.`);
  process.exit(0);
}

const allowed = opts.headRef.startsWith('chore/') || opts.headRef.startsWith('hotfix/');

let count;
try {
  const out = execFileSync(
    'git',
    ['-C', opts.root, 'rev-list', '--count', `${opts.base}..${opts.head}`],
    { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] },
  );
  count = Number.parseInt(out.trim(), 10);
  if (Number.isNaN(count)) throw new Error('bad count');
} catch {
  console.error('check-pr-into-main: cannot read git history');
  process.exit(2);
}

if (!allowed) {
  console.error(
    `check-pr-into-main: ${opts.headRef} (${count} commits) may not target main. Use chore/ or hotfix/.`,
  );
  process.exit(1);
}
if (count !== 1) {
  console.error(
    `check-pr-into-main: ${opts.headRef} has ${count} commits. Squash it to exactly one.`,
  );
  process.exit(1);
}
console.log(`check-pr-into-main: ${opts.headRef} has 1 commit. Pass.`);
process.exit(0);
