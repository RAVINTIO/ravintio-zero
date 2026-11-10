#!/usr/bin/env node
// Writes and checks the ready file of an initiative step (0000442 REQ-001, ADR-0301).
//
// Usage:
//   node initiative-ready.mjs --pr {n}   write the PR number to $RAVINTIO_INITIATIVE_CONTROL/ready
//   node initiative-ready.mjs --check    exit 0 only if the ready file holds a PR number
//
// The number must match the pattern the driver uses. The helper refuses a symlink at the control
// folder and at the file, writes through a temporary file and a rename, and uses mode 600.
// On any failure it prints one line to stderr and exits 1. It never echoes a raw value.

import fs from 'node:fs';
import path from 'node:path';

const PR = /^[1-9][0-9]{0,6}$/;
const VAR = 'RAVINTIO_INITIATIVE_CONTROL';

function fail(message) {
  process.stderr.write(`initiative-ready: ${message}\n`);
  process.exit(1);
}

function isLink(p) {
  try {
    return fs.lstatSync(p).isSymbolicLink();
  } catch {
    return false;
  }
}

function controlDir() {
  const dir = process.env[VAR];
  if (!dir) fail(`${VAR} is not set`);
  if (isLink(dir)) fail('refused a symlinked control folder');
  let st;
  try {
    st = fs.lstatSync(dir);
  } catch {
    fail('the control folder does not exist');
  }
  if (!st.isDirectory()) fail('the control folder is not a folder');
  return dir;
}

function parse(argv) {
  const opts = { pr: null, check: false };
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--pr') {
      opts.pr = argv[++i] ?? '';
    } else if (argv[i] === '--check') {
      opts.check = true;
    } else {
      fail('usage: initiative-ready.mjs --pr {n} | --check');
    }
  }
  if (opts.check === (opts.pr !== null)) fail('usage: initiative-ready.mjs --pr {n} | --check');
  return opts;
}

const opts = parse(process.argv.slice(2));
const dir = controlDir();
const file = path.join(dir, 'ready');

if (opts.check) {
  if (isLink(file)) fail('refused a symlinked ready file');
  let text;
  try {
    text = fs.readFileSync(file, 'utf8').trim();
  } catch {
    fail('the ready file is missing');
  }
  if (!PR.test(text)) fail('the ready file does not hold a PR number');
  process.stdout.write(`initiative-ready: ready holds PR #${text}\n`);
  process.exit(0);
}

if (!PR.test(opts.pr)) fail('the PR number must be 1 to 7 digits with no leading zero');
if (isLink(file)) fail('refused a symlinked ready file');
const tmp = path.join(dir, `.ready.${process.pid}.tmp`);
try {
  fs.writeFileSync(tmp, `${opts.pr}\n`, { mode: 0o600, flag: 'wx' });
  fs.renameSync(tmp, file);
} catch (err) {
  try {
    fs.rmSync(tmp, { force: true });
  } catch {
    // Nothing to remove.
  }
  fail(`could not write the ready file (${err.code ?? 'error'})`);
}
process.stdout.write(`I-D Advance: Ready: PR #${opts.pr}\n`);
