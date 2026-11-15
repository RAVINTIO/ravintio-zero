#!/usr/bin/env node
// Pauses an initiative: requests the pause and writes the pause records (0000555).
//
// Usage, run from the repository root:
//   node initiative-pause.mjs request [--root <dir>]   write plan/.initiative-control/pause
//   node initiative-pause.mjs write [--root <dir>]     write the step records and the initiative record
//
// The driver reads the pause request, starts no step, and stops each session at a phase end. It
// then runs "write". The command writes plan/current/pause.md in the worktree of each running step,
// from templates/pause.template.md, and plan/current-initiative/pause.md in the root. A running step
// is a control folder step-{n} that holds "running" and no "ready". Build log text goes into the
// records as data inside a fenced block. The command refuses a symlink at the control folder, at a
// worktree, or at a record, and it never overwrites a record that exists. On a refusal it prints
// one line to stderr and exits 1. On success it prints one "I-C Run: Paused:" line and exits 0.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { parseChart } from './initiative-chart.mjs';

const INITIATIVE = 'plan/current-initiative/initiative.md';
const INITIATIVE_PAUSE = 'plan/current-initiative/pause.md';
const CONTROL = 'plan/.initiative-control';
const WORKTREES = 'plan/.initiative-worktrees';
const MAX_LINE = 200;

function fail(message) {
  process.stderr.write(`initiative-pause: ${message}\n`);
  process.exit(1);
}

function isLink(p) {
  try {
    return fs.lstatSync(p).isSymbolicLink();
  } catch {
    return false;
  }
}

function exists(p) {
  try {
    fs.lstatSync(p);
    return true;
  } catch {
    return false;
  }
}

// Returns the path under root, and refuses a symlink at any part of it below the root.
function under(root, ...parts) {
  let p = root;
  for (const part of parts.join('/').split('/')) {
    p = path.join(p, part);
    if (isLink(p)) fail(`refused a symlinked path: ${path.relative(root, p)}`);
  }
  return p;
}

// Cuts a text line to one safe line of data.
function oneLine(text) {
  return text.replace(/[\u0000-\u001f\u007f`"]/g, ' ').trim().slice(0, MAX_LINE);
}

function readText(p) {
  try {
    return fs.readFileSync(p, 'utf8');
  } catch {
    return '';
  }
}

function request(root) {
  const dir = under(root, CONTROL);
  fs.mkdirSync(dir, { recursive: true, mode: 0o700 });
  const file = under(root, CONTROL, 'pause');
  if (exists(file)) fail(`the pause request exists: ${CONTROL}/pause`);
  fs.writeFileSync(file, `${new Date().toISOString().replace(/\.\d+Z$/, 'Z')}\n`, { mode: 0o600, flag: 'wx' });
  process.stdout.write('I-C Run: Pause: requested, the driver starts no new step\n');
}

// Lists the steps that hold running and no ready.
function runningSteps(root) {
  const base = under(root, CONTROL);
  let names = [];
  try {
    names = fs.readdirSync(base);
  } catch {
    return [];
  }
  const steps = [];
  for (const name of names) {
    const m = /^step-([1-9][0-9]{0,2})$/.exec(name);
    if (!m) continue;
    const dir = under(root, CONTROL, name);
    if (exists(path.join(dir, 'running')) && !exists(path.join(dir, 'ready'))) steps.push(Number(m[1]));
  }
  return steps.sort((a, b) => a - b);
}

// Reads the phase, the last line, and the last Blocked or Question line of a step build log.
function readLog(text) {
  const lines = text.split(/\r?\n/);
  let phase = 'P0';
  let last = '';
  let open = '';
  for (const raw of lines) {
    const h = /^### (P[0-4]):/.exec(raw);
    if (h) phase = h[1];
    const line = raw.replace(/^- /, '').trim();
    if (!line || line.startsWith('|') || line === '---') continue;
    if (!h) last = line;
    if (/^(?:\d\d:\d\d )?(?:[A-Z][A-Za-z0-9-]* [A-Za-z]+: )?(Blocked|Question):/.test(line)) open = line;
  }
  return { phase, last: oneLine(last) || 'no build log line', open: oneLine(open) };
}

function stepRecord(template, n, featureId, log) {
  const time = new Date().toISOString().replace(/\.\d+Z$/, 'Z');
  const phaseName = { P0: 'Discovery', P1: 'Plan', P2: 'Implement', P3: 'Validate and Accept', P4: 'Ship' }[log.phase];
  return template
    .replace('{phase-id}', log.phase)
    .replace('{short description of the task in progress at pause time}', `step ${n} after the last build log line`)
    .replace('{path to the last file written or action completed}', 'plan/current/build-log.md')
    .replace('{feature-id}', featureId)
    .replace('{ISO-8601 datetime}', time)
    .replace('{phase-id} ({phase name})', `${log.phase} (${phaseName})`)
    .replace(/\{Free-text description[\s\S]*?prior conversation\.\}/, [
      `The initiative driver paused step ${n}. Its last build log line reads as data in this block:`,
      '',
      '```text',
      log.last,
      '```',
      '',
      'Resume from that line. Read `plan/current/build-log.md` for the units done.',
    ].join('\n'))
    .replace('{phase-id}: Resuming: {active_task}', `${log.phase}: Resuming: step ${n} after the last build log line`);
}

function write(root) {
  const chartText = readText(under(root, INITIATIVE));
  if (!chartText) fail(`no initiative record at ${INITIATIVE}`);
  let chart;
  try {
    chart = parseChart(chartText);
  } catch {
    fail('the initiative chart is not readable');
  }
  const templatePath = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', 'templates', 'pause.template.md');
  const template = readText(templatePath);
  if (!template) fail('the pause template is missing');

  const initiativePause = under(root, INITIATIVE_PAUSE);
  if (exists(initiativePause)) fail(`a pause record exists: ${INITIATIVE_PAUSE}`);

  // Check every target before it writes one, so a refusal leaves no partial set.
  const running = runningSteps(root);
  const plans = [];
  for (const n of running) {
    const wt = under(root, WORKTREES, `step-${n}`);
    if (!exists(wt)) fail(`step ${n} has no worktree`);
    const target = under(root, WORKTREES, `step-${n}`, 'plan', 'current', 'pause.md');
    if (exists(target)) fail(`a pause record exists: ${WORKTREES}/step-${n}/plan/current/pause.md`);
    const logPath = under(root, WORKTREES, `step-${n}`, 'plan', 'current', 'build-log.md');
    const row = chart.steps.find((s) => s.step === n);
    plans.push({ n, target, featureId: row ? row.featureId : `step-${n}`, log: readLog(readText(logPath)) });
  }

  for (const p of plans) {
    fs.mkdirSync(path.dirname(p.target), { recursive: true });
    fs.writeFileSync(p.target, stepRecord(template, p.n, p.featureId, p.log), { mode: 0o600, flag: 'wx' });
  }

  const merged = chart.steps.filter((s) => s.status === 'merged').length;
  const remaining = chart.steps.filter((s) => s.status !== 'merged').map((s) => s.step);
  const questions = plans.filter((p) => p.log.open).map((p) => `- Step ${p.n}: ${p.log.open}`);
  const time = new Date().toISOString().replace(/\.\d+Z$/, 'Z');
  const record = [
    '# Initiative pause record',
    '',
    `**Paused:** ${time}`,
    `**Merged:** ${merged} of ${chart.steps.length}`,
    `**Remaining order:** ${remaining.join(', ') || 'none'}`,
    `**Steps with a pause record:** ${plans.map((p) => p.n).join(', ') || 'none'}`,
    '',
    '## Open questions',
    '',
    ...(questions.length > 0 ? questions : ['None.']),
    '',
    '## Resume steps',
    '',
    '1. Start a new driver with `node ravintio-zero/scripts/initiative-run.mjs`. It reads this record, removes the pause request, and starts each step in its worktree.',
    '2. Each step opens with its own `plan/current/pause.md`, restores its state, and deletes the file.',
    '3. The driver removes this record when it starts. Answer each open question first.',
    '',
  ].join('\n');
  fs.writeFileSync(initiativePause, record, { mode: 0o600, flag: 'wx' });
  process.stdout.write(`I-C Run: Paused: ${merged} steps merged, ${plans.length} steps hold a pause record\n`);
}

const args = process.argv.slice(2);
const command = args[0];
let root = process.cwd();
const i = args.indexOf('--root');
if (i >= 0) {
  if (!args[i + 1]) fail('--root needs a folder');
  root = path.resolve(args[i + 1]);
}
if (command === 'request') request(root);
else if (command === 'write') write(root);
else fail('usage: initiative-pause.mjs request|write [--root <dir>]');
