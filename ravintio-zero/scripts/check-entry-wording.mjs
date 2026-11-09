#!/usr/bin/env node
// Checks files against the pack wording rules and prints "path:line" per breach.
// Exit 0 when clean, 1 on any breach, 2 on a usage error or unreadable file.
// The two banned words are built from parts so this source never holds either
// as one token, because the repo-wide wording tests scan tracked files.
import { readFileSync } from 'node:fs';

const FW = 'frame' + 'work';
const BRAND = 'plani' + 'fest';

// Each rule: a banned word and the line forms that the pack tests also allow.
const RULES = [
  {
    banned: new RegExp(FW, 'i'),
    allowed: [
      new RegExp('[Tt]est ' + FW),
      new RegExp('[Tt]esting ' + FW),
      new RegExp('[Mm]eta-' + FW),
      new RegExp('RAVINTIO F' + FW.slice(1)),
      new RegExp('language or ' + FW + ' in use'),
    ],
  },
  {
    banned: new RegExp(BRAND, 'i'),
    allowed: [
      new RegExp('0000031-five-phase-' + BRAND + '-zero'),
      new RegExp('0000037-self-host-on-' + BRAND + '-zero'),
    ],
  },
];

const files = process.argv.slice(2);
if (files.length === 0) {
  console.error('usage: check-entry-wording.mjs {file}...');
  process.exit(2);
}

let breached = false;
for (const file of files) {
  let text;
  try {
    text = readFileSync(file, 'utf8');
  } catch (err) {
    console.error(`cannot read ${file}: ${err.message}`);
    process.exit(2);
  }
  text.split('\n').forEach((line, i) => {
    for (const rule of RULES) {
      if (rule.banned.test(line) && !rule.allowed.some((re) => re.test(line))) {
        console.log(`${file}:${i + 1}`);
        breached = true;
        return;
      }
    }
  });
}
process.exit(breached ? 1 : 0);
