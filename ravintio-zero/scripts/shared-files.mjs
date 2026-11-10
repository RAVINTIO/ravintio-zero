#!/usr/bin/env node
// Resolves conflicts on shared files during the merge queue's base merge (0000456, ADR-0302).
//
// Usage (module): resolveSharedConflicts({ root }) -> the list of paths it resolved.
//   root  the repository folder with a merge in progress. Default is the current folder.
//
// Every merged step edits a few files that other open step PRs also edit. This module acts only on
// the conflicted paths in ALLOWLIST. In the merge, "ours" is the PR branch and "theirs" is the base.
//   - A counter file takes the higher number.
//   - plan/backlog/index.md is rebuilt with backlog-index.mjs.
//   - A living doc keeps the PR branch's `Last updated:` line and the table rows that either side added.
// Any other conflicted path, or a hunk the module cannot read, throws. The caller aborts the merge.
// Every git call takes an argument array. The module treats file text as data.

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const HERE = path.dirname(fileURLToPath(import.meta.url));

export const COUNTERS = ['plan/backlog/.next-id', 'docs/adr/.next-id'];
export const BACKLOG_INDEX = 'plan/backlog/index.md';
export const LIVING_DOCS = ['docs/decisions-index.md', 'docs/architecture-overview.md'];
export const ALLOWLIST = [...COUNTERS, BACKLOG_INDEX, ...LIVING_DOCS];

/** True when the queue resolves this repo-relative path itself. */
export function isShared(file) {
  return ALLOWLIST.includes(file);
}

function git(root, args) {
  const result = spawnSync('git', ['-C', root, ...args], { encoding: 'utf8' });
  if (result.error) throw new Error(`git ${args[0]} failed: ${result.error.message}`);
  return result;
}

function gitOut(root, args) {
  const result = git(root, args);
  if (result.status !== 0) throw new Error(`git ${args[0]} failed: ${result.stderr.trim()}`);
  return result.stdout;
}

function conflictedPaths(root) {
  const lines = gitOut(root, ['ls-files', '-u']).split('\n').filter((l) => l !== '');
  return [...new Set(lines.map((l) => l.split('\t')[1]))];
}

/** The text of a file at merge stage 1 (base), 2 (ours), or 3 (theirs). Empty if the stage is absent. */
function stageText(root, stage, file) {
  const result = git(root, ['show', `:${stage}:${file}`]);
  return result.status === 0 ? result.stdout : '';
}

function resolveCounter(root, file) {
  const ours = stageText(root, 2, file).trim();
  const theirs = stageText(root, 3, file).trim();
  if (!/^\d+$/.test(ours) || !/^\d+$/.test(theirs)) throw new Error(`${file}: a counter is not a whole number`);
  const higher = Number(theirs) > Number(ours) ? theirs : ours;
  fs.writeFileSync(path.join(root, file), `${higher}\n`);
}

function resolveBacklogIndex(root) {
  // Start from the PR branch's text so the file has no markers, then rebuild it from the merged entries.
  fs.writeFileSync(path.join(root, BACKLOG_INDEX), stageText(root, 2, BACKLOG_INDEX));
  const result = spawnSync(process.execPath, [path.join(HERE, 'backlog-index.mjs'), '--root', root], { encoding: 'utf8' });
  if (result.status !== 0) throw new Error(`${BACKLOG_INDEX}: backlog-index failed: ${(result.stderr || result.stdout).trim()}`);
}

const isRow = (line) => line.startsWith('|');
const isUpdated = (line) => line.startsWith('Last updated:');

/** Resolve one diff3 hunk. Returns the lines to keep, or null if the hunk is not safe. */
function resolveHunk(ours, base, theirs) {
  if (ours.every(isUpdated) && theirs.every(isUpdated) && ours.length > 0 && theirs.length > 0) return ours;
  const rows = [...ours, ...base, ...theirs];
  if (!rows.every(isRow)) return null;
  // Both sides must have kept every base row, so each side only added rows.
  if (!base.every((line) => ours.includes(line) && theirs.includes(line))) return null;
  return [...new Set([...ours, ...theirs])];
}

/** Merge three file versions with git merge-file --diff3, resolving each conflict hunk. */
function resolveLivingDoc(root, file) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'shared-files-'));
  try {
    const names = ['ours', 'base', 'theirs'];
    names.forEach((name, i) => fs.writeFileSync(path.join(dir, name), stageText(root, [2, 1, 3][i], file)));
    const merged = spawnSync('git', ['merge-file', '-p', '--diff3', ...names.flatMap((n) => ['-L', n]), ...names.map((n) => path.join(dir, n))], { encoding: 'utf8' });
    if (merged.status === null || merged.status < 0 || merged.status > 127) throw new Error(`${file}: git merge-file failed`);
    const out = [];
    let section = 'text';
    let hunk = { ours: [], base: [], theirs: [] };
    for (const line of merged.stdout.split('\n')) {
      if (line.startsWith('<<<<<<< ')) { section = 'ours'; hunk = { ours: [], base: [], theirs: [] }; continue; }
      if (section !== 'text' && line.startsWith('||||||| ')) { section = 'base'; continue; }
      if (section !== 'text' && line === '=======') { section = 'theirs'; continue; }
      if (section !== 'text' && line.startsWith('>>>>>>> ')) {
        const kept = resolveHunk(hunk.ours, hunk.base, hunk.theirs);
        if (kept === null) throw new Error(`${file}: a conflict hunk is not a Last updated line or added table rows`);
        out.push(...kept);
        section = 'text';
        continue;
      }
      if (section === 'text') out.push(line);
      else hunk[section].push(line);
    }
    fs.writeFileSync(path.join(root, file), out.join('\n'));
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
}

/**
 * Resolve the allowlisted conflicts of the merge in progress and stage each file.
 * Throws, and changes no file, if any conflicted path is outside the allowlist.
 */
export function resolveSharedConflicts({ root = process.cwd() } = {}) {
  const conflicted = conflictedPaths(root);
  const outside = conflicted.filter((file) => !isShared(file));
  if (outside.length > 0) throw new Error(`conflict in ${outside.join(', ')}, which the queue does not resolve`);
  const resolved = [];
  for (const file of conflicted) {
    if (file === BACKLOG_INDEX) continue;
    if (COUNTERS.includes(file)) resolveCounter(root, file);
    else resolveLivingDoc(root, file);
    gitOut(root, ['add', '--', file]);
    resolved.push(file);
  }
  // The index comes last because it reads every entry in the merged tree.
  if (conflicted.includes(BACKLOG_INDEX)) {
    resolveBacklogIndex(root);
    gitOut(root, ['add', '--', BACKLOG_INDEX]);
    resolved.push(BACKLOG_INDEX);
  }
  return resolved;
}
