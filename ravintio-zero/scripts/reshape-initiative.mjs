#!/usr/bin/env node
// Rebuilds an initiative branch as one titled commit per step, then one chore commit, on a new branch (0000353).
//
// Usage: node reshape-initiative.mjs --branch initiative/{id}-{slug} [--root dir] [--base ref] [--chart path]
//          [--assign {hash}={step}]... [--chore-number n] [--tags] [--push] [--remote name]
//   --branch        the branch to reshape. Required.
//   --root          the repository folder. Default is the current folder.
//   --base          the base ref. Default origin/main. The replay starts at the merge base of --base and --branch.
//   --chart         the initiative chart. Default is plan/current-initiative/initiative.md under the root.
//   --assign        an admin commit and the step it aligns with. Repeat the option for more commits.
//                   The commit folds into that step's new commit. Unassigned admin lands only in the chore commit.
//   --chore-number  the number in the chore commit subject. Default is the newest number on a non-step commit.
//   --tags          move each step tag to its new commit: delete the local tag, then create it again with the same message.
//   --push          push the new branch, delete each old tag on the remote, push each new tag. Implies --tags.
//   --remote        the remote name for --push. Default origin.
//
// The script reads the `## Steps` table of the chart by column name: `Feature id`, `Title`, and `Version`.
// It finds each step commit through the tag `v{Version}`. It replays the steps in chart order with
// `git merge-tree --write-tree` and writes commits with `git commit-tree`, so it never touches a working tree
// or an index. The new branch is `{branch}-reshaped`. The old branch stays as it is.
// A conflict, a missing tag, a bad name, or an existing target branch exits 1 and writes no branch.
// The script never force-pushes. It moves a tag on a remote by deleting it, then pushing a new tag.

import { execFileSync, spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

function fail(message) {
  process.stderr.write(`reshape-initiative: ${message}\n`);
  process.exit(1);
}

const BRANCH_RE = /^[A-Za-z0-9][A-Za-z0-9._/-]*$/;
const TAG_RE = /^v\d+\.\d+(\.\d+)?$/;
const HASH_RE = /^[0-9a-f]{4,40}$/;

function parseArgs(argv) {
  const opts = {
    root: process.cwd(), branch: '', base: 'origin/main', chart: '', assign: [],
    choreNumber: '', tags: false, push: false, remote: 'origin',
  };
  const valued = { '--root': 'root', '--branch': 'branch', '--base': 'base', '--chart': 'chart',
    '--chore-number': 'choreNumber', '--remote': 'remote' };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--tags') opts.tags = true;
    else if (arg === '--push') opts.push = true;
    else if (arg === '--assign' || arg in valued) {
      if (i + 1 >= argv.length) fail(`${arg} needs a value`);
      const value = argv[++i];
      if (arg === '--assign') opts.assign.push(value);
      else opts[valued[arg]] = value;
    } else fail(`unknown argument ${arg}`);
  }
  if (opts.push) opts.tags = true;
  return opts;
}

const opts = parseArgs(process.argv.slice(2));

if (!opts.branch) fail('--branch is required');
if (!BRANCH_RE.test(opts.branch) || opts.branch.includes('..')) fail(`bad branch name: ${opts.branch}`);
if (!BRANCH_RE.test(opts.remote)) fail(`bad remote name: ${opts.remote}`);
if (opts.choreNumber && !/^\d+$/.test(opts.choreNumber)) fail('--chore-number needs digits');

function git(args, extra = {}) {
  return execFileSync('git', ['-C', opts.root, ...args], {
    encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'], ...extra,
  });
}

function gitOk(args) {
  try { git(args); return true; } catch { return false; }
}

function resolveCommit(ref, what) {
  try {
    return git(['rev-parse', '--verify', '--quiet', `${ref}^{commit}`]).trim();
  } catch {
    return fail(`${what} not found: ${ref}`);
  }
}

// merge-tree --write-tree needs git 2.38.
const probe = spawnSync('git', ['merge-tree', '--write-tree', '--help'], { encoding: 'utf8' });
const gitVersion = (/(\d+)\.(\d+)/.exec(spawnSync('git', ['--version'], { encoding: 'utf8' }).stdout) || []).slice(1).map(Number);
if (probe.error || gitVersion.length < 2 || gitVersion[0] < 2 || (gitVersion[0] === 2 && gitVersion[1] < 38)) {
  fail('git 2.38 or later is needed for `git merge-tree --write-tree`');
}

const newBranch = `${opts.branch}-reshaped`;
const head = resolveCommit(`refs/heads/${opts.branch}`, 'branch');
const baseCommit = resolveCommit(opts.base, 'base');
if (gitOk(['show-ref', '--verify', '--quiet', `refs/heads/${newBranch}`])) fail(`branch already exists: ${newBranch}`);

// The chart.
function cells(line) {
  return line.trim().replace(/^\|/, '').replace(/\|$/, '').split('|').map((c) => c.trim());
}

function parseChart(path) {
  if (!existsSync(path)) fail(`chart not found: ${path}`);
  const text = readFileSync(path, 'utf8');
  const heading = /^# Initiative: (\d{7}) - /m.exec(text);
  if (!heading) fail('chart heading `# Initiative: {7 digits} - ...` not found');
  const lines = text.split('\n');
  const start = lines.findIndex((l) => /^##\s+Steps\s*$/.test(l));
  if (start < 0) fail('chart has no `## Steps` section');
  const rows = [];
  for (let i = start + 1; i < lines.length; i++) {
    if (/^##\s/.test(lines[i])) break;
    if (lines[i].trim().startsWith('|')) rows.push(cells(lines[i]));
  }
  if (rows.length === 0) fail('`## Steps` has no table');
  const header = rows[0];
  const col = {};
  for (const name of ['Feature id', 'Title', 'Version']) {
    col[name] = header.indexOf(name);
    if (col[name] < 0) fail(`\`## Steps\` table has no \`${name}\` column`);
  }
  const steps = rows.slice(1)
    .filter((r) => !r.every((c) => /^:?-+:?$/.test(c)))
    .map((r, i) => {
      const featureId = /^\d{7}/.exec(r[col['Feature id']] ?? '')?.[0];
      if (!featureId) fail(`step ${i + 1} has no 7-digit Feature id`);
      const version = r[col.Version] ?? '';
      const tag = `v${version}`;
      if (!TAG_RE.test(tag)) fail(`step ${i + 1} has no usable Version: ${version}`);
      return { n: i + 1, title: `${featureId}: ${r[col.Title] ?? ''}`, tag };
    });
  if (steps.length === 0) fail('`## Steps` lists no step');
  return { initiativeId: heading[1], steps };
}

const chartPath = opts.chart || join(opts.root, 'plan', 'current-initiative', 'initiative.md');
const { initiativeId, steps } = parseChart(chartPath);

// The old history, oldest first.
const mergeBase = (() => {
  try { return git(['merge-base', baseCommit, head]).trim(); } catch { return fail(`no merge base between ${opts.base} and ${opts.branch}`); }
})();
const old = git(['log', '--first-parent', '--reverse', '--format=%H%x09%s', `${mergeBase}..${head}`])
  .split('\n').filter(Boolean).map((line) => {
    const tab = line.indexOf('\t');
    return { hash: line.slice(0, tab), subject: line.slice(tab + 1) };
  });
const position = new Map(old.map((c, i) => [c.hash, i]));

function numberOf(subject) {
  const at = subject.lastIndexOf(' (#');
  if (at < 0 || !subject.endsWith(')')) return '';
  const digits = subject.slice(at + 3, -1);
  return digits.length > 0 && [...digits].every((ch) => ch >= '0' && ch <= '9') ? digits : '';
}

const short = (c) => `${c.hash.slice(0, 7)} ${c.subject}`;

// Step commits through their tags.
let previousIndex = -1;
for (const step of steps) {
  let commit;
  try {
    commit = git(['rev-parse', '--verify', '--quiet', `refs/tags/${step.tag}^{commit}`]).trim();
  } catch {
    fail(`step ${step.n} has no tag ${step.tag}`);
  }
  if (!position.has(commit)) fail(`step ${step.n} tag ${step.tag} does not point at a first-parent commit of ${opts.branch}`);
  if (position.get(commit) <= previousIndex) fail(`step ${step.n} tag ${step.tag} is out of chart order`);
  previousIndex = position.get(commit);
  step.commit = old[previousIndex];
  step.number = numberOf(step.commit.subject);
  if (!step.number) fail(`step ${step.n} commit has no (#n) in its subject: ${short(step.commit)}`);
  step.admin = [];
}

// Assigned admin commits.
const stepHashes = new Set(steps.map((s) => s.commit.hash));
for (const item of opts.assign) {
  const eq = item.indexOf('=');
  const hashText = eq < 0 ? '' : item.slice(0, eq);
  const stepText = eq < 0 ? '' : item.slice(eq + 1);
  if (!HASH_RE.test(hashText) || !/^\d+$/.test(stepText)) fail(`bad --assign value: ${item}`);
  const full = resolveCommit(hashText, '--assign commit');
  if (!position.has(full)) fail(`--assign commit is not on the first-parent line of ${opts.branch}: ${hashText}`);
  if (stepHashes.has(full)) fail(`--assign commit is a step commit: ${hashText}`);
  const step = steps[Number(stepText) - 1];
  if (!step) fail(`--assign names a step that the chart lacks: ${stepText}`);
  step.admin.push(old[position.get(full)]);
}
for (const step of steps) step.admin.sort((a, b) => position.get(a.hash) - position.get(b.hash));

// Replay with merge-tree and commit-tree. Nothing here writes a working tree.
function replay(tip, commit) {
  const parent = git(['rev-parse', '--verify', `${commit.hash}^1`]).trim();
  const result = spawnSync('git', ['-C', opts.root, 'merge-tree', '--write-tree', `--merge-base=${parent}`, tip, commit.hash], {
    encoding: 'utf8',
  });
  if (result.status === 1) fail(`replay conflict on ${short(commit)}. Stop for the human and drop no hunk.`);
  if (result.status !== 0) fail(`merge-tree failed on ${short(commit)}: ${(result.stderr || '').trim()}`);
  return result.stdout.split('\n')[0].trim();
}

function commitTree(tree, parent, message) {
  return git(['commit-tree', tree, '-p', parent, '-m', message]).trim();
}

let tip = mergeBase;
let tipTree = git(['rev-parse', `${mergeBase}^{tree}`]).trim();
const created = [];
for (const step of steps) {
  let cur = tip;
  let tree = tipTree;
  for (const commit of [...step.admin, step.commit]) {
    tree = replay(cur, commit);
    cur = commitTree(tree, cur, `fold ${commit.hash}`);
  }
  step.newCommit = commitTree(tree, tip, `${step.title} (#${step.number})`);
  tip = step.newCommit;
  tipTree = tree;
  created.push(`${tip.slice(0, 7)} ${step.title} (#${step.number})`);
}

const headTree = git(['rev-parse', `${head}^{tree}`]).trim();
if (headTree !== tipTree) {
  let number = opts.choreNumber;
  if (!number) {
    for (let i = old.length - 1; i >= 0 && !number; i--) {
      if (!stepHashes.has(old[i].hash)) number = numberOf(old[i].subject);
    }
  }
  if (!number) fail('the chore commit needs a number. Pass --chore-number.');
  const subject = `${initiativeId}: Initiative admin (#${number})`;
  tip = commitTree(headTree, tip, subject);
  created.push(`${tip.slice(0, 7)} ${subject}`);
}

git(['update-ref', `refs/heads/${newBranch}`, tip, '']);
process.stdout.write(`reshape-initiative: wrote ${newBranch} with ${created.length} commit(s)\n${created.join('\n')}\n`);

// Check the shape against the chart.
const here = dirname(fileURLToPath(import.meta.url));
const checkArgs = [join(here, 'check-initiative-history.mjs'), '--root', opts.root, '--base', opts.base,
  '--head', newBranch, '--chart', chartPath];
const check = spawnSync('node', checkArgs, { encoding: 'utf8' });
process.stdout.write(check.stdout || '');
process.stderr.write(check.stderr || '');
if (check.status !== 0) fail(`check-initiative-history failed on ${newBranch}. The branch stays for inspection.`);

if (opts.push) {
  try {
    git(['push', opts.remote, `refs/heads/${newBranch}:refs/heads/${newBranch}`]);
  } catch (e) {
    fail(`push of ${newBranch} failed: ${String(e.stderr || e.message).trim()}`);
  }
}

if (opts.tags) {
  for (const step of steps) {
    const type = git(['for-each-ref', '--format=%(objecttype)', `refs/tags/${step.tag}`]).trim();
    const message = type === 'tag'
      ? git(['for-each-ref', '--format=%(contents)', `refs/tags/${step.tag}`]).replace(/\s+$/, '')
      : `${step.tag}`;
    const oldObject = git(['rev-parse', '--verify', `refs/tags/${step.tag}`]).trim();
    git(['tag', '-d', step.tag]);
    try {
      git(['tag', '-a', '-m', message || step.tag, step.tag, step.newCommit]);
    } catch (e) {
      git(['update-ref', `refs/tags/${step.tag}`, oldObject]);
      fail(`tag ${step.tag} did not move. The old tag is back: ${String(e.stderr || e.message).trim()}`);
    }
    process.stdout.write(`moved tag ${step.tag} to ${step.newCommit.slice(0, 7)}\n`);
  }
}

if (opts.push) {
  for (const step of steps) {
    try {
      git(['push', opts.remote, `:refs/tags/${step.tag}`]);
      git(['push', opts.remote, `refs/tags/${step.tag}:refs/tags/${step.tag}`]);
    } catch (e) {
      fail(`tag ${step.tag} did not move on ${opts.remote}: ${String(e.stderr || e.message).trim()}. Delete it there, then push refs/tags/${step.tag} by hand.`);
    }
    process.stdout.write(`pushed tag ${step.tag}\n`);
  }
}
