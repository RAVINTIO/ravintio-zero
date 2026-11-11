#!/usr/bin/env node
// Applies literal text edits listed in a JSON spec file (0000474 REQ-003, ADR-0316).
//
// Usage: node bulk-edit.mjs <spec.json> [--root dir] [--dry-run]
//   The spec is { "edits": [ { "file": "path", "from": "text", "to": "text" } ] }.
//   Each edit replaces every literal occurrence of `from` with `to`. The replacement is plain
//   text, so `$`, `&`, and backslashes in `to` mean themselves.
//   The script prints "edited: {file} ({count})" for a changed file and "unchanged: {file}"
//   when `from` is absent. With --dry-run it prints the same lines and writes nothing.
//   It checks every edit before it writes. An absolute path, a `..` segment, a symlink, a
//   missing file, or an empty `from` prints the reason on stderr and exits 1 with no write.
//   A missing or malformed spec exits 2.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

function die(code, message) {
  process.stderr.write(`bulk-edit: ${message}\n`);
  process.exit(code);
}

function parseArgs(argv) {
  const opts = { spec: null, root: process.cwd(), dryRun: false };
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--root') opts.root = argv[++i] ?? '';
    else if (argv[i] === '--dry-run') opts.dryRun = true;
    else if (!opts.spec && !argv[i].startsWith('--')) opts.spec = argv[i];
    else die(2, 'usage: bulk-edit.mjs <spec.json> [--root dir] [--dry-run]');
  }
  if (!opts.spec) die(2, 'usage: bulk-edit.mjs <spec.json> [--root dir] [--dry-run]');
  return opts;
}

function readSpec(file) {
  let data;
  try {
    data = JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch {
    die(2, 'the spec is missing or is not valid JSON');
  }
  if (!data || !Array.isArray(data.edits) || data.edits.length === 0) die(2, 'the spec needs a non-empty "edits" list');
  for (const e of data.edits) {
    if (!e || typeof e.file !== 'string' || typeof e.from !== 'string' || typeof e.to !== 'string') {
      die(2, 'each edit needs string "file", "from", and "to" fields');
    }
  }
  return data.edits;
}

// Returns a reason string when the edit is unsafe, or '' when it is fine.
function check(root, edit) {
  if (edit.from === '') return `${edit.file}: "from" is empty`;
  if (path.isAbsolute(edit.file) || edit.file.split(/[\\/]/).includes('..')) return `${edit.file}: the path is not inside the root`;
  const full = path.join(root, edit.file);
  let st;
  try {
    st = fs.lstatSync(full);
  } catch {
    return `${edit.file}: the file does not exist`;
  }
  if (st.isSymbolicLink() || !st.isFile()) return `${edit.file}: the path is a symlink or not a plain file`;
  return '';
}

// Literal replace with split and join, so no replacement pattern applies.
export function replaceAll(text, from, to) {
  const parts = text.split(from);
  return { text: parts.join(to), count: parts.length - 1 };
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  const edits = readSpec(opts.spec);
  const problems = edits.map((e) => check(opts.root, e)).filter(Boolean);
  if (problems.length > 0) {
    for (const p of problems) process.stderr.write(`bulk-edit: ${p}\n`);
    process.exit(1);
  }
  const pending = new Map();
  const lines = [];
  for (const e of edits) {
    const full = path.join(opts.root, e.file);
    const current = pending.has(full) ? pending.get(full) : fs.readFileSync(full, 'utf8');
    const r = replaceAll(current, e.from, e.to);
    if (r.count === 0) {
      lines.push(`unchanged: ${e.file}`);
      continue;
    }
    pending.set(full, r.text);
    lines.push(`edited: ${e.file} (${r.count})`);
  }
  if (!opts.dryRun) for (const [full, text] of pending) fs.writeFileSync(full, text);
  process.stdout.write(`${lines.join('\n')}\n`);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
