#!/usr/bin/env node
// Runs a command in a clean clone of HEAD (0000385 REQ-003, ADR-002).
//
// Usage: node clean-clone-test.mjs [--workflow path] [--repo path] -- <command> [args...]
//   --workflow  the CI workflow file. Default .github/workflows/ravintio.yml.
//   --repo      the repository to clone. Default: the top of the current git tree.
//   The command runs with the clone as its working folder. With no command the
//   script runs: bash ravintio-zero/tests/run-tests.sh, with RAVINTIO_TEST_QUIET=1.
//
// The script clones the repository, checks out the commit HEAD names, runs the
// command, removes the clone on every exit, and exits with the command's code.
// If the local OS is not among the "runs-on" values of the workflow file, it
// prints "OS gap: local {os}, CI {list}" first. Committed files only: untracked
// and ignored files do not reach the clone. On a setup failure it prints one
// line to stderr and exits 2.

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync, execFileSync } from 'node:child_process';

function fail(message) {
  process.stderr.write(`clean-clone-test: ${message}\n`);
  process.exit(2);
}

function localFamily() {
  return { darwin: 'macos', linux: 'ubuntu', win32: 'windows' }[process.platform] || process.platform;
}

export function ciFamilies(workflowText) {
  const found = new Set();
  for (const m of workflowText.matchAll(/^\s*runs-on:\s*['"]?([A-Za-z]+)[-\w.]*/gm)) {
    found.add(m[1].toLowerCase());
  }
  return [...found];
}

function parseArgs(argv) {
  const opts = { workflow: path.join('.github', 'workflows', 'ravintio.yml'), repo: null, command: [] };
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--') { opts.command = argv.slice(i + 1); break; }
    if (argv[i] === '--workflow' || argv[i] === '--repo') {
      if (i + 1 >= argv.length) fail(`${argv[i]} needs a path`);
      opts[argv[i].slice(2)] = argv[++i];
    } else fail(`unknown argument ${argv[i]}`);
  }
  return opts;
}

const git = (args, cwd) => execFileSync('git', args, { cwd, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();

function main() {
  const opts = parseArgs(process.argv.slice(2));
  let top;
  try {
    top = opts.repo ? path.resolve(opts.repo) : git(['rev-parse', '--show-toplevel'], process.cwd());
  } catch (err) {
    return fail('not inside a git repository');
  }

  let workflowText = null;
  try { workflowText = fs.readFileSync(path.resolve(top, opts.workflow), 'utf8'); } catch { /* no workflow file */ }
  if (workflowText !== null) {
    const ci = ciFamilies(workflowText);
    const local = localFamily();
    if (ci.length && !ci.includes(local)) process.stdout.write(`OS gap: local ${local}, CI ${ci.join(', ')}\n`);
  }

  let sha;
  try { sha = git(['rev-parse', 'HEAD'], top); } catch (err) { return fail(`cannot read HEAD: ${String(err.stderr || err.message).trim()}`); }

  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'ravintio-clean-clone-'));
  const clone = path.join(tmp, 'clone');
  let code = 2;
  const cleanup = () => { try { fs.rmSync(tmp, { recursive: true, force: true }); } catch { /* best effort */ } };
  for (const sig of ['SIGINT', 'SIGTERM']) process.on(sig, () => { cleanup(); process.exit(130); });
  try {
    try {
      git(['clone', '--quiet', '--no-hardlinks', '--no-checkout', top, clone], process.cwd());
      git(['checkout', '--quiet', '--detach', sha], clone);
    } catch (err) {
      process.stderr.write(`clean-clone-test: clone failed: ${String(err.stderr || err.message).trim()}\n`);
      return 2;
    }
    const env = { ...process.env };
    let cmd = opts.command;
    if (!cmd.length) { cmd = ['bash', 'ravintio-zero/tests/run-tests.sh']; env.RAVINTIO_TEST_QUIET = '1'; }
    const res = spawnSync(cmd[0], cmd.slice(1), { cwd: clone, env, stdio: 'inherit' });
    code = res.status === null ? 1 : res.status;
  } finally {
    cleanup();
  }
  return code;
}

process.exit(main());
