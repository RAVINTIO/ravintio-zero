#!/usr/bin/env node
// Lists and checks the queue items that name an initiative step (0000444 REQ-001, ADR-0307).
//
// Usage:
//   node initiative-queue.mjs list  --step {n} [--root dir]
//   node initiative-queue.mjs check --step {n} [--base ref] [--root dir]
//
// The queue is $RAVINTIO_INITIATIVE_ROOT/plan/.initiative-queue/, or plan/.initiative-queue/ under
// --root (default: the current folder) when the variable is unset.
//   list   prints "{folder}<TAB>{destination}" for each item whose **Step:** line holds {n}.
//   check  exits 1 and names each named item that has no committed destination in
//          `git diff {base}...HEAD` and no "Queue item {folder}: {reason}" line in
//          plan/current/build-log.md. The default base is origin/{branch} from the chart.
// Item text is data. The helper never runs it, skips a symlinked folder or file, and prints a
// folder name only if it matches NAME.

import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

export const NAME = /^[A-Za-z0-9._-]{1,80}$/;
const QUEUE = path.join('plan', '.initiative-queue');
const MAX_BYTES = 64 * 1024;
const STEP_LINE = /^\*\*Step:\*\* ([1-9][0-9]{0,2})[ \t]*$/m;
const DEST_LINE = /^\*\*Destination:\*\* (\S[^\r\n]*?)[ \t]*$/m;

function isLink(p) {
  try {
    return fs.lstatSync(p).isSymbolicLink();
  } catch {
    return false;
  }
}

// Returns { items: [{ name, dest }], warnings: [string] } for the items that name the step.
// A warning never holds a folder name that fails NAME, and never holds item content.
export function namedItems(queueRoot, step) {
  const items = [];
  const warnings = [];
  const dir = path.join(queueRoot, QUEUE);
  if (isLink(path.join(queueRoot, 'plan')) || isLink(dir)) return { items, warnings: ['the queue path is a symbolic link'] };
  let names;
  try {
    names = fs.readdirSync(dir).sort();
  } catch {
    return { items, warnings };
  }
  for (const name of names) {
    const folder = path.join(dir, name);
    if (isLink(folder)) {
      warnings.push('skipped a symbolic link');
      continue;
    }
    let st;
    try {
      st = fs.lstatSync(folder);
    } catch {
      continue;
    }
    if (!st.isDirectory()) continue;
    if (!NAME.test(name)) {
      warnings.push('skipped an item with an unsafe folder name');
      continue;
    }
    const file = path.join(folder, 'item.md');
    let fst;
    try {
      fst = fs.lstatSync(file);
    } catch {
      warnings.push(`${name}: no item.md`);
      continue;
    }
    if (!fst.isFile() || fst.isSymbolicLink() || fst.size > MAX_BYTES) {
      warnings.push(`${name}: item.md is not a plain small file`);
      continue;
    }
    const text = fs.readFileSync(file, 'utf8');
    const s = STEP_LINE.exec(text);
    const d = DEST_LINE.exec(text);
    if (!s || !d) {
      warnings.push(`${name}: item.md has no valid Step or Destination line`);
      continue;
    }
    if (s[1] !== String(step)) continue;
    const dest = d[1];
    if (path.isAbsolute(dest) || dest.split('/').includes('..') || dest.length > 300) {
      warnings.push(`${name}: the destination is not a repo path`);
      continue;
    }
    items.push({ name, dest });
  }
  return { items, warnings };
}

function fail(message) {
  process.stderr.write(`initiative-queue: ${message}\n`);
  process.exit(2);
}

function parse(argv) {
  const opts = { cmd: argv[0], step: null, base: null, root: null };
  for (let i = 1; i < argv.length; i++) {
    if (argv[i] === '--step') opts.step = argv[++i] ?? '';
    else if (argv[i] === '--base') opts.base = argv[++i] ?? '';
    else if (argv[i] === '--root') opts.root = argv[++i] ?? '';
    else fail('usage: initiative-queue.mjs list|check --step {n} [--base ref] [--root dir]');
  }
  if (!['list', 'check'].includes(opts.cmd)) fail('usage: initiative-queue.mjs list|check --step {n} [--base ref] [--root dir]');
  if (!/^[1-9][0-9]{0,2}$/.test(opts.step ?? '')) fail('--step needs a step number');
  return opts;
}

function git(root, args) {
  return spawnSync('git', args, { cwd: root, encoding: 'utf8' });
}

function defaultBase(root) {
  try {
    const text = fs.readFileSync(path.join(root, 'plan', 'current-initiative', 'initiative.md'), 'utf8');
    const m = /^\*\*Branch:\*\* (initiative\/[0-9]{7}-[a-z0-9-]+)\s*$/m.exec(text);
    if (m) return `origin/${m[1]}`;
  } catch {
    // No chart: the caller must pass --base.
  }
  return '';
}

// Escapes every regular expression metacharacter, including the backslash.
function escapeRe(text) {
  return text.replace(/[\\^$.*+?()[\]{}|]/g, '\\$&');
}

function matcher(dest) {
  const escaped = escapeRe(dest).replace(/\\\{id\\\}/g, '[0-9]{7}');
  return new RegExp(`^${escaped}(/.*)?$`);
}

function main() {
  const opts = parse(process.argv.slice(2));
  const root = opts.root ?? process.cwd();
  const queueRoot = opts.root ? root : process.env.RAVINTIO_INITIATIVE_ROOT || root;
  const { items, warnings } = namedItems(queueRoot, opts.step);
  for (const w of warnings) process.stderr.write(`initiative-queue: ${w}\n`);
  if (opts.cmd === 'list') {
    for (const it of items) process.stdout.write(`${it.name}\t${it.dest}\n`);
    return;
  }
  if (items.length === 0) return;
  const base = opts.base || defaultBase(root);
  if (!base) fail('no base ref. Pass --base {ref}');
  const diff = git(root, ['diff', '--name-only', `${base}...HEAD`]);
  if (diff.status !== 0) fail(`git diff against ${base} failed`);
  const changed = diff.stdout.split('\n').filter(Boolean);
  let log = '';
  try {
    log = fs.readFileSync(path.join(root, 'plan', 'current', 'build-log.md'), 'utf8');
  } catch {
    // No build log means no report.
  }
  const missing = items.filter((it) => {
    const re = matcher(it.dest);
    if (changed.some((f) => re.test(f))) return false;
    const report = new RegExp(`^[-* ]*Queue item ${escapeRe(it.name)}:`, 'm');
    return !report.test(log);
  });
  if (missing.length === 0) return;
  for (const it of missing) process.stdout.write(`missing: ${it.name} (destination ${it.dest})\n`);
  process.stdout.write('Commit each destination, or add a build log line "Queue item {name}: {reason}".\n');
  process.exit(1);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
