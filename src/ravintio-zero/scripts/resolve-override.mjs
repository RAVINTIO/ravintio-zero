#!/usr/bin/env node
// Resolves a standard or template: an override in ravintio-overrides/ wins over the pack copy,
// unless protected.json says a hook enforces the file. ADR-0292.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const PACK_ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const KINDS = ['standards', 'templates'];

function loadProtected(packRoot) {
  try {
    return JSON.parse(fs.readFileSync(path.join(packRoot, 'archetypes', 'protected.json'), 'utf8'));
  } catch {
    return {};
  }
}

export function resolveOverride(kind, name, { root = process.cwd() } = {}) {
  if (!KINDS.includes(kind)) {
    return { path: null, source: 'pack', reason: `unknown kind ${kind}`, unsafe: true };
  }
  const packRoot = fs.existsSync(path.join(root, 'ravintio-zero')) ? path.join(root, 'ravintio-zero') : PACK_ROOT;
  const rel = String(name ?? '');
  const norm = path.posix.normalize(rel.replace(/\\/g, '/'));
  if (!rel || path.isAbsolute(rel) || norm === '..' || norm.startsWith('../') || rel.includes('\0')) {
    return { path: null, source: 'pack', reason: 'path leaves the folder', unsafe: true };
  }
  const packPath = path.join(packRoot, kind, norm);
  const overridePath = path.join(root, 'ravintio-overrides', kind, norm);

  let st;
  try {
    st = fs.lstatSync(overridePath);
  } catch {
    return { path: packPath, source: 'pack', reason: 'no override' };
  }
  if (st.isSymbolicLink()) {
    return { path: packPath, source: 'pack', reason: 'override is a symlink', unsafe: true };
  }
  if (!st.isFile()) return { path: packPath, source: 'pack', reason: 'override is not a file' };

  const entry = loadProtected(packRoot)[`${kind}/${norm}`];
  if (entry?.mode === 'ignore') {
    return { path: packPath, source: 'pack', reason: 'protected: a hook enforces this file' };
  }
  if (entry?.mode === 'require') {
    const lines = new Set(fs.readFileSync(overridePath, 'utf8').split(/\r?\n/).map((l) => l.replace(/^[-*]\s+/, '').trim()));
    const missing = (entry.pinned ?? []).find((p) => !lines.has(p));
    if (missing !== undefined) {
      return { path: packPath, source: 'pack', reason: `protected: override drops a pinned line: ${missing}` };
    }
  }
  return { path: overridePath, source: 'override', reason: 'override found' };
}

if (process.argv[1] && fs.realpathSync(process.argv[1]) === fs.realpathSync(fileURLToPath(import.meta.url))) {
  const args = process.argv.slice(2);
  let root = process.cwd();
  const pos = [];
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--root') root = path.resolve(args[++i] ?? '');
    else pos.push(args[i]);
  }
  if (pos.length !== 2) {
    console.error('usage: resolve-override.mjs <standards|templates> <file> [--root dir]');
    process.exit(2);
  }
  const r = resolveOverride(pos[0], pos[1], { root });
  if (r.unsafe) {
    console.error(`refused: ${r.reason}`);
    process.exit(1);
  }
  console.log(r.path);
}
