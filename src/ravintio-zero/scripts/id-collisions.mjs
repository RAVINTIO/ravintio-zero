#!/usr/bin/env node
// Renumbers an ADR or a backlog entry that two merged steps added under one id (0000485, ADR-0312).
//
// Usage (module): renumberCollisions({ root, ours, theirs }) -> [{ kind, from, to }]
//   root    the repository folder with the base merge done. Default is the current folder.
//   ours    the PR head before the merge. Default is HEAD^1.
//   theirs  the base head. Default is HEAD^2.
//
// Parallel steps reserve ids from the counter on their own branch, so two steps can add
// docs/adr/0301-a.md and docs/adr/0301-b.md. Git sees no conflict on files with different names.
// For each such PR file, the module gives it the next free id, renames it, and fixes the lines that the
// PR wrote. It raises the counter and rebuilds the backlog index. It stages every change and never
// commits. The caller commits. With no collision it changes nothing and returns [].
// Every git call takes an argument array. The module treats file text as data.

import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const ADR_FILE = /^docs\/adr\/(\d{4})-([^/]+)\.md$/;
const BACKLOG_FILE = /^plan\/backlog\/(\d{7})-([^/]+)\/.+$/;
const ADR_COUNTER = 'docs/adr/.next-id';
const BACKLOG_COUNTER = 'plan/backlog/.next-id';
const BACKLOG_INDEX = 'plan/backlog/index.md';
const MAX_TEXT_BYTES = 1024 * 1024;

function git(root, args, allowFail = false) {
  const result = spawnSync('git', ['-C', root, ...args], { encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 });
  if (result.error) throw new Error(`git ${args[0]} failed: ${result.error.message}`);
  if (result.status !== 0 && !allowFail) throw new Error(`git ${args[0]} failed: ${result.stderr.trim()}`);
  return result;
}

const lines = (text) => text.split('\0').filter((l) => l !== '');

function readCounter(root, file) {
  try {
    const text = fs.readFileSync(path.join(root, file), 'utf8').trim();
    return /^\d+$/.test(text) ? text : null;
  } catch {
    return null;
  }
}

function escapeRe(text) {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function readText(root, file) {
  const full = path.join(root, file);
  try {
    const stat = fs.lstatSync(full);
    if (!stat.isFile() || stat.size > MAX_TEXT_BYTES) return null;
    const text = fs.readFileSync(full, 'utf8');
    return text.includes('\0') ? null : text;
  } catch {
    return null;
  }
}

/** The set of lines that the PR added to a file since the merge base. */
function addedLines(root, base, ours, file) {
  const diff = git(root, ['diff', '-U0', '--no-color', '--no-renames', base, ours, '--', file], true).stdout;
  const added = new Set();
  for (const line of diff.split('\n')) {
    if (line.startsWith('+') && !line.startsWith('+++')) added.add(line.slice(1));
  }
  return added;
}

/** Apply `replace` to every line when `only` is null, or to the lines in `only`. */
function rewrite(root, file, only, replace) {
  const text = readText(root, file);
  if (text === null) return false;
  const next = text.split('\n').map((line) => (only === null || only.has(line) ? replace(line) : line)).join('\n');
  if (next === text) return false;
  fs.writeFileSync(path.join(root, file), next);
  return true;
}

function writeCounter(root, file, value, width) {
  fs.writeFileSync(path.join(root, file), `${String(value).padStart(width, '0')}\n`);
}

/** Collisions of one kind: PR files whose id another tree file also holds. Returns [{ id, slug, files }]. */
function findCollisions(treeFiles, addedFiles, pattern) {
  const byId = new Map();
  for (const file of treeFiles) {
    const m = pattern.exec(file);
    if (!m) continue;
    const key = pattern === ADR_FILE ? file : `${m[1]}-${m[2]}`;
    if (!byId.has(m[1])) byId.set(m[1], new Set());
    byId.get(m[1]).add(key);
  }
  const mine = new Map();
  for (const file of addedFiles) {
    const m = pattern.exec(file);
    if (!m) continue;
    const key = pattern === ADR_FILE ? file : `${m[1]}-${m[2]}`;
    if (!mine.has(key)) mine.set(key, { id: m[1], slug: m[2], files: [] });
    mine.get(key).files.push(file);
  }
  return [...mine.values()]
    .filter((entry) => [...byId.get(entry.id)].some((key) => !mine.has(key)))
    .sort((a, b) => (a.id + a.slug).localeCompare(b.id + b.slug));
}

/**
 * Renumber the colliding ADRs and backlog entries that the PR added. Returns one record per change.
 * Throws, and leaves the staged state for the caller to abort, if git fails.
 */
export function renumberCollisions({ root = process.cwd(), ours, theirs } = {}) {
  const oursRef = ours ?? 'HEAD^1';
  const theirsRef = theirs ?? 'HEAD^2';
  if (git(root, ['rev-parse', '-q', '--verify', theirsRef], true).status !== 0) return [];
  const base = git(root, ['merge-base', oursRef, theirsRef]).stdout.trim();
  const added = lines(git(root, ['diff', '-z', '--no-renames', '--name-only', '--diff-filter=A', base, oursRef]).stdout);
  const changed = lines(git(root, ['diff', '-z', '--no-renames', '--name-only', '--diff-filter=AM', base, oursRef]).stdout);
  const tree = lines(git(root, ['ls-files', '-z']).stdout);
  const changes = [];
  const touched = new Set();

  const adrCounter = readCounter(root, ADR_COUNTER);
  const adrWidth = adrCounter ? adrCounter.length : 4;
  const adrCollisions = findCollisions(tree, added, ADR_FILE);
  if (adrCollisions.length > 0) {
    let next = Math.max(adrCounter ? Number(adrCounter) : 0, ...tree.map((f) => (ADR_FILE.exec(f) ? Number(ADR_FILE.exec(f)[1]) + 1 : 0)));
    for (const entry of adrCollisions) {
      const from = entry.id;
      const to = String(next++).padStart(adrWidth, '0');
      const oldFile = entry.files[0];
      const newFile = `docs/adr/${to}-${entry.slug}.md`;
      git(root, ['mv', '--', oldFile, newFile]);
      const slugOld = new RegExp(`(?<!\\d)${from}-${escapeRe(entry.slug)}`, 'g');
      const numRef = new RegExp(`ADR-${from}(?!\\d)`, 'g');
      const title = new RegExp(`^(title: "ADR )${Number(from)}(:)`);
      const replace = (line) => line.replace(slugOld, `${to}-${entry.slug}`).replace(numRef, `ADR-${to}`).replace(title, `$1${Number(to)}$2`);
      rewrite(root, newFile, null, replace);
      touched.add(newFile);
      for (const file of changed) {
        if (file === oldFile || file === newFile || file === BACKLOG_INDEX || file === ADR_COUNTER) continue;
        const only = addedLines(root, base, oursRef, file);
        if (only.size > 0 && rewrite(root, file, only, replace)) touched.add(file);
      }
      changes.push({ kind: 'adr', from, to });
    }
    writeCounter(root, ADR_COUNTER, next, adrWidth);
    touched.add(ADR_COUNTER);
  }

  const backlogCounter = readCounter(root, BACKLOG_COUNTER);
  const backlogWidth = backlogCounter ? backlogCounter.length : 7;
  const backlogCollisions = findCollisions(tree, added, BACKLOG_FILE);
  if (backlogCollisions.length > 0) {
    const highest = Math.max(0, ...tree.map((f) => (BACKLOG_FILE.exec(f) ? Number(BACKLOG_FILE.exec(f)[1]) + 1 : 0)));
    let next = Math.max(backlogCounter ? Number(backlogCounter) : 0, highest);
    for (const entry of backlogCollisions) {
      const from = entry.id;
      const to = String(next++).padStart(backlogWidth, '0');
      const oldDir = `plan/backlog/${from}-${entry.slug}`;
      const newDir = `plan/backlog/${to}-${entry.slug}`;
      git(root, ['mv', '--', oldDir, newDir]);
      const idRef = new RegExp(`(?<!\\d)${from}(?!\\d)`, 'g');
      const replace = (line) => line.replace(idRef, to);
      for (const file of entry.files) {
        const moved = file.replace(oldDir, newDir);
        rewrite(root, moved, null, replace);
        touched.add(moved);
      }
      for (const file of changed) {
        if (file.startsWith(`${oldDir}/`) || file === BACKLOG_INDEX || file === BACKLOG_COUNTER) continue;
        const only = addedLines(root, base, oursRef, file);
        if (only.size > 0 && rewrite(root, file, only, replace)) touched.add(file);
      }
      changes.push({ kind: 'backlog', from, to });
    }
    writeCounter(root, BACKLOG_COUNTER, next, backlogWidth);
    touched.add(BACKLOG_COUNTER);
    const index = spawnSync(process.execPath, [path.join(HERE, 'backlog-index.mjs'), '--root', root], { encoding: 'utf8' });
    if (index.status !== 0) throw new Error(`${BACKLOG_INDEX}: backlog-index failed: ${(index.stderr || index.stdout).trim()}`);
    touched.add(BACKLOG_INDEX);
  }

  if (touched.size > 0) git(root, ['add', '-A', '--', ...touched]);
  return changes;
}
