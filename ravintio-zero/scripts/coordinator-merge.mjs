#!/usr/bin/env node
// Merges the initiative branch into a coordinator branch and regenerates the shared files (0000505, ADR-0315).
//
// Usage: node coordinator-merge.mjs --base <ref> [--id <initiative-id>] [--root dir]
//   --base  the ref to merge, such as origin/initiative/0000360-backlog-sweep. Run `git fetch` first.
//   --id    the initiative id and slug for the commit subjects. Default is the id in an `initiative/` base ref.
//   --root  the repository folder. Default is the current folder.
//
// The command exits 1, before it merges, if the working tree has uncommitted changes to tracked files.
// It merges with a merge commit. If the merge conflicts only on files in the shared-files allowlist,
// it resolves them with resolveSharedConflicts and commits the merge. If a conflict touches any other
// file, it aborts the merge, names the files, and exits 1, so the branch stays as it was.
// After every merge, clean or resolved, it runs regenerateSharedFiles and commits any change.
// It prints `resolved: {path}` and `regenerated: {path}` for each file. It never pushes.
// Every git call takes an argument array. The command treats file text as data.

import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { regenerateSharedFiles, resolveSharedConflicts } from './shared-files.mjs';

function fail(message) {
  process.stderr.write(`coordinator-merge: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const opts = { base: null, id: null, root: process.cwd() };
  const names = { '--base': 'base', '--id': 'id', '--root': 'root' };
  for (let i = 0; i < argv.length; i++) {
    const key = names[argv[i]];
    if (!key) fail(`unknown argument ${argv[i]}`);
    if (i + 1 >= argv.length) fail(`${argv[i]} needs a value`);
    opts[key] = argv[++i];
  }
  if (opts.base === null) fail('--base is required');
  if (opts.base.startsWith('-')) fail('--base must be a ref, not an option');
  opts.root = path.resolve(opts.root);
  return opts;
}

function git(root, args) {
  const result = spawnSync('git', ['-C', root, ...args], { encoding: 'utf8' });
  if (result.error) fail(`git ${args[0]} failed: ${result.error.message}`);
  return result;
}

function gitOut(root, args) {
  const result = git(root, args);
  if (result.status !== 0) fail(`git ${args[0]} failed: ${(result.stderr || result.stdout).trim()}`);
  return result.stdout;
}

/** The initiative id and slug: the --id value, or the one in an `initiative/` base ref. */
function initiativeId(opts) {
  const id = opts.id ?? /(?:^|\/)initiative\/(\d{7}-[a-z0-9-]+)$/.exec(opts.base)?.[1] ?? null;
  if (id === null) fail('the base ref names no initiative. Pass --id {7 digits}-{slug}');
  if (!/^\d{7}-[a-z0-9-]+$/.test(id)) fail('--id must have the form {7 digits}-{slug}');
  return id;
}

const opts = parseArgs(process.argv.slice(2));
const id = initiativeId(opts);
const { root, base } = opts;

if (gitOut(root, ['status', '--porcelain', '--untracked-files=no']).trim() !== '') {
  fail('the working tree has uncommitted changes. Commit or set them aside first');
}
if (git(root, ['rev-parse', '-q', '--verify', `${base}^{commit}`]).status !== 0) fail(`${base} is not a commit`);

const subject = `${id}: Merge the initiative branch`;
const merge = git(root, ['merge', '--no-ff', '-m', subject, '--', base]);
if (merge.status !== 0) {
  const merging = git(root, ['rev-parse', '-q', '--verify', 'MERGE_HEAD']).status === 0;
  if (!merging) fail(`merge of ${base} failed: ${(merge.stderr || merge.stdout).trim()}`);
  let resolved;
  try {
    resolved = resolveSharedConflicts({ root });
    gitOut(root, ['commit', '-m', subject]);
  } catch (e) {
    git(root, ['merge', '--abort']);
    fail(`merge of ${base} aborted: ${e.message}`);
  }
  for (const file of resolved) console.log(`resolved: ${file}`);
}

let changed;
try {
  changed = regenerateSharedFiles({ root, subject: `${id}: Regenerate shared files` });
} catch (e) {
  fail(`regeneration after the merge of ${base} failed: ${e.message}`);
}
for (const file of changed) console.log(`regenerated: ${file}`);
