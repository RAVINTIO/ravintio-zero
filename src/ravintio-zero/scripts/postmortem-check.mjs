#!/usr/bin/env node
/**
 * postmortem-check.mjs: check the Actions table of a postmortem record
 * (feature 0000392, REQ-002, ADR-001).
 *
 * Usage: node postmortem-check.mjs <record.md>
 *
 * The record holds one row for each of corrective, preventive, and detective.
 * A row either names an action with a Status of `filed` or `done` and a Ref,
 * or reads `none, because {reason}` in the Action cell.
 *
 * Exit codes: 0 = clean, 1 = findings or an unreadable record.
 */

import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { fileURLToPath } from "node:url";

export const TYPES = ["corrective", "preventive", "detective"];

function cells(line) {
  return line.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map((c) => c.trim());
}

/** Return the findings for the text of a postmortem record. */
export function checkRecord(text) {
  const lines = text.split("\n");
  const start = lines.findIndex((l) => l.trim() === "## Actions");
  if (start < 0) return ["no ## Actions section"];
  let end = lines.length;
  for (let i = start + 1; i < lines.length; i++) {
    if (/^## /.test(lines[i])) { end = i; break; }
  }
  let header = null;
  const rows = new Map();
  for (let i = start + 1; i < end; i++) {
    if (!lines[i].trim().startsWith("|") || /^\|[\s|:-]+\|?\s*$/.test(lines[i].trim())) continue;
    const c = cells(lines[i]);
    if (header === null) { header = c.map((h) => h.toLowerCase()); continue; }
    const type = c[0].toLowerCase();
    if (TYPES.includes(type) && !rows.has(type)) rows.set(type, c);
  }
  if (header === null) return ["no Actions table"];
  const col = (name) => header.indexOf(name);
  for (const need of ["action", "status", "ref"]) {
    if (col(need) < 0) return [`the Actions table has no ${need} column`];
  }
  const findings = [];
  for (const type of TYPES) {
    const c = rows.get(type);
    if (!c) { findings.push(`no ${type} row`); continue; }
    const action = c[col("action")] ?? "";
    const status = (c[col("status")] ?? "").toLowerCase();
    const ref = c[col("ref")] ?? "";
    if (action === "" || action.includes("{{")) { findings.push(`${type} row has no action`); continue; }
    if (/^none, because\s+\S/i.test(action)) continue;
    if (status !== "filed" && status !== "done") {
      findings.push(`${type} row status is "${status}", expected filed or done`);
    } else if (ref === "" || ref.includes("{{")) {
      findings.push(`${type} row is ${status} and has no Ref`);
    }
  }
  return findings;
}

function main(argv) {
  if (argv.length !== 1) {
    console.error("usage: postmortem-check.mjs <record.md>");
    return 1;
  }
  let text;
  try {
    text = readFileSync(argv[0], "utf-8");
  } catch {
    console.error("postmortem-check: cannot read the record");
    return 1;
  }
  const findings = checkRecord(text);
  if (findings.length === 0) {
    console.log("postmortem-check: clean");
    return 0;
  }
  console.log(`postmortem-check: ${findings.length} finding(s)`);
  for (const f of findings) console.log(`  ✖ ${f}`);
  return 1;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  process.exit(main(process.argv.slice(2)));
}
