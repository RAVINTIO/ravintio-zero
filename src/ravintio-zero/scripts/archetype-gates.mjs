#!/usr/bin/env node
// P3 archetype gate check (feature 0000391, REQ-006, ADR-0291 and ADR-0294).
//
// Usage: node archetype-gates.mjs [--root dir]
// Exit 0 when every gate passes or none is installed. Exit 1 on any failed gate.
// Output: one "PASS <gate>" or "FAIL <gate>: <detail>" line per gate, then a summary line.
//
// Installed archetypes: ravintio-overrides/archetypes.json. Accepted shapes:
//   ["constraint/strict-testing"]
//   {"installed": ["constraint/strict-testing"]}
//   {"installed": [{"kind": "constraint", "name": "strict-testing"}]}
//
// Manifest lookup (first hit wins), each holding archetype.json:
//   ravintio-overrides/archetypes/{kind}/{name}/
//   ravintio-zero/archetypes/{kind}/{name}/
//
// Gate fields. ADR-0291 names the manifest `gates` list and ADR-0294 names the three
// types. Neither fixes the per-gate fields, so this script uses:
//   gates: [{ "id": string, "type": string, ...params }]
//   file-per-component: "path"   a path under the root with {id}, last segment may use *
//   min-value:          "report" a JSON file path, "key" a dotted path to a number, "min" a number
//   allowlist:          "allow"  the permitted stack entries (case-insensitive)
//
// A component API is a src/{id}/component.yml with a top-level `apiSpec` value, or a
// src/{id}/docs/openapi* file. The id is the folder name.
//
// The stack is the comma-separated list on the "- Stack:" line of plan/current/design.md.
// The "build target" entry is a deployment note, so the allowlist gate skips it.

import fs from 'node:fs';
import path from 'node:path';

const args = process.argv.slice(2);
const ri = args.indexOf('--root');
const root = path.resolve(ri >= 0 && args[ri + 1] ? args[ri + 1] : process.cwd());

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function installedList() {
  const file = path.join(root, 'ravintio-overrides', 'archetypes.json');
  if (!fs.existsSync(file)) return [];
  const data = readJson(file);
  const list = Array.isArray(data) ? data : (data.installed || []);
  return list.map((e) => (typeof e === 'string' ? e : `${e.kind}/${e.name}`));
}

function loadManifest(ref) {
  const dirs = [
    path.join(root, 'ravintio-overrides', 'archetypes', ref),
    path.join(root, 'ravintio-zero', 'archetypes', ref),
  ];
  for (const d of dirs) {
    const f = path.join(d, 'archetype.json');
    if (fs.existsSync(f)) return readJson(f);
  }
  return null;
}

function componentApis() {
  const src = path.join(root, 'src');
  if (!fs.existsSync(src)) return [];
  const ids = [];
  for (const id of fs.readdirSync(src).sort()) {
    const dir = path.join(src, id);
    if (!fs.statSync(dir).isDirectory()) continue;
    const yml = path.join(dir, 'component.yml');
    let api = false;
    if (fs.existsSync(yml)) {
      api = /^apiSpec:\s*\S+/m.test(fs.readFileSync(yml, 'utf8'));
    }
    const docs = path.join(dir, 'docs');
    if (!api && fs.existsSync(docs)) {
      api = fs.readdirSync(docs).some((n) => n.startsWith('openapi'));
    }
    if (api) ids.push(id);
  }
  return ids;
}

function globExists(rel) {
  const full = path.join(root, rel);
  const dir = path.dirname(full);
  const base = path.basename(full);
  if (!base.includes('*')) return fs.existsSync(full);
  if (!fs.existsSync(dir)) return false;
  const re = new RegExp('^' + base.split('*').map((s) => s.replace(/[.+?^${}()|[\]\\]/g, '\\$&')).join('.*') + '$');
  return fs.readdirSync(dir).some((n) => re.test(n));
}

function stackEntries() {
  const file = path.join(root, 'plan', 'current', 'design.md');
  if (!fs.existsSync(file)) return null;
  const m = fs.readFileSync(file, 'utf8').match(/^[-*]\s*Stack:\s*(.+)$/m);
  if (!m) return [];
  return m[1].split(',').map((s) => s.trim()).filter((s) => s && !/^build target\b/i.test(s));
}

const checks = {
  'file-per-component'(g) {
    const missing = componentApis().filter((id) => !globExists(g.path.replaceAll('{id}', id)));
    return missing.map((id) => `component ${id} has no file at ${g.path.replaceAll('{id}', id)}`);
  },
  'min-value'(g) {
    const file = path.join(root, g.report);
    if (!fs.existsSync(file)) return [`report ${g.report} is missing`];
    let v = readJson(file);
    for (const k of String(g.key).split('.')) v = v == null ? undefined : v[k];
    if (typeof v !== 'number') return [`report ${g.report} has no number at ${g.key}`];
    return v < g.min ? [`value ${v} at ${g.key} in ${g.report} is below the minimum ${g.min}`] : [];
  },
  allowlist(g) {
    const entries = stackEntries();
    if (entries === null) return ['plan/current/design.md is missing'];
    const allow = new Set((g.allow || []).map((a) => a.toLowerCase()));
    return entries.filter((e) => !allow.has(e.toLowerCase())).map((e) => `stack entry ${e} is not on the allowlist`);
  },
};

const results = [];
for (const ref of installedList()) {
  const manifest = loadManifest(ref);
  if (!manifest) {
    results.push({ id: ref, errors: [`manifest for ${ref} not found`] });
    continue;
  }
  for (const g of manifest.gates || []) {
    const id = g.id || `${ref}:${g.type}`;
    const fn = checks[g.type];
    results.push({ id, errors: fn ? fn(g) : [`unknown gate type ${g.type}`] });
  }
}

if (results.length === 0) {
  console.log('archetype gates: no gates installed');
  process.exit(0);
}

let failed = 0;
for (const r of results) {
  if (r.errors.length === 0) {
    console.log(`PASS ${r.id}`);
    continue;
  }
  failed += 1;
  for (const e of r.errors) console.log(`FAIL ${r.id}: ${e}`);
}
console.log(`archetype gates: ${results.length - failed} passed, ${failed} failed`);
process.exit(failed > 0 ? 1 : 0);
