#!/usr/bin/env node
/**
 * merge-queue.mjs: PR title check and serial merge queue for initiative steps
 * (feature 0000378, REQ-002 and REQ-003, ADR-001).
 *
 * Usage:
 *   node merge-queue.mjs title --step N --title TEXT [--chart path]
 *   node merge-queue.mjs versions [--root dir] [--list file]
 *   node merge-queue.mjs run --step N --pr K [--root dir] [--chart path] [--list file]
 *
 * Exit codes: 0 on success, 1 on any failure. The queue stops before the merge
 * on a title mismatch, a red check, a merge conflict, or a version file that
 * differs. It never rewrites pushed history. Every git and gh call takes an
 * argument array. Set GH_BIN and GIT_BIN to override the binaries.
 *
 * The queue waits for CI before the version push and again after it, because
 * the push restarts CI on the new head (feature 0000392, REQ-003, ADR-002).
 * It polls `gh pr checks --json name,bucket` every MQ_POLL_MS ms (default
 * 10000) until MQ_TIMEOUT_MS ms (default 1800000) have passed.
 *
 * Before each CI wait it polls `gh pr view --json headRefOid` until GitHub
 * shows the pushed head. Before the merge it waits until GitHub reports the
 * PR MERGEABLE with a clean state, and it retries a "not mergeable" or "Base
 * branch was modified" refusal once (feature 0000411).
 *
 * While no check is listed, the wait reads the PR's `mergeable` value. A `CONFLICTING` PR stops the queue with a
 * named error, because GitHub starts no workflow for it. With no check after MQ_NOCHECKS_MS ms (default 600000)
 * the wait also stops (feature 0000483, ADR-0310).
 *
 * A failed run can leave a set-version commit on the PR branch. Before the base merge, a rerun reverts
 * such commits in one new commit when the base version has moved, so the merge has no conflict on the
 * version rows. Nothing rewrites pushed history. The worktree ends on a detached HEAD after every run,
 * so a restart can check the PR branch out (feature 0000454, ADR-0299).
 *
 * If the base merge conflicts only on shared files, the queue resolves them with shared-files.mjs, prints a
 * `resolved:` line for each, and commits the merge. A conflict in any other file aborts the merge and stops
 * the queue (feature 0000456, ADR-0302).
 *
 * The chart `Merge commit` cell holds `tag v{version}`. The queue never commits
 * after the squash, so the sha lives in the tag and in the printed output.
 */

import { execFileSync, spawnSync } from "node:child_process";
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, isAbsolute, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { resolveSharedConflicts } from "./shared-files.mjs";
import { presentPaths, readEntries, readVersions, setVersions } from "./version-files.mjs";

const GIT = process.env.GIT_BIN || "git";
const GH = process.env.GH_BIN || "gh";
const DEFAULT_CHART = "plan/current-initiative/initiative.md";
const DEFAULT_LIST = join(dirname(fileURLToPath(import.meta.url)), "..", "version-files.txt");
const MERGES_HEADER = ["Step", "PR", "Merge commit", "Version", "Merged at"];

class Stop extends Error {}

function git(root, args, opts = {}) {
  return execFileSync(GIT, ["-C", root, ...args], { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"], ...opts });
}

function gh(root, args, opts = {}) {
  return execFileSync(GH, args, { cwd: root, encoding: "utf8", stdio: ["ignore", "pipe", "pipe"], ...opts });
}

function failText(e) {
  return `${e.stderr || ""}${e.stdout || ""}`.trim() || e.message;
}

function sleepSync(ms) {
  Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms);
}

/**
 * Poll PR checks until all pass. Stop on a failed check or a timeout. While no check is listed, read
 * the PR's mergeability. GitHub starts no workflow for a conflicting PR, so a conflict means no check
 * will ever appear (0000483). A wait that lists no check within MQ_NOCHECKS_MS also stops.
 */
function waitForChecks(root, pr) {
  const poll = Number(process.env.MQ_POLL_MS) || 10000;
  const timeout = Number(process.env.MQ_TIMEOUT_MS) || 1800000;
  const noChecks = Number(process.env.MQ_NOCHECKS_MS) || 600000;
  const start = Date.now();
  for (;;) {
    let out = "";
    try {
      out = gh(root, ["pr", "checks", pr, "--json", "name,bucket"]);
    } catch (e) {
      out = e.stdout || "";
    }
    let list = null;
    try {
      list = JSON.parse(out);
    } catch {
      list = null;
    }
    if (Array.isArray(list) && list.length > 0) {
      const bad = list.filter((c) => c.bucket === "fail" || c.bucket === "cancel");
      if (bad.length) throw new Stop(`CI failed on PR #${pr}: ${bad.map((c) => c.name).join(", ")}`);
      if (list.every((c) => c.bucket === "pass" || c.bucket === "skipping")) return;
    } else {
      if (prState(root, pr).mergeable === "CONFLICTING") {
        throw new Stop(`PR #${pr} conflicts with its base branch, so GitHub runs no checks. Merge the base into the PR branch and rerun.`);
      }
      if (Date.now() - start >= noChecks) {
        throw new Stop(`no CI checks appeared on PR #${pr} within ${Math.round(noChecks / 1000)}s`);
      }
    }
    if (Date.now() - start >= timeout) throw new Stop(`timed out waiting for CI on PR #${pr}`);
    sleepSync(poll);
  }
}

// GitHub checks a pushed head and works out mergeability some seconds after the push. Until then,
// `gh pr checks` can report the previous head and `gh pr merge` answers "not mergeable" (0000411).
const MERGE_READY = new Set(["CLEAN", "HAS_HOOKS", "UNSTABLE"]);

function prState(root, pr) {
  try {
    return JSON.parse(gh(root, ["pr", "view", pr, "--json", "headRefOid,mergeable,mergeStateStatus"]));
  } catch {
    return {};
  }
}

/** Poll the PR state until `ok` holds. Stop on a timeout, naming what the queue waited for. */
function waitForState(root, pr, what, ok) {
  const poll = Number(process.env.MQ_POLL_MS) || 10000;
  const timeout = Number(process.env.MQ_TIMEOUT_MS) || 1800000;
  const start = Date.now();
  for (;;) {
    if (ok(prState(root, pr))) return;
    if (Date.now() - start >= timeout) throw new Stop(`timed out waiting for PR #${pr}: ${what}`);
    sleepSync(poll);
  }
}

/** Wait until GitHub shows `sha` as the PR head, then wait for CI on it. */
function waitForHeadChecks(root, pr, sha) {
  waitForState(root, pr, `head ${sha.slice(0, 8)}`, (s) => s.headRefOid === sha);
  waitForChecks(root, pr);
}

function waitForMergeable(root, pr) {
  waitForState(root, pr, "mergeable", (s) => s.mergeable === "MERGEABLE" && MERGE_READY.has(s.mergeStateStatus));
}

/** Squash-merge once GitHub reports the PR mergeable. Retry once on a transient refusal. */
function mergeWhenReady(root, pr) {
  for (let attempt = 1; ; attempt++) {
    waitForMergeable(root, pr);
    try {
      gh(root, ["pr", "merge", pr, "--squash", "--delete-branch"]);
      return;
    } catch (e) {
      const text = failText(e);
      if (attempt >= 2 || !/not mergeable|Base branch was modified/i.test(text)) {
        throw new Stop(`gh pr merge failed: ${text}`);
      }
    }
  }
}

// ---------------------------------------------------------------- chart

function splitRow(line) {
  return line.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map((c) => c.trim());
}

/** Line range [start, end) of a `## name` section, or null. */
function sectionRange(lines, name) {
  const start = lines.findIndex((l) => l.trim() === `## ${name}`);
  if (start < 0) return null;
  let end = lines.length;
  for (let i = start + 1; i < lines.length; i++) {
    if (/^## /.test(lines[i])) { end = i; break; }
  }
  return [start, end];
}

/** Find the chart row for a step. Returns { index, cells, header } or null. */
export function findStepRow(text, step) {
  const lines = text.split("\n");
  const range = sectionRange(lines, "Steps");
  if (!range) return null;
  let header = null;
  for (let i = range[0] + 1; i < range[1]; i++) {
    if (!lines[i].trim().startsWith("|")) continue;
    const cells = splitRow(lines[i]);
    if (header === null) { header = cells; continue; }
    if (cells[0] === String(step)) return { index: i, cells, header };
  }
  return null;
}

export function expectedTitle(row) {
  const col = (n) => row.cells[row.header.indexOf(n)];
  return `${col("Feature id").slice(0, 7)}: ${col("Title")}`;
}

function readChartText(chartPath) {
  if (!existsSync(chartPath)) throw new Stop(`chart not found: ${chartPath}`);
  return readFileSync(chartPath, "utf8");
}

function checkTitle(chartText, step, title) {
  const row = findStepRow(chartText, step);
  if (!row) throw new Stop(`no chart row for step ${step}`);
  const want = expectedTitle(row);
  if (title !== want) throw new Stop(`title mismatch. Expected: ${want}`);
  return row;
}

function setCell(lines, row, name, value) {
  row.cells[row.header.indexOf(name)] = value;
  lines[row.index] = `|${row.cells.map((c) => (c ? ` ${c} ` : " ")).join("|")}|`;
}

/** Return chart text with the step row and the Merges table updated. */
export function updateChart(text, { step, pr, version, mergedAt }) {
  const lines = text.split("\n");
  const row = findStepRow(text, step);
  if (!row) throw new Stop(`no chart row for step ${step}`);
  setCell(lines, row, "Version", version);
  setCell(lines, row, "Status", "merged");
  const mergeRow = `| ${step} | #${pr} | tag v${version} | ${version} | ${mergedAt} |`;
  let range = sectionRange(lines, "Merges");
  if (!range) {
    while (lines.length && lines[lines.length - 1] === "") lines.pop();
    lines.push("", "## Merges", "", `| ${MERGES_HEADER.join(" | ")} |`,
      `|${MERGES_HEADER.map((h) => "-".repeat(h.length + 2)).join("|")}|`, "");
    range = sectionRange(lines, "Merges");
  }
  const existing = [];
  let lastTable = range[0];
  for (let i = range[0] + 1; i < range[1]; i++) {
    if (!lines[i].trim().startsWith("|")) continue;
    lastTable = i;
    const c = splitRow(lines[i]);
    if (c[0] === String(step) && c[1] === `#${pr}`) existing.push(i);
  }
  if (existing.length === 0) lines.splice(lastTable + 1, 0, mergeRow);
  setPosition(lines);
  return lines.join("\n");
}

/** Point an existing Position field at the lowest unmerged step, or one past the last. */
function setPosition(lines) {
  const range = sectionRange(lines, "Steps");
  if (!range) return;
  let header = null;
  let lowest = null;
  let last = 0;
  for (let i = range[0] + 1; i < range[1]; i++) {
    if (!lines[i].trim().startsWith("|")) continue;
    const cells = splitRow(lines[i]);
    if (header === null) { header = cells; continue; }
    const n = Number(cells[0]);
    if (!Number.isInteger(n)) continue;
    last = Math.max(last, n);
    if (cells[header.indexOf("Status")] !== "merged" && (lowest === null || n < lowest)) lowest = n;
  }
  if (header === null || last === 0) return;
  const position = lowest ?? last + 1;
  for (let i = 0; i < lines.length; i++) {
    const m = /^(\s*(?:\*\*Position:\*\*|[Pp]osition:)\s*)\d+(.*)$/.exec(lines[i]);
    if (m) { lines[i] = `${m[1]}${position}${m[2]}`; break; }
  }
}

// ---------------------------------------------------------------- versions

function bump(version, kind) {
  const m = /^(\d+)\.(\d+)\.(\d+)$/.exec(version);
  if (!m) throw new Stop(`not MAJOR.MINOR.PATCH: ${version}`);
  let [a, b, c] = m.slice(1).map(Number);
  if (kind === "major") { a += 1; b = 0; c = 0; }
  else if (kind === "minor") { b += 1; c = 0; }
  else if (kind === "patch") { c += 1; }
  else throw new Stop(`unknown Bump: ${kind}`);
  return `${a}.${b}.${c}`;
}

function cmpVersion(x, y) {
  const a = x.split(".").map(Number), b = y.split(".").map(Number);
  for (let i = 0; i < 3; i++) if (a[i] !== b[i]) return a[i] - b[i];
  return 0;
}

function nextVersion(current, kind) {
  const next = bump(current, kind);
  return cmpVersion(next, current) < 0 ? current : next;
}

function agreed(rows) {
  const first = rows[0]?.version;
  return rows.every((r) => r.version === first) ? first : null;
}

/** Read the version files as they stand on a git ref. */
function versionsOnRef(root, ref, list) {
  const tmp = mkdtempSync(join(tmpdir(), "mq-base-"));
  try {
    for (const { path: p, optional } of readEntries(list)) {
      let text;
      try {
        text = git(root, ["show", `${ref}:${p}`]);
      } catch (e) {
        if (optional) continue; // an optional file the ref lacks (0000420)
        throw e;
      }
      const dest = join(tmp, p);
      mkdirSync(dirname(dest), { recursive: true });
      writeFileSync(dest, text);
    }
    const rows = readVersions({ root: tmp, list });
    const v = agreed(rows);
    if (v === null) throw new Stop(`version files differ on ${ref}`);
    return v;
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
}

/**
 * The set-version commits of this step that an earlier run left on the PR branch and no later revert
 * undid, newest first. A revert commit names the versions it undid, so the scan skips them (0000454).
 */
function activeVersionCommits(root, base, featureId, step) {
  const id7 = featureId.slice(0, 7);
  const setRe = /^chore\((\d{7})\): set version (\d+\.\d+\.\d+) for step (\d+)$/;
  const revertRe = /^chore\((\d{7})\): revert set version ([0-9., ]+) for step (\d+)$/;
  const owed = new Map();
  const active = [];
  for (const line of git(root, ["log", "--format=%H%x09%s", `origin/${base}..HEAD`]).split("\n")) {
    const [sha, subject = ""] = line.split("\t");
    // Fixed patterns, then a compare of the captured id and step, so no input builds a pattern.
    const undone = revertRe.exec(subject);
    if (undone && undone[1] === id7 && undone[3] === String(step)) {
      for (const v of undone[2].split(", ")) owed.set(v, (owed.get(v) ?? 0) + 1);
      continue;
    }
    const set = setRe.exec(subject);
    if (!set || set[1] !== id7 || set[3] !== String(step)) continue;
    if ((owed.get(set[2]) ?? 0) > 0) owed.set(set[2], owed.get(set[2]) - 1);
    else active.push({ sha, version: set[2] });
  }
  return active;
}

/**
 * A failed run can leave a set-version commit on the PR branch. If the base version has moved since, the
 * merge of the base conflicts on the version rows. Revert those commits in one new commit and push it
 * without force, so the merge sees the rows as the base left them (0000454, ADR-0299).
 */
function revertStaleVersionCommits({ root, list, base, head, featureId, step, bumpKind }) {
  const active = activeVersionCommits(root, base, featureId, step);
  if (active.length === 0) return;
  const next = nextVersion(versionsOnRef(root, `origin/${base}`, list), bumpKind);
  if (active.every((c) => c.version === next)) return;
  try {
    git(root, ["revert", "--no-commit", ...active.map((c) => c.sha)]);
  } catch (e) {
    if (spawnSync(GIT, ["-C", root, "revert", "--abort"]).status !== 0) {
      spawnSync(GIT, ["-C", root, "reset", "--merge"]);
    }
    throw new Stop(`revert of the earlier set-version commit failed: ${failText(e)}`);
  }
  const versions = [...new Set(active.map((c) => c.version))].join(", ");
  git(root, ["commit", "-m", `chore(${featureId.slice(0, 7)}): revert set version ${versions} for step ${step}`]);
  git(root, ["push", "origin", `${head}:${head}`]);
  console.log(`reverted set version ${versions}: the base moved to ${next}`);
}

// ---------------------------------------------------------------- subcommands

function parseArgs(argv) {
  const o = { cmd: argv[0], root: process.cwd() };
  const flags = { "--step": "step", "--title": "title", "--chart": "chart", "--root": "root", "--pr": "pr", "--list": "list" };
  for (let i = 1; i < argv.length; i++) {
    const key = flags[argv[i]];
    if (!key) throw new Stop(`unknown argument: ${argv[i]}`);
    if (i + 1 >= argv.length) throw new Stop(`missing value for ${argv[i]}`);
    o[key] = argv[++i];
  }
  return o;
}

function requireInt(v, name) {
  if (!/^[0-9]+$/.test(v ?? "")) throw new Stop(`${name} must be a whole number`);
  return v;
}

function chartPathFor(a) {
  const c = a.chart ?? DEFAULT_CHART;
  return isAbsolute(c) ? c : resolve(a.root, c);
}

function cmdTitle(a) {
  requireInt(a.step, "--step");
  if (a.title === undefined) throw new Stop("missing --title");
  checkTitle(readChartText(chartPathFor(a)), a.step, a.title);
  console.log("title ok");
}

function cmdVersions(a) {
  const rows = readVersions({ root: a.root, list: a.list ?? DEFAULT_LIST });
  const first = rows[0]?.version;
  const differ = rows.filter((r) => r.version !== first);
  if (differ.length) {
    throw new Stop(`version mismatch (${rows[0].path} holds ${first}): ${differ.map((r) => `${r.path} holds ${r.version}`).join(", ")}`);
  }
  console.log(`ok: ${first}`);
}

function cmdRun(a) {
  const step = requireInt(a.step, "--step");
  const pr = requireInt(a.pr, "--pr");
  const root = resolve(a.root);
  const list = a.list ?? DEFAULT_LIST;
  const chartAbs = chartPathFor(a);
  const chartRel = relative(root, chartAbs);

  if (git(root, ["status", "--porcelain", "--untracked-files=no"]).trim() !== "") {
    throw new Stop("working tree is not clean");
  }

  // 1. PR title check against the chart on the base branch.
  let info;
  try {
    info = JSON.parse(gh(root, ["pr", "view", pr, "--json", "title,headRefName,baseRefName"]));
  } catch (e) {
    throw new Stop(`gh pr view failed: ${failText(e)}`);
  }
  const { title, headRefName: head, baseRefName: base } = info;
  // Git would read a name that starts with a dash as an option (0000400).
  for (const [field, value] of [["headRefName", head], ["baseRefName", base]]) {
    if (typeof value !== "string" || value.startsWith("-")) {
      throw new Stop(`${field} must not start with a dash: ${value}`);
    }
  }
  git(root, ["fetch", "origin", base, head]);
  const baseChart = git(root, ["show", `origin/${base}:${chartRel}`]);
  const row = checkTitle(baseChart, step, title);
  const featureId = row.cells[row.header.indexOf("Feature id")];
  const bumpKind = row.cells[row.header.indexOf("Bump")];

  // 2. Check out the PR branch and merge the base into it (ADR-001).
  const hasLocal = spawnSync(GIT, ["-C", root, "rev-parse", "-q", "--verify", `refs/heads/${head}`]).status === 0;
  if (hasLocal) {
    git(root, ["switch", head]);
    git(root, ["merge", "--ff-only", `origin/${head}`]);
  } else {
    git(root, ["switch", "-c", head, "--track", `origin/${head}`]);
  }
  try {
    mergeAndRelease({ root, list, chartAbs, chartRel, step, pr, base, head, featureId, bumpKind });
  } finally {
    // Leave the worktree on no branch, so a restart can check the PR branch out (0000454).
    spawnSync(GIT, ["-C", root, "switch", "--detach"], { stdio: "ignore" });
  }
}

/**
 * The base merge reported a conflict. Resolve the shared files the queue owns and commit the merge.
 * Any other conflict, or a failure that left no merge in progress, aborts the merge and stops (0000456).
 */
function resolveBaseMerge({ root, base, head, mergeSubject, mergeError }) {
  let resolved;
  try {
    if (spawnSync(GIT, ["-C", root, "rev-parse", "-q", "--verify", "MERGE_HEAD"]).status !== 0) throw mergeError;
    resolved = resolveSharedConflicts({ root });
    git(root, ["commit", "-m", mergeSubject]);
  } catch (e) {
    spawnSync(GIT, ["-C", root, "merge", "--abort"]);
    const detail = e === mergeError ? failText(e) : e.message;
    throw new Stop(`merge of ${base} into ${head} failed: ${detail}`);
  }
  for (const file of resolved) console.log(`resolved: ${file}`);
}

/** Steps 2 to 6 of `run`, on the PR branch that the caller checked out. */
function mergeAndRelease({ root, list, chartAbs, chartRel, step, pr, base, head, featureId, bumpKind }) {
  // Take back the version commits of an earlier failed run when the base version has moved (0000454).
  revertStaleVersionCommits({ root, list, base, head, featureId, step, bumpKind });
  // A short subject of our own (0000405). Git's default names both branches and can pass the
  // 72-character limit that the blocking commit-msg hook enforces.
  const mergeSubject = `${featureId.slice(0, 7)}: Merge the initiative branch`;
  try {
    git(root, ["merge", "-m", mergeSubject, `origin/${base}`]);
  } catch (e) {
    resolveBaseMerge({ root, base, head, mergeSubject, mergeError: e });
  }
  const mergedHead = git(root, ["rev-parse", "HEAD"]).trim();
  if (mergedHead !== git(root, ["rev-parse", `origin/${head}`]).trim()) {
    git(root, ["push", "origin", `${head}:${head}`]);
  }

  // 3. Wait for GitHub to see the head, then for CI on it.
  waitForHeadChecks(root, pr, mergedHead);

  // 4. Next version from the base branch.
  const next = nextVersion(versionsOnRef(root, `origin/${base}`, list), bumpKind);

  // 5. Skip the edits when the PR branch already holds them (rerun).
  const treeChart = findStepRow(readChartText(chartAbs), step);
  const done = treeChart
    && treeChart.cells[treeChart.header.indexOf("Status")] === "merged"
    && treeChart.cells[treeChart.header.indexOf("Version")] === next
    && agreed(readVersions({ root, list })) === next;
  if (!done) {
    try {
      setVersions(next, { root, list });
    } catch (e) {
      throw new Stop(`set version failed: ${e.message}`);
    }
    cmdVersions({ root, list });
    const mergedAt = new Date().toISOString().replace(/\.\d+Z$/, "Z");
    writeFileSync(chartAbs, updateChart(readChartText(chartAbs), { step, pr, version: next, mergedAt }));
    // Stage only the listed files that exist, so an optional file a repo lacks is left out (0000420).
    const paths = [chartRel, ...presentPaths(root, list)];
    git(root, ["add", "--", ...paths]);
    git(root, ["commit", "-m", `chore(${featureId.slice(0, 7)}): set version ${next} for step ${step}`, "--", ...paths]);
    git(root, ["push", "origin", `${head}:${head}`]);
    // The push restarts CI on the new head. Wait for GitHub to see it, then for CI.
    waitForHeadChecks(root, pr, git(root, ["rev-parse", "HEAD"]).trim());
  } else {
    cmdVersions({ root, list });
  }

  // 6. Squash-merge once GitHub reports the PR mergeable, then tag the merge commit. Nothing is
  // committed after this.
  mergeWhenReady(root, pr);
  git(root, ["fetch", "origin", base]);
  let sha;
  try {
    sha = JSON.parse(gh(root, ["pr", "view", pr, "--json", "mergeCommit"])).mergeCommit?.oid;
  } catch (e) {
    throw new Stop(`gh pr view failed: ${failText(e)}`);
  }
  if (!sha) throw new Stop(`PR #${pr} has no merge commit`);
  git(root, ["tag", `v${next}`, "-m", featureId, sha]);
  git(root, ["push", "origin", `v${next}`]);
  console.log(`merged PR #${pr} as v${next} at ${sha}`);
}

function main(argv) {
  try {
    const a = parseArgs(argv);
    if (a.cmd === "title") cmdTitle(a);
    else if (a.cmd === "versions") cmdVersions(a);
    else if (a.cmd === "run") cmdRun(a);
    else throw new Stop("usage: merge-queue.mjs title|versions|run [options]");
    return 0;
  } catch (e) {
    console.error(`merge-queue: ${e instanceof Stop ? e.message : failText(e)}`);
    return 1;
  }
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  process.exit(main(process.argv.slice(2)));
}
