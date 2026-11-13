#!/usr/bin/env node
// Decides whether a coordinator PR may skip the full suite (0000399, ADR-0297).
//
// Usage: node coordinator-pr-check.mjs <base-commit> [--root dir]
//   --root  the repository folder. Default is the current folder.
//
// If every file changed since the base is under plan/, it runs the plan format checks.
// Those are backlog-index --check and the chart parse. It then prints `plan-only`.
// If any other file changed, it prints `full-suite` and runs no check. Both cases exit 0.
// A failed check prints the reason on stderr and exits 1.
// Changed files include committed, staged, unstaged, and untracked files.

import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath, pathToFileURL } from 'node:url';

const HERE = path.dirname(fileURLToPath(import.meta.url));

function fail(message) {
  process.stderr.write(`coordinator-pr-check: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const opts = { base: null, root: process.cwd() };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--root') {
      if (i + 1 >= argv.length) fail('--root needs a value');
      opts.root = argv[++i];
    } else if (arg.startsWith('--')) fail(`unknown argument ${arg}`);
    else if (opts.base === null) opts.base = arg;
    else fail(`unexpected argument ${arg}`);
  }
  if (opts.base === null) fail('a base commit is required');
  return opts;
}

function git(root, args) {
  const result = spawnSync('git', ['-C', root, ...args], { encoding: 'utf8' });
  if (result.status !== 0) fail(`git ${args[0]} failed: ${result.stderr.trim()}`);
  return result.stdout.split('\n').filter((line) => line !== '');
}

function changedFiles(root, base) {
  const tracked = git(root, ['diff', '--name-only', '--no-renames', base, '--']);
  const untracked = git(root, ['ls-files', '--others', '--exclude-standard']);
  return [...new Set([...tracked, ...untracked])];
}

function runBacklogCheck(root) {
  const script = path.join(HERE, 'backlog-index.mjs');
  const result = spawnSync(process.execPath, [script, '--root', root, '--check'], { encoding: 'utf8' });
  if (result.status !== 0) fail(`backlog-index --check failed: ${(result.stderr || result.stdout).trim()}`);
}

async function runChartParse(root) {
  const chart = path.join(root, 'plan', 'current-initiative', 'initiative.md');
  if (!fs.existsSync(chart)) return;
  const { parseChart } = await import(pathToFileURL(path.join(HERE, 'initiative-chart.mjs')).href);
  try {
    parseChart(fs.readFileSync(chart, 'utf8'));
  } catch (err) {
    fail(`chart parse failed: ${err.message}`);
  }
}

const opts = parseArgs(process.argv.slice(2));
const files = changedFiles(opts.root, opts.base);

if (files.every((file) => file.startsWith('plan/'))) {
  runBacklogCheck(opts.root);
  await runChartParse(opts.root);
  console.log('plan-only');
} else {
  console.log('full-suite');
}
