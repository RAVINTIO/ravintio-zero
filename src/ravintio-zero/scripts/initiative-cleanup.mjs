#!/usr/bin/env node
// initiative-cleanup.mjs - I-E Delivery cleanup of the driver state (0000581 ADR-0353).
//
// Usage, run from the repository root after the human merges the initiative PR:
//
//   node ravintio-zero/scripts/initiative-cleanup.mjs --id {id}-{slug} [--root <dir>]
//
// Arguments:
//   --id <id>      The initiative id and slug, such as 0000544-priority-backlog. It names the
//                  archive folder, so it holds only letters, digits, dots inside a word, and dashes.
//   --root <dir>   The working tree that holds plan/. Defaults to the current directory.
//
// What it does, in order:
//   1. Refuses while plan/.initiative-runner.lock exists.
//   2. Moves plan/.initiative-logs/ and plan/.initiative-control/ to
//      {git folder}/ravintio-archive/{id}/. If that folder exists, it adds a numeric suffix
//      (-2, -3) and never overwrites.
//   3. Removes each folder under plan/.initiative-worktrees/ with "git worktree remove --force",
//      then runs "git worktree prune".
//   4. Leaves plan/.initiative-queue/ in place and prints one Kept line for each item.
//
// Output: every line starts with "I-E Delivery:". A missing folder, a failed removal, and each
// queue item print "I-E Delivery: Kept: ...". A failed removal never stops the run.
//
// Safety: it removes no path outside the repository root and refuses a symlink at any path it
// touches. It prints "I-E Delivery: Blocked: refused a symlinked path" and changes nothing.
//
// Exit codes:
//   0  The cleanup ran.
//   1  A Blocked line printed: a lock, a bad argument, or a symlinked path.
//
// It has no dependencies beyond Node and git.

import { existsSync, lstatSync, mkdirSync, readdirSync, renameSync } from 'node:fs';
import { join, resolve, isAbsolute } from 'node:path';
import { spawnSync } from 'node:child_process';

const LOCK = 'plan/.initiative-runner.lock';
const LOGS = 'plan/.initiative-logs';
const CONTROL = 'plan/.initiative-control';
const WORKTREES = 'plan/.initiative-worktrees';
const QUEUE = 'plan/.initiative-queue';
const ID = /^[A-Za-z0-9][A-Za-z0-9-]*(\.[A-Za-z0-9-]+)*$/;
const MAX_LINE = 300;

class Stop extends Error {}

const out = (line) => process.stdout.write(`${line.slice(0, MAX_LINE)}\n`);
const blocked = (reason) => {
  throw new Stop(`I-E Delivery: Blocked: ${reason}`);
};

function parseArgs(argv) {
  const opts = { id: null, root: process.cwd() };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--id' || a === '--root') {
      if (i + 1 >= argv.length) blocked(`${a} needs a value`);
      opts[a.slice(2)] = argv[++i];
    } else {
      blocked(`unknown argument ${a}`);
    }
  }
  if (!opts.id) blocked('--id {id}-{slug} is required');
  if (!ID.test(opts.id) || opts.id.length > 100) blocked(`the id ${opts.id} is not a plain id and slug`);
  return opts;
}

function isLink(path) {
  try {
    return lstatSync(path).isSymbolicLink();
  } catch {
    return false;
  }
}

function present(path) {
  try {
    lstatSync(path);
    return true;
  } catch {
    return false;
  }
}

function git(root, args) {
  return spawnSync('git', args, { cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
}

const lastLine = (text) => (text || '').trim().split('\n').pop().trim();

// Refuses a symlink at the path and at each parent below the root.
function refuseLinks(root, rel) {
  let p = root;
  for (const part of rel.split('/')) {
    p = join(p, part);
    if (isLink(p)) blocked('refused a symlinked path');
  }
}

function gitFolder(root) {
  const r = git(root, ['rev-parse', '--git-common-dir']);
  if (r.status !== 0) blocked('the root is not a git repository');
  const dir = lastLine(r.stdout);
  return isAbsolute(dir) ? dir : resolve(root, dir);
}

function archiveTarget(base, id) {
  let target = join(base, id);
  for (let n = 2; present(target); n++) target = join(base, `${id}-${n}`);
  return target;
}

function moveFolders(root, id) {
  const sources = [LOGS, CONTROL];
  for (const rel of sources) refuseLinks(root, rel);
  const base = join(gitFolder(root), 'ravintio-archive');
  if (isLink(base)) blocked('refused a symlinked path');
  let target = null;
  for (const rel of sources) {
    const from = join(root, rel);
    if (!present(from)) {
      out(`I-E Delivery: Kept: ${rel} is absent`);
      continue;
    }
    if (!target) {
      mkdirSync(base, { recursive: true });
      target = archiveTarget(base, id);
      mkdirSync(target);
    }
    try {
      renameSync(from, join(target, rel.split('/').pop()));
      out(`I-E Delivery: Moved: ${rel} to ${target}`);
    } catch (e) {
      out(`I-E Delivery: Kept: ${rel} could not move: ${e.code || e.name}`);
    }
  }
}

function removeWorktrees(root) {
  const dir = join(root, WORKTREES);
  refuseLinks(root, WORKTREES);
  if (!present(dir)) {
    out(`I-E Delivery: Kept: ${WORKTREES} is absent`);
    return;
  }
  for (const name of readdirSync(dir).sort()) {
    const rel = `${WORKTREES}/${name}`;
    const wt = join(dir, name);
    if (isLink(wt)) {
      out(`I-E Delivery: Kept: ${rel}: a symlink`);
      continue;
    }
    const r = git(root, ['worktree', 'remove', '--force', wt]);
    if (r.status === 0) out(`I-E Delivery: Removed: ${rel}`);
    else out(`I-E Delivery: Kept: ${rel}: ${lastLine(r.stderr) || 'git could not remove it'}`);
  }
  git(root, ['worktree', 'prune']);
}

function reportQueue(root) {
  const dir = join(root, QUEUE);
  refuseLinks(root, QUEUE);
  if (!present(dir)) {
    out(`I-E Delivery: Kept: ${QUEUE} is absent`);
    return;
  }
  const items = readdirSync(dir).sort();
  if (items.length === 0) out(`I-E Delivery: Kept: ${QUEUE} holds no item`);
  for (const name of items) out(`I-E Delivery: Kept: queue item ${name}`);
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  const root = resolve(opts.root);
  if (!existsSync(join(root, 'plan'))) blocked('the root holds no plan/ folder');
  refuseLinks(root, 'plan');
  if (present(join(root, LOCK))) blocked(`a driver holds ${LOCK}`);
  moveFolders(root, opts.id);
  removeWorktrees(root);
  reportQueue(root);
  out(`I-E Delivery: Complete: driver state of ${opts.id} cleaned up`);
}

try {
  main();
} catch (e) {
  if (e instanceof Stop) {
    process.stdout.write(`${e.message}\n`);
    process.exit(1);
  }
  throw e;
}
