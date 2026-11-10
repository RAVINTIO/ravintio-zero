#!/usr/bin/env node
// Adds one step to an initiative chart (0000399).
//
// Usage: node initiative-add-step.mjs --title "..." --slug kebab-case [--bump minor]
//          [--lane label] [--after 20] [--initiative path] [--root dir]
//
// It reserves two ids with reserve-id.mjs (the feature id, then the backlog id), files the
// backlog entry, rebuilds the backlog index, and appends a row for the new step to every chart
// table: Schema changes, Dependencies, Decisions, Baselines, Criteria, P1 skips, and Steps.
// The new step number is one past the last row in Steps. Existing rows keep their order.
// A table the chart lacks is skipped, except Steps, which must exist.
// Every check runs before the ids are reserved, so a failed run reserves nothing.
// No packages.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

const here = path.dirname(fileURLToPath(import.meta.url));
const BUMPS = ['major', 'minor', 'patch'];
const TABLES = ['Schema changes', 'Dependencies', 'Decisions', 'Baselines', 'Criteria', 'P1 skips', 'Steps'];

function fail(message) {
  process.stderr.write(`initiative-add-step: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const opts = { title: '', slug: '', bump: 'minor', lane: '', after: '', initiative: '', root: process.cwd() };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    const key = arg.replace(/^--/, '');
    if (!arg.startsWith('--') || !(key in opts)) fail(`unknown argument ${arg}`);
    if (i + 1 >= argv.length) fail(`${arg} needs a value`);
    opts[key] = argv[++i];
  }
  if (opts.title.trim() === '') fail('--title is required');
  if (opts.title.includes('|')) fail('--title must not hold a pipe');
  if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(opts.slug)) fail('--slug is required and must be kebab-case');
  if (!BUMPS.includes(opts.bump)) fail(`--bump must be one of ${BUMPS.join(', ')}`);
  for (const k of ['lane', 'after']) if (opts[k].includes('|')) fail(`--${k} must not hold a pipe`);
  opts.root = path.resolve(opts.root);
  opts.initiative = path.resolve(opts.root, opts.initiative || path.join('plan', 'current-initiative', 'initiative.md'));
  return opts;
}

function splitRow(line) {
  return line.trim().replace(/^\|/, '').replace(/\|$/, '').split('|').map((c) => c.trim());
}

// Finds a table under `## name`. Returns the header cells, the index of the last row, and the rows.
function findTable(lines, name) {
  const start = lines.findIndex((l) => l.trim() === `## ${name}`);
  if (start < 0) return null;
  let header = null;
  let last = -1;
  for (let i = start + 1; i < lines.length && !/^## /.test(lines[i]); i++) {
    if (!lines[i].trim().startsWith('|')) {
      if (header !== null) break;
      continue;
    }
    if (header === null) header = splitRow(lines[i]);
    last = i;
  }
  return header === null ? null : { header, last };
}

function nextStepNumber(lines, steps) {
  let max = 0;
  for (let i = steps.last; i > 0 && lines[i].trim().startsWith('|'); i--) {
    const n = Number(splitRow(lines[i])[steps.header.indexOf('Step')]);
    if (Number.isInteger(n)) max = Math.max(max, n);
  }
  return max + 1;
}

// One row for a table, filled by header name. Cells with no value say none.
function rowFor(header, values) {
  const cells = header.map((h) => (h in values ? values[h] : 'none'));
  return `| ${cells.join(' | ')} |`;
}

function run(cmd, args, cwd) {
  try {
    return execFileSync('node', [path.join(here, cmd), ...args], { cwd, stdio: 'pipe' }).toString();
  } catch (err) {
    const detail = (err.stderr ? err.stderr.toString() : '').trim();
    fail(`${cmd} failed${detail ? `: ${detail}` : ''}`);
  }
}

const opts = parseArgs(process.argv.slice(2));
let text;
try {
  text = fs.readFileSync(opts.initiative, 'utf8');
} catch {
  fail(`cannot read ${opts.initiative}`);
}
const lines = text.split('\n');
const tables = {};
for (const name of TABLES) tables[name] = findTable(lines, name);
if (tables.Steps === null) fail('the chart has no ## Steps table');
const stepNo = nextStepNumber(lines, tables.Steps);

const idFile = path.join(opts.root, 'plan', 'backlog', '.next-id');
const reserved = run('reserve-id.mjs', ['2', '--file', idFile], opts.root).trim().split('\n');
const [featureId, backlogId] = reserved;

// Escape backslashes first, then quotes, for a double-quoted YAML scalar.
function yamlQuote(text) {
  return text.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

const folder = path.join(opts.root, 'plan', 'backlog', `${backlogId}-${opts.slug}`);
fs.mkdirSync(folder, { recursive: true });
const today = new Date().toISOString().slice(0, 10);
fs.writeFileSync(path.join(folder, 'entry.md'), [
  '---',
  `title: "Backlog Entry: ${backlogId} - ${yamlQuote(opts.title)}"`,
  `summary: "${yamlQuote(opts.title)}"`,
  'status: "open"',
  'priority: "medium"',
  'theme: "initiative"',
  '---',
  `# Backlog Entry: ${backlogId} - ${opts.title}`,
  '',
  `**Source feature:** ${featureId}`,
  '**Source phase:** I-B Activate',
  '**Deferral source:** add-step helper',
  `**Date filed:** ${today}`,
  '',
  '---',
  '',
  '## Problem',
  '',
  `The initiative chart gained step ${stepNo}: ${opts.title}. Describe the work here.`,
  '',
].join('\n'));

const cells = {
  Step: String(stepNo),
  'Feature id': featureId,
  Title: opts.title,
  'Backlog entries': backlogId,
  Bump: opts.bump,
  Version: '',
  Status: 'pending',
  Lane: opts.lane,
  After: opts.after,
  'Skip P1': 'no',
  Reason: 'Added after the chart. The human sets this at P1.',
};

// Insert from the bottom up so earlier line numbers stay valid.
const found = TABLES.filter((n) => tables[n] !== null).sort((a, b) => tables[b].last - tables[a].last);
for (const name of found) {
  const t = tables[name];
  const row = rowFor(t.header, cells);
  lines.splice(t.last + 1, 0, row);
}
fs.writeFileSync(opts.initiative, lines.join('\n'));

run('backlog-index.mjs', ['--root', opts.root], opts.root);
process.stdout.write(`step ${stepNo} feature ${featureId} entry ${backlogId}-${opts.slug}\n`);
