#!/usr/bin/env node
// Records and compares the failing suites on the base commit (0000385 REQ-002).
//
// Usage:
//   node baseline-failures.mjs record <runner-output|-> [--file path]
//   node baseline-failures.mjs check  <runner-output|-> [--file path]
//
// The input is the output of run-tests.sh, read from a file or from stdin when
// the argument is "-". The script reads the suite names listed under
// "Failed suites:" (ADR-001: match by suite name).
//   record  writes the names to plan/current/baseline-failures.md and exits 0.
//   check   prints "inherited: {name}" for a suite the baseline lists and
//           "new: {name}" for any other, and exits 1 when any suite is new.
// A missing baseline file counts as an empty baseline. On any other failure the
// script prints one line to stderr and exits 2.

import fs from 'node:fs';
import path from 'node:path';

const DEFAULT_FILE = path.join('plan', 'current', 'baseline-failures.md');

function fail(message) {
  process.stderr.write(`baseline-failures: ${message}\n`);
  process.exit(2);
}

export function parseFailedSuites(text) {
  const names = [];
  let inList = false;
  for (const line of text.split(/\r?\n/)) {
    if (/^Failed suites:\s*$/.test(line)) { inList = true; continue; }
    if (!inList) continue;
    const m = /^\s{2,}(\S.*?)\s*$/.exec(line);
    if (m) names.push(m[1]);
    else inList = false;
  }
  return [...new Set(names)];
}

export function parseBaseline(text) {
  const names = [];
  for (const line of text.split(/\r?\n/)) {
    const m = /^- `([^`]+)`\s*$/.exec(line);
    if (m) names.push(m[1]);
  }
  return names;
}

function readInput(arg) {
  if (!arg) fail('record and check need a runner output file, or - for stdin');
  try {
    return fs.readFileSync(arg === '-' ? 0 : arg, 'utf8');
  } catch (err) {
    return fail(`cannot read ${arg === '-' ? 'stdin' : arg}: ${err.code || err.message}`);
  }
}

function main(argv) {
  const [mode, input, ...rest] = argv;
  let file = DEFAULT_FILE;
  for (let i = 0; i < rest.length; i++) {
    if (rest[i] === '--file') {
      if (i + 1 >= rest.length) fail('--file needs a path');
      file = rest[++i];
    } else fail(`unknown argument ${rest[i]}`);
  }
  if (mode !== 'record' && mode !== 'check') fail('first argument must be record or check');
  const current = parseFailedSuites(readInput(input));

  if (mode === 'record') {
    const body = [
      '# Baseline failures',
      '',
      'Suites that fail on the base commit. P3 reports these as inherited and stops only on other failures.',
      '',
      ...(current.length ? current.map((n) => `- \`${n}\``) : ['None.']),
      '',
    ].join('\n');
    fs.mkdirSync(path.dirname(file), { recursive: true });
    fs.writeFileSync(file, body);
    process.stdout.write(`recorded ${current.length} baseline failure(s) in ${file}\n`);
    return 0;
  }

  let baseline = [];
  try {
    baseline = parseBaseline(fs.readFileSync(file, 'utf8'));
  } catch (err) {
    if (err.code !== 'ENOENT') fail(`cannot read ${file}: ${err.code || err.message}`);
  }
  let fresh = 0;
  for (const name of current) {
    if (baseline.includes(name)) process.stdout.write(`inherited: ${name}\n`);
    else { process.stdout.write(`new: ${name}\n`); fresh++; }
  }
  return fresh > 0 ? 1 : 0;
}

if (import.meta.url === `file://${process.argv[1]}` || process.argv[1]?.endsWith('baseline-failures.mjs')) {
  process.exit(main(process.argv.slice(2)));
}
