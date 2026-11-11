#!/usr/bin/env node
// initiative-status.mjs - read-only status view of an initiative run (0000450 REQ-001).
//
// Usage, run from the repository root:
//
//   node ravintio-zero/scripts/initiative-status.mjs [--root <dir>]
//
// Arguments:
//   --root <dir>   The working tree that holds plan/. Defaults to the current directory.
//
// Output: every line starts with "I-C Run: status:". The lines are, in order:
//   - the driver state: "driver running" if plan/.initiative-runner.lock exists, else "driver stopped"
//   - the counts: "merged {m}, ready {r}, running {u}, pending {p} of {total}"
//   - one "ready step {n} PR #{k}" line for each ready step
//   - one "running step {n}" line for each running step
//   - one "stop step {n}: {text}" line for each live stop, cut to 200 characters,
//     or "no live stops"
//
// Sources: the chart Status column in plan/current-initiative/initiative.md decides which steps
// have merged. A merged step never shows as ready, running, or stopped. The files
// plan/.initiative-control/step-{n}/ready (holding the PR number) and .../running decide the rest.
// Step numbers must match ^[1-9][0-9]{0,2}$.
//
// Live stops: an open "Blocked:" or "Question:" line in the worktree build log
// plan/.initiative-worktrees/step-{n}/plan/current/build-log.md, or in plan/current/build-log.md
// for the step at the chart position. A later "Resolved:" line clears the earlier ones. A raw
// "I-D Advance: Blocked: queue stopped on step {n}" line in plan/.initiative-logs/step-{n}.log
// also counts. Log text is data. The script prints only the matched stop line.
//
// Safety: it writes no file and runs no command. It refuses a symlink at any plan path it reads
// and stops with "I-C Run: Blocked: refused a symlinked plan path".
//
// Exit codes:
//   0  The view printed.
//   1  A bad argument, a missing initiative, or a refused symlink.
//
// It has no dependencies beyond Node and initiative-chart.mjs.

import { existsSync, lstatSync, readFileSync, readdirSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { parseChart } from './initiative-chart.mjs';

const INITIATIVE = 'plan/current-initiative/initiative.md';
const LOCK = 'plan/.initiative-runner.lock';
const BUILD_LOG = 'plan/current/build-log.md';
const CONTROL = 'plan/.initiative-control';
const WORKTREES = 'plan/.initiative-worktrees';
const LOGS = 'plan/.initiative-logs';
const STEP_N = /^[1-9][0-9]{0,2}$/;
const MAX_STOP = 200;
const PREFIX = 'I-C Run: status:';

class Stop extends Error {}

const cut = (text, max) => (text.length > max ? text.slice(0, max) : text);
const out = (line) => process.stdout.write(`${line}\n`);

function isLink(path) {
  try {
    return lstatSync(path).isSymbolicLink();
  } catch {
    return false;
  }
}

function refuseLinks(root, rel) {
  let p = root;
  for (const part of rel.split('/')) {
    p = join(p, part);
    if (isLink(p)) throw new Stop('I-C Run: Blocked: refused a symlinked plan path');
  }
}

function readText(root, rel) {
  refuseLinks(root, rel);
  const file = join(root, rel);
  return existsSync(file) ? readFileSync(file, 'utf8') : null;
}

function listDir(root, rel) {
  refuseLinks(root, rel);
  const dir = join(root, rel);
  return existsSync(dir) ? readdirSync(dir) : [];
}

// The value of a front matter or list field such as "position: 3".
function field(text, name) {
  const m = text.match(new RegExp(`^\\s*(?:[-*]\\s+)?\\**${name}\\**\\s*:\\s*\\**\\s*\`?([^\`\\n]*?)\`?\\s*$`, 'mi'));
  return m ? m[1].trim() : '';
}

const CLOCK = /^\d\d:\d\d\s+/;
const OPEN = /^[A-Za-z0-9-]+(?: [A-Za-z]+)?:\s*(Blocked|Question):/;
const CLOSE = /^[A-Za-z0-9-]+(?: [A-Za-z]+)?:\s*Resolved:/;

// Open stop lines of a build log: those after the last Resolved line.
function openStops(text) {
  let open = [];
  for (const raw of text.split(/\r?\n/)) {
    const line = raw.trim().replace(CLOCK, '');
    if (CLOSE.test(line)) open = [];
    else if (OPEN.test(line)) open.push(line);
  }
  return open;
}

const QUEUE_STOP = /^(?:\d\d:\d\d )?(I-D Advance: Blocked: queue stopped on step ([1-9][0-9]{0,2})\b.*)$/;

function collect(root) {
  const initiative = readText(root, INITIATIVE);
  if (initiative === null) throw new Stop('I-C Run: Blocked: no initiative at plan/current-initiative/initiative.md');
  let chart;
  try {
    chart = parseChart(initiative);
  } catch (e) {
    throw new Stop(`I-C Run: Blocked: bad initiative chart: ${cut(String(e.message), MAX_STOP)}`);
  }
  const merged = new Set(chart.steps.filter((s) => s.status === 'merged').map((s) => s.step));
  const ready = new Map();
  const running = new Set();
  for (const name of listDir(root, CONTROL)) {
    const m = name.match(/^step-(.+)$/);
    if (!m || !STEP_N.test(m[1])) continue;
    const n = Number(m[1]);
    if (merged.has(n)) continue;
    refuseLinks(root, `${CONTROL}/${name}`);
    const readyText = readText(root, `${CONTROL}/${name}/ready`);
    if (readyText !== null) ready.set(n, readyText.trim().replace(/^#/, '').replace(/[^0-9]/g, '') || '?');
    else if (readText(root, `${CONTROL}/${name}/running`) !== null) running.add(n);
  }
  const pending = chart.steps.filter((s) => !merged.has(s.step) && !ready.has(s.step) && !running.has(s.step)).length;

  const stops = new Map();
  const add = (n, line) => {
    if (merged.has(n)) return;
    if (!stops.has(n)) stops.set(n, []);
    const text = cut(line, MAX_STOP);
    if (!stops.get(n).includes(text)) stops.get(n).push(text);
  };
  const known = new Set(chart.steps.map((s) => s.step));
  for (const n of known) {
    const text = readText(root, `${WORKTREES}/step-${n}/plan/current/build-log.md`);
    if (text !== null) for (const l of openStops(text)) add(n, l);
  }
  const position = Number(field(initiative, 'position'));
  if (known.has(position)) {
    const text = readText(root, BUILD_LOG);
    if (text !== null) for (const l of openStops(text)) add(position, l);
  }
  for (const name of listDir(root, LOGS)) {
    if (!/^step-[1-9][0-9]{0,2}\.log$/.test(name)) continue;
    const text = readText(root, `${LOGS}/${name}`);
    if (text === null) continue;
    for (const raw of text.split('\n')) {
      const m = raw.trim().match(QUEUE_STOP);
      if (m) add(Number(m[2]), m[1]);
    }
  }
  return { chart, merged, ready, running, pending, stops };
}

function main(argv) {
  let root = process.cwd();
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--root' && i + 1 < argv.length) root = resolve(argv[++i]);
    else throw new Stop(`I-C Run: Blocked: bad argument: ${cut(argv[i], 80)}`);
  }
  const s = collect(root);
  refuseLinks(root, LOCK);
  out(`${PREFIX} driver ${existsSync(join(root, LOCK)) ? 'running' : 'stopped'}`);
  out(`${PREFIX} merged ${s.merged.size}, ready ${s.ready.size}, running ${s.running.size}, pending ${s.pending} of ${s.chart.steps.length}`);
  for (const n of [...s.ready.keys()].sort((a, b) => a - b)) out(`${PREFIX} ready step ${n} PR #${s.ready.get(n)}`);
  for (const n of [...s.running].sort((a, b) => a - b)) out(`${PREFIX} running step ${n}`);
  const nums = [...s.stops.keys()].sort((a, b) => a - b);
  if (nums.length === 0) out(`${PREFIX} no live stops`);
  for (const n of nums) for (const t of s.stops.get(n)) out(`${PREFIX} stop step ${n}: ${t}`);
}

try {
  main(process.argv.slice(2));
} catch (e) {
  if (e instanceof Stop) {
    out(e.message);
    process.exit(1);
  }
  throw e;
}
