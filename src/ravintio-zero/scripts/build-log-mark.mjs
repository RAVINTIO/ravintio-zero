#!/usr/bin/env node
// Appends a RED, GREEN, or Done marker line to the build log (0000575 ADR-0348).
//
// Usage: node build-log-mark.mjs <RED|GREEN|Done> <unit> [--class C --tier T --effort E] [--log path]
// RED and GREEN take an optional --class. A unit with no executable check logs class docs (0000580).
//
// The script reads the clock and writes the time itself, so no session types one.
//   RED, GREEN   - {KIND}: {unit} ({time}), or {KIND}: {unit} ({class}, {time}) with --class
//   Done         - Done: {unit} ({class}, {tier}, {effort}, {time}). The three flags are required.
// The kind is not case sensitive. The default log is plan/current/build-log.md.
// The line goes before a "## Summary" heading when the log has one, else at the end.
// A refusal exits 2 with one stderr line and changes no file. A refusal is a bad kind,
// a missing unit, a missing Done flag, a log that does not exist, or a symlinked log.

import { readFileSync, writeFileSync, lstatSync } from 'node:fs';

const KINDS = { red: 'RED', green: 'GREEN', done: 'Done' };

function refuse(message) {
  process.stderr.write(`build-log-mark: ${message}\n`);
  process.exit(2);
}

const positional = [];
const flags = {};
const args = process.argv.slice(2);
for (let i = 0; i < args.length; i++) {
  if (args[i].startsWith('--')) {
    const name = args[i].slice(2);
    if (!['class', 'tier', 'effort', 'log'].includes(name)) refuse(`unknown flag ${args[i]}`);
    if (i + 1 >= args.length) refuse(`${args[i]} needs a value`);
    flags[name] = args[++i];
  } else {
    positional.push(args[i]);
  }
}

if (positional.length === 0) refuse('Usage: build-log-mark.mjs <RED|GREEN|Done> <unit>');
const kind = KINDS[positional[0].toLowerCase()];
if (!kind) refuse(`unknown kind ${positional[0]}`);
const unit = positional.slice(1).join(' ').trim();
if (!unit) refuse('the unit is missing');
if (/[\r\n]/.test(unit)) refuse('the unit holds a line break');

const time = new Date().toISOString().replace(/\.\d{3}Z$/, 'Z');
let line;
for (const name of ['class', 'tier', 'effort']) {
  if (flags[name] !== undefined && /[\r\n,()]/.test(flags[name])) refuse(`--${name} holds a character that breaks the line`);
}
if (kind === 'Done') {
  for (const need of ['class', 'tier', 'effort']) {
    if (!flags[need]) refuse(`Done needs --${need}`);
  }
  line = `- Done: ${unit} (${flags.class}, ${flags.tier}, ${flags.effort}, ${time})`;
} else {
  line = `- ${kind}: ${unit} (${flags.class ? `${flags.class}, ` : ''}${time})`;
}

const log = flags.log ?? 'plan/current/build-log.md';
let text;
try {
  if (lstatSync(log).isSymbolicLink()) refuse(`${log} is a symlink`);
  text = readFileSync(log, 'utf8');
} catch {
  refuse(`cannot read ${log}`);
}

const lines = text.split('\n');
const at = lines.findIndex((l) => /^## Summary/.test(l));
if (at >= 0) {
  let insert = at;
  while (insert > 0 && lines[insert - 1].trim() === '') insert--;
  lines.splice(insert, 0, line);
  writeFileSync(log, lines.join('\n'));
} else {
  writeFileSync(log, text.replace(/\n*$/, '\n') + line + '\n');
}
process.stdout.write(`${line}\n`);
