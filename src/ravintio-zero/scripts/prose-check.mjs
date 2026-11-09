#!/usr/bin/env node
// Checks Markdown and commit messages against the writing standard, with a
// per-file baseline (0000390 REQ-001, REQ-002, ADR-0285, ADR-0288, ADR-0289).
//
// Usage:
//   node prose-check.mjs check [--files f...] [--staged] [--message file] [--baseline path]
//   node prose-check.mjs update [--init] [--baseline path]
//   node prose-check.mjs diff --base <ref> [--baseline path]
//   Add --root <dir> to work in another folder. The default is the current folder.
//
// check    Prints "file:line rule: detail" for each breach of a rule whose count
//          is above the file's baseline, and exits 1. With --message the file is a
//          commit message, the baseline is ignored, and any breach fails.
//          With no file option it reads every in-scope Markdown file.
// update   Lowers the baseline to the current counts. It never raises a count and
//          exits 1 if a count is above its baseline. --init writes the first
//          baseline and fails if one exists.
// diff     Exits 1 if the working baseline holds a higher count than the baseline
//          at <ref>. A <ref> with no baseline file passes.
// Exit codes: 0 = ok, 1 = a breach or a raised count, 2 = bad usage or input.
//
// The baseline is plan/state/prose-baseline.json:
//   {"version": 1, "files": {"path": {"rule-id": count}}}
// The scope is Markdown under docs/, ravintio-zero/, ravintio-overrides/, plan/,
// src/, .github/, and the repo root. plan/_archive/, ravintio-zero/tests/,
// CLAUDE.md, and AGENTS.md are out of scope.

import fs from "node:fs";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

import { checkMessage, checkText, RULES } from "../hooks/enforcement/prose-rules.mjs";

const DEFAULT_BASELINE = "plan/state/prose-baseline.json";
const SCOPE_ROOTS = ["docs/", "ravintio-zero/", "ravintio-overrides/", "plan/", "src/", ".github/"];
const SCOPE_SKIP = ["plan/_archive/", "ravintio-zero/tests/", "node_modules/", ".git/", "src/ravintio-zero/tests/"];
const SCOPE_SKIP_FILES = new Set(["CLAUDE.md", "AGENTS.md"]);

function fail(message, code = 2) {
  process.stderr.write(`prose-check: ${message}\n`);
  process.exit(code);
}

export function inScope(rel) {
  const p = rel.split(path.sep).join("/");
  if (!p.endsWith(".md")) return false;
  if (SCOPE_SKIP_FILES.has(p)) return false;
  if (SCOPE_SKIP.some((s) => p.startsWith(s))) return false;
  if (!p.includes("/")) return true;
  return SCOPE_ROOTS.some((r) => p.startsWith(r));
}

function git(root, args) {
  return execFileSync("git", args, { cwd: root, encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] });
}

function listFiles(root) {
  try {
    return git(root, ["ls-files", "-z", "--", "*.md"]).split("\0").filter(Boolean).filter(inScope);
  } catch {
    const out = [];
    const walk = (dir) => {
      for (const e of fs.readdirSync(path.join(root, dir), { withFileTypes: true })) {
        const rel = dir ? `${dir}/${e.name}` : e.name;
        if (e.isDirectory()) {
          if (e.name === ".git" || e.name === "node_modules") continue;
          walk(rel);
        } else if (inScope(rel)) out.push(rel);
      }
    };
    walk("");
    return out;
  }
}

function stagedFiles(root) {
  try {
    return git(root, ["diff", "--cached", "--name-only", "--diff-filter=ACMR", "-z"])
      .split("\0").filter(Boolean).filter(inScope);
  } catch {
    fail("could not read the staged files");
  }
}

function breachesOf(root, rel) {
  let text;
  try {
    text = fs.readFileSync(path.join(root, rel), "utf8");
  } catch {
    return null;
  }
  return checkText(text);
}

function countsOf(breaches) {
  const counts = {};
  for (const b of breaches) counts[b.rule] = (counts[b.rule] ?? 0) + 1;
  return counts;
}

function readBaseline(file) {
  if (!fs.existsSync(file)) return { version: 1, files: {} };
  return parseBaseline(fs.readFileSync(file, "utf8"), file);
}

function parseBaseline(text, label) {
  let data;
  try {
    data = JSON.parse(text);
  } catch {
    fail(`${label} is not valid JSON`);
  }
  if (!data || typeof data !== "object" || typeof data.files !== "object" || data.files === null) {
    fail(`${label} has no files object`);
  }
  return data;
}

function writeBaseline(file, files) {
  const sorted = {};
  for (const k of Object.keys(files).sort()) {
    const row = {};
    for (const r of Object.keys(files[k]).sort()) row[r] = files[k][r];
    sorted[k] = row;
  }
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, JSON.stringify({ version: 1, files: sorted }, null, 2) + "\n");
}

function parseArgs(argv) {
  const opts = { files: null, staged: false, message: null, init: false, base: null, baseline: null, root: process.cwd() };
  const rest = argv.slice(1);
  for (let i = 0; i < rest.length; i++) {
    const a = rest[i];
    if (a === "--staged") opts.staged = true;
    else if (a === "--init") opts.init = true;
    else if (a === "--message") opts.message = rest[++i] ?? fail("--message needs a file");
    else if (a === "--base") opts.base = rest[++i] ?? fail("--base needs a ref");
    else if (a === "--baseline") opts.baseline = rest[++i] ?? fail("--baseline needs a path");
    else if (a === "--root") opts.root = path.resolve(rest[++i] ?? fail("--root needs a folder"));
    else if (a === "--files") {
      opts.files = [];
      while (i + 1 < rest.length && !rest[i + 1].startsWith("--")) opts.files.push(rest[++i]);
    } else fail(`unknown option ${a}`);
  }
  return opts;
}

function runCheck(opts) {
  if (opts.message) {
    let text;
    try {
      text = fs.readFileSync(opts.message, "utf8");
    } catch {
      fail("could not read the message file");
    }
    const found = checkMessage(text);
    for (const b of found) console.log(`message:${b.line} ${b.rule}: ${b.detail}`);
    if (found.length) {
      console.log(`prose-check: ${found.length} breach(es) in the commit message`);
      process.exit(1);
    }
    console.log("prose-check: ok (commit message)");
    return;
  }

  const baselineFile = path.resolve(opts.root, opts.baseline ?? DEFAULT_BASELINE);
  const baseline = readBaseline(baselineFile).files;
  const files = opts.files ?? (opts.staged ? stagedFiles(opts.root) : listFiles(opts.root));
  let bad = 0;
  for (const rel of files) {
    const found = breachesOf(opts.root, rel);
    if (found === null) continue;
    const counts = countsOf(found);
    for (const rule of RULES) {
      const have = counts[rule] ?? 0;
      const allowed = baseline[rel]?.[rule] ?? 0;
      if (have <= allowed) continue;
      bad++;
      console.log(`${rel}: ${rule} count ${have} is above the baseline ${allowed}`);
      for (const b of found.filter((x) => x.rule === rule)) {
        console.log(`${rel}:${b.line} ${rule}: ${b.detail}`);
      }
    }
  }
  if (bad) {
    console.log(`prose-check: ${bad} rule count(s) above the baseline`);
    process.exit(1);
  }
  console.log(`prose-check: ok (${files.length} files)`);
}

function runUpdate(opts) {
  const baselineFile = path.resolve(opts.root, opts.baseline ?? DEFAULT_BASELINE);
  const exists = fs.existsSync(baselineFile);
  if (opts.init && exists) fail("the baseline exists. Run update without --init");
  if (!opts.init && !exists) fail("no baseline file. Run update --init to write the first one");
  const old = exists ? readBaseline(baselineFile).files : {};
  const next = {};
  let raised = 0;
  for (const rel of listFiles(opts.root)) {
    const found = breachesOf(opts.root, rel);
    if (found === null) continue;
    const counts = countsOf(found);
    for (const rule of RULES) {
      const have = counts[rule] ?? 0;
      if (!have) continue;
      const allowed = old[rel]?.[rule];
      if (opts.init) {
        (next[rel] ??= {})[rule] = have;
      } else if (allowed === undefined || have > allowed) {
        raised++;
        console.log(`${rel}: ${rule} count ${have} is above the baseline ${allowed ?? 0}`);
        if (allowed !== undefined) (next[rel] ??= {})[rule] = allowed;
      } else {
        (next[rel] ??= {})[rule] = have;
      }
    }
  }
  writeBaseline(baselineFile, next);
  if (raised) {
    console.log(`prose-check: ${raised} rule count(s) above the baseline, left unrecorded`);
    process.exit(1);
  }
  console.log(`prose-check: baseline written (${Object.keys(next).length} files)`);
}

function runDiff(opts) {
  if (!opts.base) fail("diff needs --base <ref>");
  const rel = opts.baseline ?? DEFAULT_BASELINE;
  const baselineFile = path.resolve(opts.root, rel);
  const now = readBaseline(baselineFile).files;
  let raw = null;
  try {
    raw = git(opts.root, ["show", `${opts.base}:${rel.split(path.sep).join("/")}`]);
  } catch {
    raw = null;
  }
  const before = raw === null ? null : parseBaseline(raw, `${rel} at ${opts.base}`).files;
  if (before === null) {
    console.log(`prose-check: ok (no baseline at ${opts.base})`);
    return;
  }
  let bad = 0;
  for (const file of Object.keys(now)) {
    for (const rule of Object.keys(now[file])) {
      const was = before[file]?.[rule] ?? 0;
      if (now[file][rule] > was) {
        bad++;
        console.log(`${file}: ${rule} baseline rises from ${was} to ${now[file][rule]}`);
      }
    }
  }
  if (bad) {
    console.log(`prose-check: ${bad} baseline count(s) rise above ${opts.base}`);
    process.exit(1);
  }
  console.log(`prose-check: ok (baseline does not rise above ${opts.base})`);
}

const isMain = (() => {
  try { return fs.realpathSync(process.argv[1]) === fs.realpathSync(fileURLToPath(import.meta.url)); } catch { return false; }
})();
if (isMain) {
  const command = process.argv[2];
  if (!["check", "update", "diff"].includes(command)) fail("usage: prose-check.mjs check|update|diff [options]");
  const opts = parseArgs(process.argv.slice(2));
  if (command === "check") runCheck(opts);
  else if (command === "update") runUpdate(opts);
  else runDiff(opts);
}
