#!/usr/bin/env node
/**
 * build-log-check.mjs — deterministic check of a finished build log
 * (feature 0000248, ADR-001). Ship runs it in Step 3, before Archive.
 *
 * Usage: node build-log-check.mjs [buildLogPath]   (default: plan/current/build-log.md)
 *
 * Checks:
 *   1. Phases P0 to P4 each have a "### P<n>:" block, unless a line
 *      "Skipped: P<n>" marks the phase as skipped.
 *   2. Each block has a readable Start and End, and a whole-number Wall clock.
 *   3. Wall clock is within one minute of End minus Start.
 *   4. The Summary "Total wall clock" row is filled and not "not recorded".
 *   5. A closed block (its End holds a time) holds a "Complete: P<n>" line,
 *      unless a "Skipped: P<n>" line excuses the phase (0000358).
 *   6. No logged time is later than the commit that adds its line, with a
 *      one-minute margin. A line not yet committed, or a log outside git,
 *      is compared with the current clock (0000358).
 *
 *   7. Each "Resolved:" line, and each "Rework:" line, has a "Postmortem:" line
 *      that names a record. The record exists and passes postmortem-check.mjs
 *      (0000392). A "Postmortem:" line that names a REQ-nnn covers that
 *      requirement. Any other "Postmortem:" line covers one "Resolved:" line
 *      or one "Rework:" line that names no requirement.
 *
 * Every finding names the phase. Exit codes: 0 = clean, 1 = findings.
 */

import { execFileSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { dirname, basename, join } from "node:path";
import { checkRecord } from "./postmortem-check.mjs";

const file = process.argv[2] ?? join(process.cwd(), "plan", "current", "build-log.md");
const findings = [];

let text;
try {
  text = readFileSync(file, "utf-8");
} catch {
  console.error("build-log-check: cannot read the build log");
  process.exit(1);
}

const ISO = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(:\d{2})?Z$/;

/** Value of a "| Field | `value` |" row, with backticks removed. Null if absent. */
function field(body, name) {
  const m = new RegExp(`^\\|\\s*${name}\\s*\\|(.*)\\|\\s*$`, "im").exec(body);
  return m ? m[1].replace(/`/g, "").trim() : null;
}

/** A value that holds nothing: empty, or a template placeholder. */
const blank = (v) => v === null || v === "" || v.includes("{{");

const heads = [...text.matchAll(/^### P([0-4]):.*$/gm)];
const blocks = new Map();
heads.forEach((h, i) => {
  const rest = text.slice(h.index + h[0].length);
  const end = rest.search(/^(###? |---\s*$)/m);
  blocks.set(Number(h[1]), end === -1 ? rest : rest.slice(0, end));
});
const skipped = new Set(
  [...text.matchAll(/^\s*(?:[-*]\s*)?Skipped:\s*P([0-4])\b/gm)].map((m) => Number(m[1])),
);

for (let n = 0; n <= 4; n++) {
  const body = blocks.get(n);
  if (body === undefined) {
    if (!skipped.has(n)) findings.push(`P${n}: no phase block and no "Skipped: P${n}" line`);
    continue;
  }
  const start = field(body, "Start");
  const end = field(body, "End");
  const wall = field(body, "Wall clock");
  let readable = true;
  if (blank(start)) { findings.push(`P${n}: Start is blank`); readable = false; }
  else if (!ISO.test(start)) { findings.push(`P${n}: Start is not an ISO-8601 UTC time`); readable = false; }
  if (blank(end)) { findings.push(`P${n}: End is blank`); readable = false; }
  else if (!ISO.test(end)) { findings.push(`P${n}: End is not an ISO-8601 UTC time`); readable = false; }
  if (blank(wall)) { findings.push(`P${n}: Wall clock is blank`); continue; }
  if (!/^\d+$/.test(wall)) { findings.push(`P${n}: Wall clock is not a whole number of minutes`); continue; }
  if (readable) {
    const span = (Date.parse(end) - Date.parse(start)) / 60000;
    if (span < 0) findings.push(`P${n}: End is before Start`);
    else if (Math.abs(Number(wall) - span) > 1) {
      findings.push(`P${n}: Wall clock ${wall} differs by more than one minute from the ${span.toFixed(1)} minutes between Start and End`);
    }
  }
}

// Check 5: a closed block holds a Complete line.
for (const [n, body] of blocks) {
  const end = field(body, "End");
  const closed = end !== null && ISO.test(end);
  if (closed && !skipped.has(n) && !new RegExp(`^\\s*(?:[-*]\\s*)?Complete:\\s*P${n}\\b`, "m").test(body)) {
    findings.push(`P${n}: End is filled and the block has no "Complete: P${n}" line`);
  }
}

// Check 6: no logged time is later than the commit that adds its line.
/** Committer time in ms for each line of the file, or null when git can't say. */
function commitTimes(path) {
  try {
    const out = execFileSync("git", ["blame", "--porcelain", "--", basename(path)], {
      cwd: dirname(path), encoding: "utf-8", stdio: ["ignore", "pipe", "ignore"], maxBuffer: 64 * 1024 * 1024,
    });
    const times = new Map(); // sha -> ms
    const lines = [];        // final line index -> ms
    let sha = null, finalLine = 0;
    for (const row of out.split("\n")) {
      const head = /^([0-9a-f]{40}) \d+ (\d+)/.exec(row);
      if (head) { sha = head[1]; finalLine = Number(head[2]); continue; }
      const ct = /^committer-time (\d+)$/.exec(row);
      if (ct) times.set(sha, Number(ct[1]) * 1000);
      if (row.startsWith("\t")) lines[finalLine - 1] = times.get(sha);
    }
    return lines;
  } catch {
    return null;
  }
}
{
  const MARGIN = 60000;
  const now = Date.now();
  const lineTimes = commitTimes(file);
  const rows = text.split("\n");
  let phase = null;
  rows.forEach((row, i) => {
    const h = /^### P([0-4]):/.exec(row);
    if (h) phase = Number(h[1]);
    const limit = (lineTimes && lineTimes[i] !== undefined ? lineTimes[i] : now) + MARGIN;
    const source = lineTimes && lineTimes[i] !== undefined ? "the commit that adds it" : "the clock";
    for (const m of row.matchAll(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(?::\d{2})?Z/g)) {
      const t = Date.parse(m[0].length === 17 ? m[0].replace("Z", ":00Z") : m[0]);
      if (Number.isNaN(t) || t <= limit) continue;
      findings.push(`${phase === null ? "Header" : `P${phase}`}: time ${m[0]} on line ${i + 1} is later than ${source}`);
    }
  });
}

// Check 7: every stop and every rework has a postmortem (0000392).
{
  const lineRe = (word) => new RegExp(`^\\s*(?:[-*]\\s*)?${word}:(.*)$`, "gm");
  const resolved = [...text.matchAll(lineRe("Resolved"))].length;
  const reworks = [...text.matchAll(lineRe("Rework"))].map((m) => m[1]);
  const reworkReqs = new Set(reworks.flatMap((r) => r.match(/REQ-\d+/g) ?? []).slice(0, 1000));
  const bareReworks = reworks.filter((r) => !/REQ-\d+/.test(r)).length;
  const records = [...text.matchAll(lineRe("Postmortem"))].map((m) => m[1].trim());
  const covered = new Set();
  let stopLines = 0;
  for (const rec of records) {
    const reqs = rec.match(/REQ-\d+/g) ?? [];
    if (reqs.length) reqs.forEach((r) => covered.add(r)); else stopLines++;
    const path = rec.split(/\s+/)[0];
    if (!existsSync(path)) { findings.push(`Postmortem: record ${path} does not exist`); continue; }
    for (const f of checkRecord(readFileSync(path, "utf-8"))) findings.push(`Postmortem: ${path}: ${f}`);
  }
  const needStops = resolved + bareReworks;
  if (stopLines < needStops) {
    findings.push(`Postmortem: ${needStops} stop or rework line(s) need a "Postmortem:" line and ${stopLines} found`);
  }
  for (const r of [...reworkReqs].sort()) {
    if (!covered.has(r)) findings.push(`Postmortem: ${r} has a "Rework:" line and no "Postmortem:" line that names it`);
  }
}

const total = field(text, "Total wall clock");
if (blank(total) || /^not recorded$/i.test(total)) {
  findings.push(`Total wall clock: blank or "not recorded"`);
}

if (findings.length === 0) {
  console.log("build-log-check: clean");
  process.exit(0);
}
console.log(`build-log-check: ${findings.length} finding(s)`);
for (const f of findings) console.log(`  ✖ ${f}`);
process.exit(1);
