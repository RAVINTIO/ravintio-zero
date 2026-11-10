#!/usr/bin/env node
// Syncs the installed pack copy from the pack source (0000397 REQ-002).
//
// Usage: node sync-installed.mjs [--check] [--root dir]
//   --check  write nothing. Exit 1 if ravintio-zero/ differs from src/ravintio-zero/.
//   --root   the repository folder. Default is `git rev-parse --show-toplevel`.
//
// With no flag it replaces ravintio-zero/ with a plain file copy of src/ravintio-zero/.
// It deletes target files the source no longer has and keeps the executable bit.
// It refuses to run when either folder is a symlink, and it ignores `.git`.

import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';

function die(message) {
  process.stderr.write(`sync-installed: ${message}\n`);
  process.exit(2);
}

const args = process.argv.slice(2);
let check = false;
let root = null;
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--check') check = true;
  else if (args[i] === '--root') root = args[++i];
  else die(`unknown argument ${args[i]}`);
}
if (args.includes('--root') && !root) die('--root needs a folder');
if (!root) {
  try {
    root = execFileSync('git', ['rev-parse', '--show-toplevel'], { encoding: 'utf8' }).trim();
  } catch {
    die('not inside a git repository');
  }
}

const src = path.join(root, 'src', 'ravintio-zero');
const dst = path.join(root, 'ravintio-zero');

function isSymlink(p) {
  try { return fs.lstatSync(p).isSymbolicLink(); } catch { return false; }
}
if (isSymlink(src)) die(`${src} is a symlink`);
if (isSymlink(dst)) die(`${dst} is a symlink`);
if (!fs.existsSync(src) || !fs.statSync(src).isDirectory()) die(`${src} is not a folder`);

// Maps relative path to 'dir', 'file', or 'link'.
function walk(base) {
  const out = new Map();
  if (!fs.existsSync(base)) return out;
  const visit = (rel) => {
    for (const e of fs.readdirSync(path.join(base, rel), { withFileTypes: true })) {
      if (e.name === '.git') continue;
      const r = rel ? `${rel}/${e.name}` : e.name;
      if (e.isSymbolicLink()) out.set(r, 'link');
      else if (e.isDirectory()) { out.set(r, 'dir'); visit(r); }
      else out.set(r, 'file');
    }
  };
  visit('');
  return out;
}

const s = walk(src);
const d = walk(dst);

const diffs = [];
for (const [r, kind] of s) {
  if (!d.has(r)) { diffs.push(`missing: ${r}`); continue; }
  if (d.get(r) !== kind) { diffs.push(`differs: ${r}`); continue; }
  if (kind === 'file') {
    const a = fs.readFileSync(path.join(src, r));
    const b = fs.readFileSync(path.join(dst, r));
    if (!a.equals(b)) diffs.push(`differs: ${r}`);
  }
}
for (const r of d.keys()) if (!s.has(r)) diffs.push(`extra: ${r}`);

if (check) {
  for (const line of diffs) process.stdout.write(`${line}\n`);
  process.exit(diffs.length ? 1 : 0);
}

// Refresh: remove extras and changed kinds, deepest first, then copy.
const extras = [...d.keys()].filter((r) => !s.has(r) || s.get(r) !== d.get(r));
extras.sort((a, b) => b.length - a.length);
for (const r of extras) fs.rmSync(path.join(dst, r), { recursive: true, force: true });
fs.mkdirSync(dst, { recursive: true });
const rels = [...s.keys()].sort();
for (const r of rels) {
  const from = path.join(src, r);
  const to = path.join(dst, r);
  const kind = s.get(r);
  if (kind === 'dir') fs.mkdirSync(to, { recursive: true });
  else if (kind === 'link') die(`${from} is a symlink`);
  else {
    fs.copyFileSync(from, to);
    fs.chmodSync(to, fs.statSync(from).mode & 0o777);
  }
}
process.stdout.write(`synced ${rels.filter((r) => s.get(r) === 'file').length} files\n`);
