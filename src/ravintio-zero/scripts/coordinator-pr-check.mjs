#!/usr/bin/env node
// Decides whether a coordinator PR may skip the full suite (0000399, ADR-0297).
//
// Usage: node coordinator-pr-check.mjs <base-commit> [--root dir] [--base branch]
//   --root  the repository folder. Default is the current folder.
//   --base  the initiative branch. The script lists its open PRs with `gh pr list` (GH_BIN overrides gh).
//           It prints `overlap: #{n} {path}` for each file that a feat/ PR and this branch both change,
//           and exits 1. It skips this branch and the files the merge queue resolves itself (0000456).
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
import { isShared } from './shared-files.mjs';

const HERE = path.dirname(fileURLToPath(import.meta.url));

function fail(message) {
  process.stderr.write(`coordinator-pr-check: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const opts = { base: null, root: process.cwd(), prBase: null };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--root') {
      if (i + 1 >= argv.length) fail('--root needs a value');
      opts.root = argv[++i];
    } else if (arg === '--base') {
      if (i + 1 >= argv.length) fail('--base needs a value');
      opts.prBase = argv[++i];
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

/** Open feat/ PRs on the initiative branch that change a file this branch changes. */
function findOverlaps(opts, files) {
  const gh = process.env.GH_BIN || 'gh';
  const listed = spawnSync(gh, ['pr', 'list', '--base', opts.prBase, '--state', 'open', '--json', 'number,headRefName,files'], { cwd: opts.root, encoding: 'utf8' });
  if (listed.status !== 0) fail(`gh pr list failed: ${(listed.stderr || '').trim()}`);
  let prs;
  try {
    prs = JSON.parse(listed.stdout);
  } catch {
    fail('gh pr list printed text that is not JSON');
  }
  const current = git(opts.root, ['rev-parse', '--abbrev-ref', 'HEAD'])[0];
  const mine = new Set(files.filter((file) => !isShared(file)));
  const lines = [];
  for (const pr of prs) {
    if (!pr.headRefName.startsWith('feat/') || pr.headRefName === current) continue;
    for (const file of pr.files ?? []) {
      if (mine.has(file.path)) lines.push(`overlap: #${pr.number} ${file.path}`);
    }
  }
  return lines;
}

const opts = parseArgs(process.argv.slice(2));
const files = changedFiles(opts.root, opts.base);

if (opts.prBase !== null) {
  const overlaps = findOverlaps(opts, files);
  if (overlaps.length > 0) {
    console.log(overlaps.join('\n'));
    process.exit(1);
  }
}

if (files.every((file) => file.startsWith('plan/'))) {
  runBacklogCheck(opts.root);
  await runChartParse(opts.root);
  console.log('plan-only');
} else {
  console.log('full-suite');
}
