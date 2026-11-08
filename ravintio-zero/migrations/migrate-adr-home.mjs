#!/usr/bin/env node
// migrate-adr-home.mjs - Move every ADR into docs/adr under a repo-wide four-digit number (0000384).
// Run from the project root, the folder that holds ravintio-zero/.
// Usage: node migrate-adr-home.mjs [--dry-run] [--root <dir>] [--no-restore] [--include-current]
//   --dry-run          print the plan and write nothing
//   --root <dir>       act on <dir> instead of the current folder (tests)
//   --no-restore       skip phase 1, the restore of features 0000001 to 0000029 from git history
//   --include-current  also take the ADRs in plan/current/adr
// Idempotent: docs/adr/.migration-map.json records the old-to-new map. A rerun reuses it.
// Exit 1 if a Supersedes or Superseded by reference names a number with no file.

import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';

const opts = { dryRun: false, root: process.cwd(), restore: true, current: false };
const argv = process.argv.slice(2);
for (let i = 0; i < argv.length; i++) {
  const a = argv[i];
  if (a === '--dry-run') opts.dryRun = true;
  else if (a === '--no-restore') opts.restore = false;
  else if (a === '--include-current') opts.current = true;
  else if (a === '--root') {
    if (i + 1 >= argv.length) die('--root needs a folder');
    opts.root = path.resolve(argv[++i]);
  } else die(`unknown argument ${a}`);
}

function die(msg) {
  process.stderr.write(`migrate-adr-home: ${msg}\n`);
  process.exit(1);
}
const log = (m) => process.stdout.write(`${m}\n`);
const R = (...p) => path.join(opts.root, ...p);
const pad = (n, w) => String(n).padStart(w, '0');

for (const p of ['plan', 'docs', 'docs/adr']) {
  try {
    if (fs.lstatSync(R(p)).isSymbolicLink()) die(`${p} is a symlink. Nothing was written`);
  } catch { /* absent is fine */ }
}

let changed = 0;
function writeIfChanged(file, text) {
  let old = null;
  try { old = fs.readFileSync(file, 'utf8'); } catch { /* new file */ }
  if (old === text) return;
  changed++;
  log(`${opts.dryRun ? 'Would write' : 'Wrote'} ${path.relative(opts.root, file)}`);
  if (opts.dryRun) return;
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, text);
}
function remove(file) {
  changed++;
  log(`${opts.dryRun ? 'Would remove' : 'Removed'} ${path.relative(opts.root, file)}`);
  if (!opts.dryRun) fs.rmSync(file, { force: true });
}

// ---- Sources -------------------------------------------------------------
const FILE_RE = /^ADR-(\d+)-(.+)\.md$/;
const items = [];

function readdir(p) {
  try { return fs.readdirSync(p).sort(); } catch { return []; }
}

const archive = R('plan', '_archive');
const present = new Set();
for (const dir of readdir(archive)) {
  const fm = /^(\d{7})-/.exec(dir);
  if (!fm) continue;
  const adrDir = path.join(archive, dir, 'adr');
  for (const f of readdir(adrDir)) {
    const m = FILE_RE.exec(f);
    if (!m) continue;
    const full = path.join(adrDir, f);
    present.add(`${fm[1]}:${pad(m[1], 3)}`);
    items.push({
      fid: fm[1], feature: dir.replace(/-\d{4}-\d{2}-\d{2}$/, ''), n: Number(m[1]), slug: m[2],
      text: fs.readFileSync(full, 'utf8'), src: full, restored: false, readme: path.join(adrDir, 'README.md'),
    });
  }
}

if (opts.current) {
  const dir = R('plan', 'current', 'adr');
  for (const f of readdir(dir)) {
    const m = FILE_RE.exec(f);
    if (!m) continue;
    const full = path.join(dir, f);
    const text = fs.readFileSync(full, 'utf8');
    const fe = /\*\*Feature:\*\*\s*(\S+)/.exec(text);
    const feature = fe ? fe[1] : '9999999-current';
    const fid = (/^(\d{7})/.exec(feature) || [, '9999999'])[1];
    items.push({ fid, feature, n: Number(m[1]), slug: m[2], text, src: full, restored: false, readme: path.join(dir, 'README.md') });
  }
}

// ---- Map -----------------------------------------------------------------
const mapFile = R('docs', 'adr', '.migration-map.json');
let map = {};
let mapExisted = false;
try { map = JSON.parse(fs.readFileSync(mapFile, 'utf8')); mapExisted = true; } catch { /* first run */ }

// ---- Phase 1: restore from git history ------------------------------------
const skippedFeatures = [];
if (opts.restore && !mapExisted) {
  const found = new Set();
  let out = '';
  try {
    out = execFileSync('git', ['-C', opts.root, 'log', '--diff-filter=D', '--name-only', '-z', '--format=%x01%H',
      '--', 'plan/_archive/*/adr/ADR-*.md'], { stdio: ['ignore', 'pipe', 'ignore'], maxBuffer: 256 * 1024 * 1024 }).toString();
  } catch { out = ''; }
  const seen = new Set();
  for (const chunk of out.split('\x01').slice(1)) {
    const parts = chunk.split('\0').filter((s) => s !== '' && s !== '\n');
    const sha = parts[0].replace(/\n/g, '').trim();
    for (const p of parts.slice(1)) {
      const file = p.replace(/^\n/, '');
      const m = /^plan\/_archive\/((\d{7})-[^/]+)\/adr\/(ADR-(\d+)-(.+)\.md)$/.exec(file);
      if (!m) continue;
      const fidNum = Number(m[2]);
      if (fidNum < 1 || fidNum > 29) continue;
      if (seen.has(file)) continue;
      if (fs.existsSync(R(file))) continue;
      seen.add(file);
      let text;
      try {
        text = execFileSync('git', ['-C', opts.root, 'show', `${sha}^:${file}`],
          { stdio: ['ignore', 'pipe', 'ignore'], maxBuffer: 64 * 1024 * 1024 }).toString();
      } catch { continue; }
      found.add(m[2]);
      items.push({
        fid: m[2], feature: m[1].replace(/-\d{4}-\d{2}-\d{2}$/, ''), n: Number(m[4]), slug: m[5],
        text, src: null, restored: true, readme: null,
      });
    }
  }
  for (let i = 1; i <= 29; i++) {
    const id = pad(i, 7);
    if (!found.has(id) && ![...present].some((k) => k.startsWith(`${id}:`))) skippedFeatures.push(id);
  }
  if (skippedFeatures.length) log(`No ADRs in git history for features: ${skippedFeatures.join(', ')}`);
}

// ---- Phase 2: number ------------------------------------------------------
items.sort((a, b) => (a.fid < b.fid ? -1 : a.fid > b.fid ? 1 : a.n - b.n || (a.slug < b.slug ? -1 : 1)));

let highest = 0;
for (const v of Object.values(map)) highest = Math.max(highest, Number(v.number));
for (const f of readdir(R('docs', 'adr'))) {
  const m = /^(\d{4})-.*\.md$/.exec(f);
  if (m) highest = Math.max(highest, Number(m[1]));
}
for (const it of items) {
  const key = `${it.fid}:${pad(it.n, 3)}`;
  it.key = key;
  if (!map[key]) {
    highest++;
    map[key] = { number: pad(highest, 4), file: `${pad(highest, 4)}-${it.slug}.md` };
  }
  it.number = map[key].number;
  it.file = map[key].file;
}

// ---- Rewrite --------------------------------------------------------------
function rewrite(text, fid) {
  let out = text.replace(/\b(\d{7})(?:-| )ADR(?:-| )(\d{1,3})\b/g, (all, f, n) => {
    const e = map[`${f}:${pad(n, 3)}`];
    return e ? `ADR-${e.number}` : all;
  });
  out = out.replace(/(?<!\d{7}[ -])\bADR-(\d{3})\b/g, (all, n) => {
    const e = map[`${fid}:${n}`];
    return e ? `ADR-${e.number}` : all;
  });
  return out;
}

function productId() {
  try {
    const m = /^id:\s*"?([^"\s#]+)"?/m.exec(fs.readFileSync(R('product.yml'), 'utf8'));
    if (m) return m[1];
  } catch { /* fall through */ }
  for (const d of readdir(R('src'))) {
    try {
      const m = /^id:\s*"?([^"\s#]+)"?/m.exec(fs.readFileSync(R('src', d, 'component.yml'), 'utf8'));
      if (m) return m[1];
    } catch { /* next */ }
  }
  return null;
}
const component = productId();

function frontMatter(text) {
  const m = /^---\r?\n([\s\S]*?)\r?\n---(\r?\n|$)/.exec(text);
  return m ? { block: m[1], end: m[0].length } : null;
}
function fmGet(block, key) {
  const m = new RegExp(`^${key}:\\s*(.*?)\\r?$`, 'm').exec(block);
  return m ? m[1].replace(/^"(.*)"$/, '$1') : null;
}
function setFm(text, key, value, replace) {
  const fm = frontMatter(text);
  const line = `${key}: "${value}"`;
  if (!fm) {
    const title = (/^#\s+(.*)$/m.exec(text) || [, 'ADR'])[1];
    const st = (/\*\*Status:\*\*\s*(\w+)/i.exec(text) || [, 'accepted'])[1].toLowerCase();
    return `---\ntitle: "${title.replace(/"/g, "'")}"\nstatus: "${st}"\n${line}\n---\n${text}`;
  }
  const re = new RegExp(`^${key}:.*$`, 'm');
  if (re.test(fm.block)) return replace ? text.replace(re, line) : text;
  const eol = text.includes('\r\n') ? '\r\n' : '\n';
  const head = text.slice(0, 4 + fm.block.length);
  return `${head}${eol}${line}${text.slice(4 + fm.block.length)}`;
}

for (const it of items) {
  const target = R('docs', 'adr', it.file);
  if (fs.existsSync(target)) continue;
  let text = rewrite(it.text, it.fid);
  text = setFm(text, 'component', component, false);
  text = setFm(text, 'feature', it.feature, true);
  if (component === null) text = it.text; // no id known: keep the text without a component line
  it.out = text;
  writeIfChanged(target, text);
}
if (component === null) log('Warning: no product id found, so no component field was added.');

// ---- Replace sources with links -------------------------------------------
const byReadme = new Map();
for (const it of items) {
  if (!it.src) continue;
  if (fs.existsSync(it.src)) remove(it.src);
  if (!byReadme.has(it.readme)) byReadme.set(it.readme, []);
  byReadme.get(it.readme).push(it.file);
}
for (const [readme, files] of byReadme) {
  const prior = (() => { try { return fs.readFileSync(readme, 'utf8'); } catch { return ''; } })();
  const have = (prior.match(/\d{4}-[^\s,]+?\.md/g) || []);
  const all = [...new Set([...have, ...files])].sort();
  writeIfChanged(readme, `ADRs moved to docs/adr/. See ${all.join(', ')}.\n`);
}

writeIfChanged(mapFile, `${JSON.stringify(map, null, 2)}\n`);

// ---- Index and counter ------------------------------------------------------
function cell(s) { return String(s || '').replace(/\r?\n/g, ' ').replace(/\|/g, '\\|').trim(); }
function adrFiles() {
  const names = new Set(readdir(R('docs', 'adr')).filter((f) => /^\d{4}-.*\.md$/.test(f)));
  if (opts.dryRun) for (const it of items) names.add(it.file);
  return [...names].sort();
}
const rows = [];
for (const f of adrFiles()) {
  const it = items.find((x) => x.file === f);
  let text;
  try { text = fs.readFileSync(R('docs', 'adr', f), 'utf8'); } catch { text = it && it.out ? it.out : ''; }
  const fm = frontMatter(text);
  const block = fm ? fm.block : '';
  let title = fmGet(block, 'title') || (/^#\s+(.*)$/m.exec(text) || [, f])[1];
  title = title.replace(/^ADR[ -]?\d+\s*[:-]\s*/i, '');
  rows.push(`| [ADR-${f.slice(0, 4)}](adr/${f}) | ${cell(title)} | ${cell(fmGet(block, 'status') || 'accepted')} | ${cell(fmGet(block, 'summary'))} | ${cell(fmGet(block, 'feature'))} |`);
}
const indexFile = R('docs', 'decisions-index.md');
let header;
try {
  const cur = fs.readFileSync(indexFile, 'utf8');
  const at = cur.indexOf('## All Architecture Decision Records');
  header = at >= 0 ? cur.slice(0, at) : `${cur.replace(/\s*$/, '')}\n\n`;
} catch {
  header = '# Decisions Index\n\n> Change record. Index of all ADRs. Updated after every pipeline run.\n> Do not archive this file. Update it in place.\n\n';
}
writeIfChanged(indexFile, `${header}## All Architecture Decision Records\n\n| ADR | Title | Status | Summary | Feature |\n|-----|-------|--------|---------|---------|\n${rows.join('\n')}${rows.length ? '\n' : ''}`);

const top = rows.length ? Math.max(...adrFiles().map((f) => Number(f.slice(0, 4)))) : 0;
let counter = top + 1;
try {
  const cur = Number(fs.readFileSync(R('docs', 'adr', '.next-id'), 'utf8').trim());
  if (Number.isFinite(cur)) counter = Math.max(counter, cur);
} catch { /* none yet */ }
writeIfChanged(R('docs', 'adr', '.next-id'), `${pad(counter, 4)}\n`);

// ---- Verify ------------------------------------------------------------------
if (!opts.dryRun) {
  const files = adrFiles();
  const have = new Set(files.map((f) => f.slice(0, 4)));
  const broken = [];
  const unresolved = [];
  for (const f of files) {
    const lines = fs.readFileSync(R('docs', 'adr', f), 'utf8').split(/\r?\n/);
    let inSection = false;
    lines.forEach((line, i) => {
      if (/^##\s/.test(line)) inSection = /^##\s+Supersede(s|d By)\b/i.test(line);
      if (!inSection && !/supersede/i.test(line)) return;
      for (const m of line.matchAll(/\bADR-(\d{4})\b/g)) {
        if (!have.has(m[1])) broken.push(`${f}:${i + 1}: ADR-${m[1]}`);
      }
      for (const m of line.matchAll(/\b(\d{7})(?:-| )ADR(?:-| )(\d{1,3})\b/g)) unresolved.push(`${f}:${i + 1}: ${m[0]}`);
    });
  }
  if (unresolved.length) log(`Left as written, no ADR file exists for: ${unresolved.length} reference(s)`);
  if (broken.length) {
    process.stderr.write(`migrate-adr-home: references name a number with no file:\n${broken.join('\n')}\n`);
    process.exit(1);
  }
}
log(`${opts.dryRun ? 'Dry run: ' : ''}${changed} change(s).`);
