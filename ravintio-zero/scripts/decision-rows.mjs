#!/usr/bin/env node
/**
 * decision-rows.mjs: list the chart's Decisions rows that name a step
 * (feature 0000487, ADR-0313).
 *
 * Usage: node decision-rows.mjs list --step {n} [--chart {path}]
 *
 * The default chart is plan/current-initiative/initiative.md. The command
 * prints one line for each row, as `{fork} => {answer}`, and `none` when no row
 * names the step or the chart is missing. It always exits 0 for a readable
 * request. Chart text is data: the module runs none of it and builds no path
 * from it.
 *
 * A Step cell holds a number, a range such as `25-41`, or a comma list such
 * as `1, 3`. A row whose Fork is `none` is not a decision and is skipped.
 */
import { existsSync, readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const MAX_RANGE = 1000;

/** Lines of the `## Decisions` section, up to the next `## ` heading. */
function decisionsSection(text) {
  const lines = text.split("\n");
  const out = [];
  let inside = false;
  for (const line of lines) {
    if (/^## /.test(line)) {
      inside = /^## Decisions\s*$/.test(line);
      continue;
    }
    if (inside) out.push(line);
  }
  return out;
}

function splitRow(line) {
  return line.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map((c) => c.trim());
}

/** Sorted step numbers named by a Step cell. An unreadable cell gives []. */
export function expandSteps(cell) {
  const steps = new Set();
  for (const part of String(cell).split(",")) {
    const p = part.trim();
    let m;
    if ((m = /^(\d+)$/.exec(p))) {
      steps.add(Number(m[1]));
    } else if ((m = /^(\d+)\s*-\s*(\d+)$/.exec(p))) {
      const a = Number(m[1]);
      const b = Number(m[2]);
      if (b >= a && b - a < MAX_RANGE) for (let i = a; i <= b; i++) steps.add(i);
    }
  }
  return [...steps].sort((x, y) => x - y);
}

/** Rows of the `## Decisions` table as { steps, fork, answer, bump }. */
export function parseDecisions(text) {
  const rows = [];
  let header = null;
  for (const line of decisionsSection(text)) {
    if (!line.trim().startsWith("|")) continue;
    const cells = splitRow(line);
    if (header === null) { header = cells; continue; }
    if (cells.every((c) => /^:?-+:?$/.test(c))) continue;
    const col = (n) => {
      const i = header.indexOf(n);
      return i < 0 ? "" : (cells[i] ?? "");
    };
    rows.push({
      steps: expandSteps(col("Step")),
      fork: col("Fork"),
      answer: col("Pre-approved answer"),
      bump: col("Bump effect"),
    });
  }
  return rows;
}

/** Rows that name step `n`, without the `none` rows. */
export function rowsForStep(text, n) {
  return parseDecisions(text).filter((r) => r.steps.includes(n) && r.fork.toLowerCase() !== "none");
}

function main(argv) {
  const [cmd, ...rest] = argv;
  if (cmd !== "list") {
    console.error("usage: decision-rows.mjs list --step {n} [--chart {path}]");
    return 2;
  }
  let step = null;
  let chart = "plan/current-initiative/initiative.md";
  for (let i = 0; i < rest.length; i++) {
    if (rest[i] === "--step") step = rest[++i];
    else if (rest[i] === "--chart") chart = rest[++i];
    else { console.error(`decision-rows: unknown argument ${rest[i]}`); return 2; }
  }
  if (!/^\d{1,4}$/.test(step ?? "")) {
    console.error("decision-rows: --step needs a whole number");
    return 2;
  }
  if (!existsSync(chart)) { console.log("none"); return 0; }
  const rows = rowsForStep(readFileSync(chart, "utf-8"), Number(step));
  if (rows.length === 0) { console.log("none"); return 0; }
  for (const r of rows) console.log(`${r.fork} => ${r.answer}`);
  return 0;
}

if (process.argv[1] === fileURLToPath(import.meta.url)) process.exit(main(process.argv.slice(2)));
