#!/usr/bin/env node
// Checks that every first-parent commit on an initiative branch carries a titled subject (0000319).
//
// Usage: node check-initiative-history.mjs [--root dir] [--base ref] [--head ref]
//   --root  the repository folder. Default is the current folder.
//   --base  the base ref. Default origin/main.
//   --head  the head ref. Default HEAD.
//
// It lists `git log --first-parent` from the merge base of the base and head to the head.
// A subject passes if it matches `{7-digit id}-{slug}: {summary} (#{n})` with a kebab-case slug.
// There is no exception list and the script keeps no state.
// It exits 1 and prints the short hash and subject of each failing commit.
// It also exits 1 with a message if a ref is missing. It exits 0 otherwise.

import { execFileSync } from 'node:child_process';

const TITLE = /^\d{7}-[a-z0-9]+(-[a-z0-9]+)*: .+ \(#\d+\)$/;

function fail(message) {
  process.stderr.write(`check-initiative-history: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const opts = { root: process.cwd(), base: 'origin/main', head: 'HEAD' };
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

let mergeBase;
try {
  mergeBase = git(opts.root, ['merge-base', opts.base, opts.head]).trim();
} catch {
  fail(`no merge base between ${opts.base} and ${opts.head}`);
}

const log = git(opts.root, [
  'log', '--first-parent', '--format=%h%x09%s', `${mergeBase}..${opts.head}`,
]);
const commits = log.split('\n').filter(Boolean).map((line) => {
  const tab = line.indexOf('\t');
  return { hash: line.slice(0, tab), subject: line.slice(tab + 1) };
});

if (commits.length === 0) {
  process.stdout.write(`check-initiative-history: no commits between ${opts.base} and ${opts.head}\n`);
  process.exit(0);
}

const bad = commits.filter((c) => !TITLE.test(c.subject));
if (bad.length === 0) {
  process.stdout.write(`check-initiative-history: ${commits.length} commit(s) checked, all titled\n`);
  process.exit(0);
}

process.stderr.write('check-initiative-history: untitled first-parent commits\n');
for (const c of bad) process.stderr.write(`${c.hash} ${c.subject}\n`);
process.exit(1);
