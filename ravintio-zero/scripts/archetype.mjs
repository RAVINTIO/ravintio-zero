#!/usr/bin/env node
// Archetype command (feature 0000391, REQ-003 and REQ-004, ADR-0291 and ADR-0293).
//
// Usage: node archetype.mjs list [--root dir]
//        node archetype.mjs use <kind>/<name> [--root dir]
//
// The pack is the folder above this script. The target repo is --root (default: the current directory).
// list prints one line per archetype: "<kind>/<name>", TAB, kind, TAB, summary. Sorted by name.
// use runs every check first and writes nothing on failure. A problem prints a "clash:" or
// "threshold:" line and the command exits 1. On success it copies files/ into ravintio-overrides/,
// copies the manifest to ravintio-overrides/archetypes/<kind>/<name>/archetype.json, records the
// pick in ravintio-overrides/archetypes.json, and prints "replaces: <pack path>" for each pack file
// it replaces. The last line is "archetype use: <kind>/<name> installed" or "archetype use: nothing changed".

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const PACK = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const argv = process.argv.slice(2);
const ri = argv.indexOf('--root');
let rootArg = null;
if (ri >= 0) rootArg = argv.splice(ri, 2)[1];
const root = path.resolve(rootArg || process.cwd());
const overrides = path.join(root, 'ravintio-overrides');
const NAME = /^[a-z0-9][a-z0-9._-]*$/i;

function fail(lines) {
  for (const l of lines) console.log(l);
  process.exit(1);
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function parseRef(ref) {
  const parts = String(ref ?? '').split('/');
  if (parts.length !== 2 || !parts.every((p) => NAME.test(p) && p !== '.' && p !== '..' && !p.includes('..'))) return null;
  return { kind: parts[0], name: parts[1], ref: parts.join('/') };
}

function catalogue() {
  const out = [];
  const base = path.join(PACK, 'archetypes');
  for (const kind of fs.existsSync(base) ? fs.readdirSync(base).sort() : []) {
    const kd = path.join(base, kind);
    if (!fs.statSync(kd).isDirectory()) continue;
    for (const name of fs.readdirSync(kd).sort()) {
      const f = path.join(kd, name, 'archetype.json');
      if (fs.existsSync(f)) out.push({ ref: `${kind}/${name}`, kind, name, manifest: readJson(f) });
    }
  }
  return out.sort((a, b) => (a.ref < b.ref ? -1 : a.ref > b.ref ? 1 : 0));
}

function filesOf(ref) {
  const base = path.join(PACK, 'archetypes', ref, 'files');
  const out = [];
  const walk = (dir, rel) => {
    if (!fs.existsSync(dir)) return;
    for (const e of fs.readdirSync(dir).sort()) {
      const full = path.join(dir, e);
      const st = fs.lstatSync(full);
      if (st.isSymbolicLink()) fail([`clash: ${ref} carries a symlink at ${rel ? `${rel}/` : ''}${e}`]);
      if (st.isDirectory()) walk(full, rel ? `${rel}/${e}` : e);
      else out.push(rel ? `${rel}/${e}` : e);
    }
  };
  walk(base, '');
  return out;
}

function installedRefs() {
  const file = path.join(overrides, 'archetypes.json');
  if (!fs.existsSync(file)) return [];
  const data = readJson(file);
  const list = Array.isArray(data) ? data : (data.installed || []);
  return list.map((e) => (typeof e === 'string' ? e : `${e.kind}/${e.name}`));
}

function manifestOf(ref) {
  for (const d of [path.join(overrides, 'archetypes', ref), path.join(PACK, 'archetypes', ref)]) {
    const f = path.join(d, 'archetype.json');
    if (fs.existsSync(f)) return readJson(f);
  }
  return {};
}

// True when the path or any parent between the root and it is a symlink.
function hasSymlink(target) {
  let cur = root;
  for (const seg of path.relative(root, target).split(path.sep)) {
    cur = path.join(cur, seg);
    try {
      if (fs.lstatSync(cur).isSymbolicLink()) return true;
    } catch {
      return false;
    }
  }
  return false;
}

function list() {
  for (const a of catalogue()) console.log(`${a.ref}\t${a.kind}\t${a.manifest.summary ?? ''}`);
}

function use(input) {
  const p = parseRef(input);
  if (!p) fail([`error: ${input ?? ''} is not a kind/name pick`]);
  const entry = catalogue().find((a) => a.ref === p.ref);
  if (!entry) fail([`error: unknown archetype ${p.ref}`]);
  const m = entry.manifest;
  const installed = installedRefs();
  const wasInstalled = installed.includes(p.ref);
  const others = installed.filter((r) => r !== p.ref);
  const problems = [];

  // Check 1: slots.
  for (const o of others) {
    const shared = (m.slots ?? []).filter((s) => (manifestOf(o).slots ?? []).includes(s));
    for (const s of shared) problems.push(`clash: ${p.ref} and ${o} both claim slot ${s}`);
  }
  // Check 2: files.
  const files = filesOf(p.ref);
  for (const o of others) {
    const theirs = new Set(filesOf(o));
    for (const f of files) if (theirs.has(f)) problems.push(`clash: ${p.ref} and ${o} both carry ${f}`);
  }
  // Check 3: thresholds.
  for (const o of others) {
    const t = manifestOf(o).thresholds ?? {};
    for (const [k, v] of Object.entries(m.thresholds ?? {})) {
      if (k in t && v < t[k]) problems.push(`threshold: ${p.ref} sets ${k} to ${v}, below ${t[k]} from ${o}`);
    }
  }
  // Check 4: destinations.
  const plan = [];
  const dests = files.map((f) => ({ src: path.join(PACK, 'archetypes', p.ref, 'files', f), rel: f, dest: path.join(overrides, f) }));
  dests.push({ src: path.join(PACK, 'archetypes', p.ref, 'archetype.json'), rel: `archetypes/${p.ref}/archetype.json`, dest: path.join(overrides, 'archetypes', p.ref, 'archetype.json'), manifest: true });
  for (const d of dests) {
    if (hasSymlink(d.dest)) {
      problems.push(`clash: ${path.relative(root, d.dest)} is a symlink`);
      continue;
    }
    const want = fs.readFileSync(d.src);
    if (fs.existsSync(d.dest)) {
      const have = fs.readFileSync(d.dest);
      if (have.equals(want)) continue;
      if (!wasInstalled && !d.manifest) {
        problems.push(`clash: ${path.relative(root, d.dest)} is your own override`);
        continue;
      }
      if (wasInstalled && !d.manifest) continue; // keep the developer's edits to an installed file
    }
    plan.push({ ...d, want });
  }
  if (hasSymlink(path.join(overrides, 'archetypes.json'))) problems.push('clash: ravintio-overrides/archetypes.json is a symlink');
  if (problems.length) fail(problems);

  // Writes.
  const lines = [];
  for (const d of plan) {
    fs.mkdirSync(path.dirname(d.dest), { recursive: true });
    fs.writeFileSync(d.dest, d.want);
    if (!d.manifest && fs.existsSync(path.join(PACK, d.rel))) lines.push(`replaces: ravintio-zero/${d.rel}`);
  }
  let changed = plan.length > 0;
  if (!wasInstalled) {
    const next = [...installed, p.ref].sort();
    fs.mkdirSync(overrides, { recursive: true });
    fs.writeFileSync(path.join(overrides, 'archetypes.json'), `${JSON.stringify({ installed: next }, null, 2)}\n`);
    changed = true;
  }
  for (const l of lines) console.log(l);
  console.log(changed ? `archetype use: ${p.ref} installed` : 'archetype use: nothing changed');
}

const [cmd, arg] = argv;
if (cmd === 'list') list();
else if (cmd === 'use') use(arg);
else fail(['usage: archetype.mjs list | use <kind>/<name> [--root dir]']);
