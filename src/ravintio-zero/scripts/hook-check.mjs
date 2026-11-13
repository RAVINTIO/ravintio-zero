#!/usr/bin/env node
// Runs every hook in .claude/settings.json with a fixed sample input (0000507 ADR-0339).
//
// Usage: node hook-check.mjs [--root <project-dir>]
//
// The root defaults to CLAUDE_PROJECT_DIR, then to the working directory. The script runs each
// hook command with CLAUDE_PROJECT_DIR set to the root and one fixed JSON sample on stdin, chosen
// by hook event and matcher. Each hook runs in a fresh temporary working directory.
//   pass   the hook exits 0, or exits 2 (a guard's deliberate block)
//   fail   any other exit code, a spawn error, a time-out, an event and matcher with no sample, or
//          a "[RAVINTIO] guard-run:" stderr line, which means the launcher could not run the hook
// The script prints one line per hook and exits 0 if all pass, or 1 if any fails. It exits 2 with
// one stderr line if settings.json is missing or is not valid JSON.

import { spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';

const TIMEOUT_MS = 15000;

// The launcher guard-run.mjs prints this prefix when it cannot run a hook script. A deliberate
// block comes from the guard itself and never carries it.
const LAUNCHER_FAILURE = /\[RAVINTIO\] guard-run:/;

// One fixed sample per hook event and matcher alternative. A tool path points at a file outside
// the project, so a write guard passes the sample on its own merits.
function sampleFor(event, matcher, outside) {
  const prompt = { hook_event_name: 'UserPromptSubmit', prompt: 'hook-check sample' };
  const tools = {
    Write: { file_path: join(outside, 'hook-check-sample.txt'), content: 'sample' },
    Edit: { file_path: join(outside, 'hook-check-sample.txt'), old_string: 'a', new_string: 'b' },
    Bash: { command: 'echo hook-check sample' },
  };
  if (event === 'UserPromptSubmit' && matcher === '.*') return prompt;
  if (event === 'Stop' && matcher === '.*') return { hook_event_name: 'Stop', stop_hook_active: false };
  if (event === 'PostToolUse' && matcher === '.*') {
    return { hook_event_name: 'PostToolUse', tool_name: 'Read', tool_input: { file_path: join(outside, 'x') }, tool_response: {} };
  }
  if (event === 'PreToolUse' && tools[matcher]) {
    return { hook_event_name: 'PreToolUse', tool_name: matcher, tool_input: tools[matcher] };
  }
  return null;
}

function fail(message) {
  process.stderr.write(`hook-check: ${message}\n`);
  process.exit(2);
}

function parseRoot(argv) {
  const i = argv.indexOf('--root');
  if (i >= 0) {
    if (!argv[i + 1]) fail('--root needs a directory');
    return resolve(argv[i + 1]);
  }
  return resolve(process.env.CLAUDE_PROJECT_DIR || process.cwd());
}

// The script a command runs, for the report line. Falls back to the command text.
function label(command) {
  const names = command.match(/[A-Za-z0-9._-]+\.(?:mjs|sh)\b/g);
  return names ? names.join(' ') : command.slice(0, 60);
}

export function checkHooks(root) {
  const file = join(root, '.claude', 'settings.json');
  let settings;
  try {
    settings = JSON.parse(readFileSync(file, 'utf8'));
  } catch (e) {
    fail(`cannot read ${file} as JSON: ${e.code || 'invalid JSON'}`);
  }
  const results = [];
  const work = mkdtempSync(join(tmpdir(), 'hook-check-'));
  const outside = mkdtempSync(join(tmpdir(), 'hook-check-outside-'));
  try {
    for (const [event, entries] of Object.entries(settings.hooks ?? {})) {
      for (const entry of Array.isArray(entries) ? entries : []) {
        const matcher = typeof entry.matcher === 'string' && entry.matcher !== '' ? entry.matcher : '.*';
        const alternatives = matcher === '.*' ? ['.*'] : matcher.split('|');
        for (const hook of Array.isArray(entry.hooks) ? entry.hooks : []) {
          if (hook.type !== 'command' || typeof hook.command !== 'string') continue;
          for (const alt of alternatives) {
            const base = { event, matcher: alt, name: label(hook.command) };
            const sample = sampleFor(event, alt, outside);
            if (!sample) {
              results.push({ ...base, pass: false, detail: 'no sample for this event and matcher' });
              continue;
            }
            const r = spawnSync('sh', ['-c', hook.command], {
              cwd: work,
              input: JSON.stringify({ ...sample, cwd: work }),
              env: { ...process.env, CLAUDE_PROJECT_DIR: root },
              encoding: 'utf8',
              timeout: TIMEOUT_MS,
            });
            if (r.error) {
              results.push({ ...base, pass: false, detail: `did not run: ${r.error.code || r.error.message}` });
            } else if (LAUNCHER_FAILURE.test(r.stderr || '')) {
              // guard-run.mjs exits 2 for a guard it cannot run and exits 0 for a missing advisory.
              // Neither is a deliberate block, so the hook fails.
              const line = (r.stderr || '').split(/\r?\n/).find((l) => LAUNCHER_FAILURE.test(l)) || '';
              results.push({ ...base, pass: false, detail: `exit ${r.status} ${line}`.trim() });
            } else if (r.status === 0 || r.status === 2) {
              results.push({ ...base, pass: true, detail: `exit ${r.status}` });
            } else {
              const why = (r.stderr || '').split(/\r?\n/).find((l) => l.trim() !== '') || '';
              results.push({ ...base, pass: false, detail: `exit ${r.status === null ? 'signal ' + r.signal : r.status} ${why}`.trim() });
            }
          }
        }
      }
    }
  } finally {
    rmSync(work, { recursive: true, force: true });
    rmSync(outside, { recursive: true, force: true });
  }
  return results;
}

if (import.meta.url === `file://${process.argv[1]}` || process.argv[1]?.endsWith('hook-check.mjs')) {
  const results = checkHooks(parseRoot(process.argv.slice(2)));
  for (const r of results) {
    process.stdout.write(`${r.pass ? 'pass' : 'fail'}: ${r.event} ${r.matcher} ${r.name} (${r.detail})\n`);
  }
  const failed = results.filter((r) => !r.pass);
  process.stdout.write(`hook-check: ${results.length - failed.length} passed, ${failed.length} failed\n`);
  process.exit(failed.length > 0 ? 1 : 0);
}
