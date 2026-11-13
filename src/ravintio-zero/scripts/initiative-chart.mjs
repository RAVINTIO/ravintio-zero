#!/usr/bin/env node
// Parses an initiative chart: the `## Steps` table by header name and the `**Concurrency:**` field.
// Exports parseChart(text) and readySteps(steps, states), which ranks by chain length. No packages.

function splitRow(line) {
  return line.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map((c) => c.trim());
}

function fieldIn(text, name) {
  const re = new RegExp(`^\\s*(?:[-*]\\s+)?\\**${name}\\**\\s*:\\s*\\**\\s*\`?([^\`\\n]*?)\`?\\s*$`, "mi");
  const m = text.match(re);
  if (!m) return "";
  return m[1].replace(/\s+#.*$/, "").trim();
}

function parseConcurrency(text) {
  const raw = fieldIn(text, "Concurrency");
  if (raw === "") return { concurrency: 1, hasConcurrency: false };
  if (!/^[1-9]$/.test(raw)) throw new Error(`Concurrency must be a whole number from 1 to 9, got: ${raw}`);
  return { concurrency: Number(raw), hasConcurrency: true };
}

/** Expand `4`, `6, 13`, `5-18`, empty, or `none` into a list of step numbers. */
function parseAfter(cell, step) {
  const v = (cell ?? "").trim();
  if (v === "" || v.toLowerCase() === "none") return [];
  const out = [];
  for (const part of v.split(",").map((p) => p.trim()).filter(Boolean)) {
    const m = part.match(/^(\d+)(?:\s*-\s*(\d+))?$/);
    if (!m) throw new Error(`step ${step}: bad After value: ${part}`);
    const from = Number(m[1]);
    const to = m[2] === undefined ? from : Number(m[2]);
    if (to < from) throw new Error(`step ${step}: bad After range: ${part}`);
    for (let n = from; n <= to; n++) out.push(n);
  }
  return out;
}

function stepsSection(text) {
  const lines = text.split("\n");
  const start = lines.findIndex((l) => l.trim() === "## Steps");
  if (start < 0) return [];
  const out = [];
  for (let i = start + 1; i < lines.length && !/^## /.test(lines[i]); i++) out.push(lines[i]);
  return out;
}

// The shape of a Feature id cell: seven digits, a hyphen, and a kebab-case slug.
// initiative-run.mjs holds a copy, and test-0000438-req-001 fails if the two differ.
export const FEATURE_ID = /^[0-9]{7}-[a-z0-9]+(-[a-z0-9]+)*$/;

export function parseChart(text) {
  const { concurrency, hasConcurrency } = parseConcurrency(text);
  const steps = [];
  let header = null;
  for (const line of stepsSection(text)) {
    if (!line.trim().startsWith("|")) continue;
    const cells = splitRow(line);
    if (header === null) { header = cells; continue; }
    if (cells.every((c) => /^:?-+:?$/.test(c))) continue;
    const col = (n) => {
      const i = header.indexOf(n);
      return i < 0 ? undefined : cells[i];
    };
    const step = Number(col("Step"));
    if (!Number.isInteger(step)) continue;
    const status = col("Status") || "pending";
    if (!["pending", "running", "ready", "merged"].includes(status)) {
      throw new Error(`step ${step}: bad Status: ${status}`);
    }
    steps.push({
      step,
      featureId: col("Feature id") ?? "",
      title: col("Title") ?? "",
      bump: col("Bump") ?? "",
      version: col("Version") ?? "",
      status,
      lane: col("Lane") || `step-${step}`,
      after: parseAfter(col("After"), step),
    });
  }
  return { concurrency, hasConcurrency, steps };
}

/**
 * The chain length of each unmerged step: 1 plus the longest chain among its dependants. A dependant
 * lists the step in `After`, or is the next unmerged step in the same lane. A cycle ends the count at
 * the step that repeats. Returns a Map from step number to chain length.
 */
function chainLengths(steps) {
  const open = steps.filter((s) => s.status !== "merged");
  const next = new Map();
  const dependants = new Map(open.map((s) => [s.step, []]));
  const lastInLane = new Map();
  for (const s of open) {
    if (lastInLane.has(s.lane)) dependants.get(lastInLane.get(s.lane)).push(s.step);
    lastInLane.set(s.lane, s.step);
    for (const n of s.after) if (dependants.has(n)) dependants.get(n).push(s.step);
  }
  const walking = new Set();
  const length = (n) => {
    if (next.has(n)) return next.get(n);
    if (walking.has(n)) return 0;
    walking.add(n);
    let best = 0;
    for (const d of dependants.get(n)) best = Math.max(best, length(d));
    walking.delete(n);
    next.set(n, 1 + best);
    return 1 + best;
  };
  for (const s of open) length(s.step);
  return next;
}

/**
 * Pending steps that may start now, longest chain first. Chart order breaks ties. `states` maps step
 * to the driver's derived 'running' or 'ready'. The list holds no concurrency cap.
 */
export function readySteps(steps, states = new Map()) {
  const merged = new Set(steps.filter((s) => s.status === "merged").map((s) => s.step));
  const held = new Set();
  for (const s of steps) {
    const st = states.get(s.step);
    if (st === "running" || st === "ready") held.add(s.lane);
  }
  const out = [];
  for (const s of steps) {
    if (s.status !== "pending" || states.has(s.step)) continue;
    if (!s.after.every((n) => merged.has(n))) continue;
    if (held.has(s.lane)) continue;
    held.add(s.lane);
    out.push(s);
  }
  const chain = chainLengths(steps);
  return out
    .map((s, i) => ({ s, i, c: chain.get(s.step) ?? 1 }))
    .sort((a, b) => b.c - a.c || a.i - b.i)
    .map((x) => x.s);
}
