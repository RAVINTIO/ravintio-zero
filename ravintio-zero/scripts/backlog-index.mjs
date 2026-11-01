#!/usr/bin/env node
// Generates and checks plan/backlog/index.md, and lists stale backlog entries (0000321).
//
// Usage: node backlog-index.mjs [--root dir] [--check] [--review] [--today YYYY-MM-DD]
//   --root   the repository folder. Default is the current folder.
//   --check  write nothing. Exit 1 if plan/backlog/index.md is missing or stale.
//   --review write nothing. List entries older than backlogReviewDays in product.yml (default 5).
//   --today  fixes the clock for --review. Default is today in UTC.
//
// With no mode flag it writes plan/backlog/index.md.
// It reads only the first frontmatter block and the `**Date filed:**` line of each entry.
// It treats entry text as data and never prints body text.
// A malformed entry makes it exit 1 with a `check:` line on stderr and write nothing.

import fs from 'node:fs';
import path from 'node:path';

const DEFAULT_REVIEW_DAYS = 5;
const PRIORITIES = ['high', 'medium', 'low'];
const STATUSES = ['open', 'parked'];
const THEME = /^[a-z0-9]+(-[a-z0-9]+)*$/;
const DATE = /^\d{4}-\d{2}-\d{2}$/;
const DAY_MS = 86400000;

function fail(message) {
  process.stderr.write(`backlog-index: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const opts = { root: process.cwd(), check: false, review: false, today: null };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--check') opts.check = true;
    else if (arg === '--review') opts.review = true;
    else if (arg === '--root' || arg === '--today') {
      if (i + 1 >= argv.length) fail(`${arg} needs a value`);
      opts[arg.slice(2)] = argv[++i];
    } else fail(`unknown argument ${arg}`);
  }
  if (opts.check && opts.review) fail('--check and --review cannot be combined');
  return opts;
}

// Returns a UTC day number for YYYY-MM-DD, or null if the text is not a real date.
function dayNumber(text) {
  if (!DATE.test(text)) return null;
  const ms = Date.parse(`${text}T00:00:00Z`);
  if (Number.isNaN(ms) || new Date(ms).toISOString().slice(0, 10) !== text) return null;
  return Math.floor(ms / DAY_MS);
}

function unquote(value) {
  const v = value.trim();
  const m = /^"(.*)"$/.exec(v) || /^'(.*)'$/.exec(v);
  return m ? m[1] : v;
}

// Reads the first frontmatter block and the date line. Returns { error } or the parsed entry.
function parseEntry(file) {
  let lines;
  try {
    lines = fs.readFileSync(file, 'utf8').split(/\r?\n/);
  } catch {
    return { error: 'entry.md is unreadable' };
  }
  if (lines[0] !== '---') return { error: 'frontmatter is missing' };
  const end = lines.indexOf('---', 1);
  if (end === -1) return { error: 'frontmatter is not closed' };
  const fm = {};
  for (const line of lines.slice(1, end)) {
    const m = /^(title|status|priority|theme):(.*)$/.exec(line);
    if (m && !(m[1] in fm)) fm[m[1]] = unquote(m[2]);
  }
  let filed = null;
  for (const line of lines.slice(end + 1)) {
    const m = /^\*\*Date filed:\*\*\s*(\S+)\s*$/.exec(line);
    if (m) {
      filed = dayNumber(m[1]) === null ? null : m[1];
      break;
    }
  }
  return { fm, filed };
}

function loadEntries(root) {
  const dir = path.join(root, 'plan', 'backlog');
  const entries = [];
  const problems = [];
  let names = [];
  try {
    names = fs.readdirSync(dir);
  } catch {
    return { entries, problems };
  }
  for (const name of names.sort()) {
    const m = /^(\d{7})-(.+)$/.exec(name);
    if (!m) continue;
    const folder = path.join(dir, name);
    const file = path.join(folder, 'entry.md');
    let folderStat;
    let fileStat;
    try {
      folderStat = fs.lstatSync(folder);
      fileStat = fs.lstatSync(file);
    } catch {
      continue;
    }
    if (!folderStat.isDirectory() && !folderStat.isSymbolicLink()) continue;
    const label = name;
    if (folderStat.isSymbolicLink() || fileStat.isSymbolicLink() || !fileStat.isFile()) {
      problems.push(`${label}: entry is a symlink or not a regular file`);
      continue;
    }
    const parsed = parseEntry(file);
    if (parsed.error) {
      problems.push(`${label}: ${parsed.error}`);
      continue;
    }
    const { fm, filed } = parsed;
    const priority = fm.priority === undefined || fm.priority === '' ? 'medium' : fm.priority;
    const theme = fm.theme === undefined || fm.theme === '' ? 'unsorted' : fm.theme;
    const status = fm.status === undefined || fm.status === '' ? 'open' : fm.status;
    if (!PRIORITIES.includes(priority)) problems.push(`${label}: unknown priority`);
    else if (!THEME.test(theme)) problems.push(`${label}: invalid theme`);
    else if (!STATUSES.includes(status)) problems.push(`${label}: unknown status`);
    else {
      const title = (fm.title || m[2]).replace(/^Backlog Entry: \d+ - /, '').replace(/\s+/g, ' ').trim();
      entries.push({ id: m[1], slug: m[2], name, title, priority, theme, status, filed });
    }
  }
  return { entries, problems };
}

function render(entries) {
  const themes = [...new Set(entries.map((e) => e.theme))].sort((a, b) => {
    if (a === b) return 0;
    if (a === 'unsorted') return 1;
    if (b === 'unsorted') return -1;
    return a < b ? -1 : 1;
  });
  const out = [
    '---',
    'title: "Backlog index"',
    `summary: "${entries.length} backlog entries across ${themes.length} themes."`,
    '---',
    '# Backlog index',
    '',
    'This file is generated by `node ravintio-zero/scripts/backlog-index.mjs` and CI checks it.',
  ];
  for (const theme of themes) {
    out.push('', `## ${theme}`, '', '| Id | Entry | Priority | Status | Filed |', '|----|-------|----------|--------|-------|');
    const rows = entries
      .filter((e) => e.theme === theme)
      .sort((a, b) => PRIORITIES.indexOf(a.priority) - PRIORITIES.indexOf(b.priority) || (a.id < b.id ? -1 : a.id > b.id ? 1 : 0));
    for (const e of rows) {
      const title = e.title.replace(/\|/g, '\\|');
      out.push(`| ${e.id} | ${title} | ${e.priority} | ${e.status} | ${e.filed || 'undated'} |`);
    }
  }
  return `${out.join('\n')}\n`;
}

function reviewDays(root) {
  let text;
  try {
    text = fs.readFileSync(path.join(root, 'product.yml'), 'utf8');
  } catch {
    return DEFAULT_REVIEW_DAYS;
  }
  const m = /^backlogReviewDays:[ \t]*(\S+)[ \t]*$/m.exec(text);
  return m && /^[1-9]\d*$/.test(m[1]) ? Number(m[1]) : DEFAULT_REVIEW_DAYS;
}

const opts = parseArgs(process.argv.slice(2));
const root = path.resolve(opts.root);
const { entries, problems } = loadEntries(root);

if (problems.length > 0) {
  for (const p of problems) process.stderr.write(`check: malformed entry ${p}\n`);
  process.exit(1);
}

if (opts.review) {
  let today;
  if (opts.today === null) today = Math.floor(Date.now() / DAY_MS);
  else {
    today = dayNumber(opts.today);
    if (today === null) fail(`--today needs a date as YYYY-MM-DD, got ${JSON.stringify(opts.today)}`);
  }
  const limit = reviewDays(root);
  const lines = [];
  for (const e of entries.sort((a, b) => (a.id < b.id ? -1 : a.id > b.id ? 1 : 0))) {
    if (e.filed === null) lines.push(`${e.name} undated`);
    else {
      const days = today - dayNumber(e.filed);
      if (days > limit) lines.push(`${e.name} ${days} days`);
    }
  }
  process.stdout.write(`backlog-review: ${lines.length} entries older than ${limit} days\n`);
  for (const l of lines) process.stdout.write(`${l}\n`);
  process.exit(0);
}

const text = render(entries);
const indexFile = path.join(root, 'plan', 'backlog', 'index.md');

if (opts.check) {
  let current = null;
  try {
    current = fs.readFileSync(indexFile, 'utf8');
  } catch {
    current = null;
  }
  if (current !== text) {
    fail('plan/backlog/index.md is stale. Run node ravintio-zero/scripts/backlog-index.mjs and commit the result.');
  }
  process.exit(0);
}

try {
  for (const link of [path.join(root, 'plan'), path.dirname(indexFile), indexFile]) {
    if (fs.lstatSync(link, { throwIfNoEntry: false })?.isSymbolicLink()) {
      fail(`${path.relative(root, link)} is a symlink. Replace it with a real file or folder.`);
    }
  }
  fs.mkdirSync(path.dirname(indexFile), { recursive: true });
  fs.writeFileSync(indexFile, text);
} catch (err) {
  fail(`cannot write plan/backlog/index.md: ${err.code || 'error'}`);
}
