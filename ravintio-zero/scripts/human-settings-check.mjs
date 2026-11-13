#!/usr/bin/env node
/**
 * human-settings-check.mjs - reads the human-only settings a chart names
 * (feature 0000384, REQ-006, ADR-003). The plan skill runs it before P2.
 *
 * Usage: node human-settings-check.mjs [initiativeFile]
 *   initiativeFile defaults to plan/current-initiative/initiative.md.
 *
 * A setting is a `## Decisions` row whose Fork cell starts `Human setting:`.
 * The answer cell holds `GET {endpoint} {jq-path}={expected}`.
 * The script only reads. It runs `gh api -X GET {endpoint}` through
 * execFileSync with an argument array, and only for allowlisted endpoints.
 *
 * Set RAVINTIO_GH_BIN to replace the `gh` binary (used by tests).
 *
 * Exit 0: no rows (prints `none`) or every setting matches.
 * Exit 1: a mismatch, a disallowed endpoint, or an unreadable row or file.
 */
import { readFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';

const SEG = '[A-Za-z0-9._-]+';
const ALLOWED = new RegExp(
  `^repos/${SEG}/${SEG}(/(code-scanning/default-setup|vulnerability-alerts|` +
  `private-vulnerability-reporting|automated-security-fixes|rulesets|` +
  `branches/${SEG}/protection))?$`
);

const clean = (v) =>
  String(v).replace(/[\u0000-\u001f\u007f-\u009f]/g, '').slice(0, 80);

const file = process.argv[2] || 'plan/current-initiative/initiative.md';
let text;
try {
  text = readFileSync(file, 'utf8');
} catch {
  console.error(`human-settings-check: cannot read ${clean(file)}`);
  process.exit(1);
}

// Collect rows of the Decisions table.
const rows = [];
let inDecisions = false;
for (const line of text.split(/\r?\n/)) {
  if (/^##\s/.test(line)) {
    inDecisions = /^##\s+Decisions\s*$/.test(line);
    continue;
  }
  if (!inDecisions || !line.trim().startsWith('|')) continue;
  const cells = line.trim().replace(/^\||\|$/g, '').split('|').map((c) => c.trim());
  if (cells.length < 3) continue;
  const m = /^Human setting:\s*(.+)$/.exec(cells[1]);
  if (m) rows.push({ name: m[1].trim(), answer: cells[2].replace(/^`+|`+$/g, '').trim() });
}

if (rows.length === 0) {
  console.log('none');
  process.exit(0);
}

const gh = process.env.RAVINTIO_GH_BIN || 'gh';
let failed = false;

for (const { name, answer } of rows) {
  const m = /^GET\s+(\S+)\s+([A-Za-z0-9_.-]+)=(.*)$/.exec(answer);
  if (!m) {
    console.error(`human-settings-check: unreadable answer for ${clean(name)}`);
    failed = true;
    continue;
  }
  const [, endpoint, path, expected] = m;
  if (!ALLOWED.test(endpoint)) {
    console.error(`human-settings-check: endpoint not allowed for ${clean(name)}`);
    failed = true;
    continue;
  }
  let actual;
  try {
    const out = execFileSync(gh, ['api', '-X', 'GET', endpoint], {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    });
    let value = JSON.parse(out);
    for (const key of path.split('.')) {
      value = value !== null && typeof value === 'object' ? value[key] : undefined;
    }
    actual = value === undefined ? 'missing' : typeof value === 'object' ? JSON.stringify(value) : String(value);
  } catch {
    console.error(`human-settings-check: gh read failed for ${clean(name)}`);
    failed = true;
    continue;
  }
  if (actual !== expected.trim()) {
    console.log(
      `P1 Plan: Blocked: human-only setting ${clean(name)} reads ${clean(actual)}, wanted ${clean(expected.trim())}.`
    );
    failed = true;
  }
}

process.exit(failed ? 1 : 0);
