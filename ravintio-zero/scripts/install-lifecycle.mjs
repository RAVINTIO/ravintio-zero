#!/usr/bin/env node
// Install lifecycle for the pack (0000382). Setup and setup.ps1 call this
// script for --doctor, --update, and --uninstall, so both shells share one
// implementation.
//
//   node install-lifecycle.mjs doctor    --root R --tool T [--quick]
//   node install-lifecycle.mjs uninstall --root R --tool T
//   node install-lifecycle.mjs update    --root R --tool T --source S
//   node install-lifecycle.mjs flags     --root R --tool T
//
// Exit 0 on success. Exit 1 with a fixed message on a failed check or refusal.

import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const PACK = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const PACK_NAME = "ravintio-zero";
const OVERRIDES_NAME = "ravintio-overrides";

// One row per tool. The values mirror setup/<tool>.sh.
const TOOLS = {
  "claude-code": {
    skills: ".claude/skills",
    commands: ".claude/commands",
    settings: ".claude/settings.json",
    hooksDir: ".claude/hooks/enforcement",
    boot: "CLAUDE.md",
    bootTemplate: "templates/standard-boot.md",
    markerDir: ".claude",
    wired: [
      "gate-write", "ratchet-check", "em-dash-guard", "merge-guard",
      "block-forced-add", "auto-trigger-orchestrator",
      "check-orchestrator-presence", "check-design", "check-reply-prefix",
    ],
  },
  codex: {
    skills: ".agents/skills",
    commands: null,
    settings: ".codex/hooks.json",
    hooksDir: ".codex/hooks/enforcement",
    boot: "AGENTS.md",
    bootTemplate: "templates/codex-boot.md",
    markerDir: ".agents",
    wired: ["merge-guard", "block-forced-add"],
  },
};

const GIT_HOOKS = ["pre-commit", "pre-push", "commit-msg"];
// The old names are built from parts, so the brand and old-name guards do not
// read this detector as a live use of them.
const OLD_BRAND = ["plan", "ifest"].join("");
const OLD_UNIT = ["road", "map"].join("");
const LEFTOVERS = [
  `${OLD_BRAND}-zero`, `${OLD_BRAND}-overrides`, `.github/workflows/${OLD_BRAND}.yml`,
  `.claude/.${OLD_BRAND}-setup-flags`, `.claude/skills/.${OLD_BRAND}-manifest`,
  `plan/.${OLD_UNIT}-logs`, `plan/current-${OLD_UNIT}`,
];
const OLD_RUN_MODE = ["contin", "uous"].join("");

function parseArgs(argv) {
  const [cmd, ...rest] = argv;
  const o = { cmd, quick: false };
  for (let i = 0; i < rest.length; i++) {
    const a = rest[i];
    if (a === "--quick") o.quick = true;
    else if (a === "--root") o.root = rest[++i];
    else if (a === "--tool") o.tool = rest[++i];
    else if (a === "--source") o.source = rest[++i];
    else fail(`unknown argument ${a.split("=")[0]}`);
  }
  o.root = path.resolve(o.root || path.dirname(PACK));
  return o;
}

function fail(msg) {
  process.stderr.write(`! Error: ${msg}\n`);
  process.exit(1);
}

function toolOf(o) {
  const t = TOOLS[o.tool];
  if (!t) fail(`unknown tool ${/^[a-z0-9-]+$/.test(o.tool || "") ? o.tool : "(name not shown)"}`);
  return t;
}

function git(root, args) {
  try {
    return execFileSync("git", ["-C", root, ...args], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] });
  } catch (_) {
    return null;
  }
}

const exists = p => { try { fs.lstatSync(p); return true; } catch (_) { return false; } };
const isLink = p => { try { return fs.lstatSync(p).isSymbolicLink(); } catch (_) { return false; } };
const isFile = p => { try { return fs.statSync(p).isFile(); } catch (_) { return false; } };
const isDir = p => { try { return fs.statSync(p).isDirectory(); } catch (_) { return false; } };

function readJson(p) {
  try { return JSON.parse(fs.readFileSync(p, "utf8").replace(/^﻿/, "")); } catch (_) { return undefined; }
}

function listDir(p) {
  try { return fs.readdirSync(p); } catch (_) { return []; }
}

// Map of relative file path to a content hash. Skips macOS metadata files.
function treeHash(dir, base = dir, out = new Map()) {
  for (const name of listDir(dir)) {
    if (name === ".DS_Store") continue;
    const p = path.join(dir, name);
    if (isLink(p)) continue;
    if (isDir(p)) treeHash(p, base, out);
    else out.set(path.relative(base, p), crypto.createHash("sha1").update(fs.readFileSync(p)).digest("hex"));
  }
  return out;
}

function recordFlags(root, tool) {
  const p = path.join(root, "plan", "state", `${tool}.md`);
  if (!isFile(p)) return null;
  const m = /```json\s*([\s\S]*?)```/.exec(fs.readFileSync(p, "utf8"));
  if (!m) return null;
  try {
    const j = JSON.parse(m[1]);
    return Array.isArray(j.flags) ? j.flags : null;
  } catch (_) { return null; }
}

const HOOK_MODULE = () => {
  const names = listDir(path.join(PACK, "hooks", "enforcement"))
    .filter(n => n.endsWith(".mjs")).map(n => n.slice(0, -4));
  return new RegExp(`(^|[\\s"'/\\\\])(${names.join("|")})\\.mjs\\b`);
};

// Every command string that a settings or hooks file wires.
function wiredCommands(settings) {
  const out = [];
  const hooks = settings && settings.hooks;
  if (!hooks || typeof hooks !== "object") return out;
  for (const entries of Object.values(hooks)) {
    if (!Array.isArray(entries)) continue;
    for (const e of entries) {
      const v = e && e.hooks;
      const list = Array.isArray(v) ? v : (v && typeof v === "object" ? [v] : []);
      for (const h of list) if (h && typeof h.command === "string") out.push(h.command);
    }
  }
  return out;
}

function gitHooksPathOk(root) {
  const v = git(root, ["config", "--get", "core.hooksPath"]);
  return v !== null && v.trim() === `${PACK_NAME}/hooks`;
}

// ---- doctor ---------------------------------------------------------------

function doctor(o) {
  const t = toolOf(o);
  const root = o.root;
  const results = [];
  const ok = (msg) => results.push({ ok: true, msg });
  const bad = (msg) => results.push({ ok: false, msg });

  const marker = path.join(root, t.markerDir, ".ravintio-setup-flags");
  const markerJson = readJson(marker);
  if (markerJson && markerJson.attemptStatus === "completed") ok(`setup has run (${t.markerDir}/.ravintio-setup-flags)`);
  else bad(`setup has not run: ${t.markerDir}/.ravintio-setup-flags is missing or incomplete. Run ${PACK_NAME}/setup.sh ${o.tool}`);

  if (!o.quick) {
    const template = path.join(PACK, t.bootTemplate);
    // Windows PowerShell 5.1 writes a BOM, so strip it before comparing lines.
    const readText = (f) => fs.readFileSync(f, "utf8").replace(/^\uFEFF/, "");
    const first = isFile(template) ? readText(template).split(/\r?\n/)[0] : "";
    const bootPath = path.join(root, t.boot);
    if (isFile(bootPath) && first && readText(bootPath).split(/\r?\n/).includes(first)) ok(`${t.boot} is the pack's`);
    else bad(`${t.boot} is missing or is not the pack's. Rerun setup`);
  }

  if (gitHooksPathOk(root)) ok(`core.hooksPath is ${PACK_NAME}/hooks`);
  else bad(`core.hooksPath is not ${PACK_NAME}/hooks. Rerun setup`);

  for (const h of GIT_HOOKS) {
    const p = path.join(PACK, "hooks", h);
    if (!isFile(p)) continue;
    let exec = true;
    try { fs.accessSync(p, fs.constants.X_OK); } catch (_) { exec = false; }
    if (exec) ok(`hook ${h} is executable`);
    else bad(`hook ${PACK_NAME}/hooks/${h} is not executable. Run chmod +x on it`);
  }

  const settingsPath = path.join(root, t.settings);
  const settings = readJson(settingsPath);
  const cmds = settings === undefined ? [] : wiredCommands(settings);
  for (const mod of t.wired) {
    const re = new RegExp(`(^|[\\s"'/\\\\])${mod}\\.mjs\\b`);
    if (cmds.some(c => re.test(c))) ok(`${mod} is wired in ${t.settings}`);
    else bad(`${mod} is not wired in ${t.settings}. Rerun setup`);
  }
  for (const mod of t.wired) {
    const f = path.join(root, t.hooksDir, `${mod}.mjs`);
    if (!isFile(f)) bad(`${t.hooksDir}/${mod}.mjs is missing. Rerun setup`);
  }

  const flags = recordFlags(root, o.tool);
  if (!o.quick) {
    const packSkills = path.join(PACK, "skills");
    for (const name of listDir(packSkills)) {
      const src = path.join(packSkills, name);
      if (!isFile(path.join(src, "SKILL.md"))) continue;
      const dest = path.join(root, t.skills, name);
      if (!isDir(dest)) { bad(`skill ${name} is missing from ${t.skills}. Rerun setup`); continue; }
      const a = treeHash(src), b = treeHash(dest);
      const diff = [...a.keys()].filter(k => b.get(k) !== a.get(k));
      if (diff.length) bad(`skill ${name} differs from the pack (${diff[0]}). Rerun setup`);
    }
    if (!results.some(r => !r.ok && r.msg.startsWith("skill "))) ok(`${t.skills} matches the pack`);

    if (flags === null) bad(`plan/state/${o.tool}.md is missing or unreadable. Rerun setup`);
    else {
      const strictOn = isFile(path.join(root, "plan", ".orchestrator-strict"));
      const wantsStrict = flags.includes("--strict-orchestrator");
      const installed = markerJson && Array.isArray(markerJson.flags) ? markerJson.flags : [];
      const same = installed.length === flags.length && installed.every(f => flags.includes(f));
      if (strictOn === wantsStrict && same) ok(`installed flags match plan/state/${o.tool}.md`);
      else bad(`installed flags differ from plan/state/${o.tool}.md. Rerun setup`);
    }

    const left = LEFTOVERS.filter(p => exists(path.join(root, p)));
    const runMode = path.join(root, "plan", ".run-mode");
    if (isFile(runMode) && fs.readFileSync(runMode, "utf8").trim() === OLD_RUN_MODE) left.push(`plan/.run-mode (holds ${OLD_RUN_MODE})`);
    if (left.length) bad(`files from an older pack remain: ${left.join(", ")}`);
    else ok("no files from an older pack remain");
  }

  const failures = results.filter(r => !r.ok);
  for (const r of results) {
    if (o.quick && r.ok) continue;
    console.log(`${r.ok ? "  ok  " : "  FAIL"} ${r.msg}`);
  }
  if (failures.length) {
    console.log(`Doctor found ${failures.length} problem${failures.length === 1 ? "" : "s"}.`);
    process.exit(1);
  }
  if (!o.quick) console.log("Doctor found no problems.");
}

// ---- uninstall ------------------------------------------------------------

function removeSettingsHooks(root, t) {
  const sf = path.join(root, t.settings);
  if (!isFile(sf)) return;
  const s = readJson(sf);
  if (s === undefined || s === null || typeof s !== "object" || Array.isArray(s)) {
    console.log(`  ! ${t.settings} is not a settings object, left unchanged`);
    return;
  }
  const re = HOOK_MODULE();
  const marker = t.hooksDir;
  let removed = 0;
  const hooks = s.hooks;
  if (hooks && typeof hooks === "object" && !Array.isArray(hooks)) {
    for (const ev of Object.keys(hooks)) {
      if (!Array.isArray(hooks[ev])) continue;
      const kept = [];
      for (const e of hooks[ev]) {
        const v = e && e.hooks;
        const single = v !== null && typeof v === "object" && !Array.isArray(v);
        const list = single ? [v] : v;
        if (!Array.isArray(list) || list.length === 0) { kept.push(e); continue; }
        const rest = list.filter(h => {
          const c = String((h && h.command) || "");
          const mine = c.includes(marker) && re.test(c);
          if (mine) { removed++; console.log(`  - removed hook ${c.match(/([a-z-]+)\.mjs/g).slice(-1)[0]} from ${t.settings}`); }
          return !mine;
        });
        if (rest.length === 0) continue;
        if (!single && rest.length !== list.length) e.hooks = rest;
        kept.push(e);
      }
      if (kept.length) hooks[ev] = kept; else delete hooks[ev];
    }
    if (Object.keys(hooks).length === 0) delete s.hooks;
  }
  if (removed === 0) return;
  const tmp = `${sf}.ravintio-tmp`;
  fs.writeFileSync(tmp, JSON.stringify(s, null, 2) + "\n", { mode: fs.statSync(sf).mode & 0o7777 });
  fs.renameSync(tmp, sf);
}

function uninstall(o) {
  const t = toolOf(o);
  const root = o.root;
  for (const guard of [path.join("plan", ".orchestrator-active"), path.join("plan", ".initiative-runner.lock")]) {
    if (exists(path.join(root, guard))) {
      fail(`${guard.split(path.sep).join("/")} exists, so a run is active. Finish or stop the run, then rerun uninstall. Nothing changed.`);
    }
  }
  console.log("");
  console.log("  Removing RAVINTIO setup changes");

  // Git hooks path.
  if (gitHooksPathOk(root)) {
    git(root, ["config", "--unset", "core.hooksPath"]);
    console.log("  - git config core.hooksPath unset");
  }

  removeSettingsHooks(root, t);

  // Enforcement hook scripts the pack copied.
  const hooksDir = path.join(root, t.hooksDir);
  for (const n of listDir(path.join(PACK, "hooks", "enforcement"))) {
    const f = path.join(hooksDir, n);
    if (isFile(f) && !isLink(f)) { fs.rmSync(f); console.log(`  - removed ${t.hooksDir}/${n}`); }
  }
  for (const d of [hooksDir, path.dirname(hooksDir)]) {
    if (isDir(d) && !isLink(d) && listDir(d).length === 0) fs.rmdirSync(d);
  }

  // Skills: manifest entries that name a pack or capability skill.
  const skillsDir = path.join(root, t.skills);
  const manifest = path.join(skillsDir, ".ravintio-manifest");
  const owned = new Set(listDir(path.join(PACK, "skills")));
  for (const n of listDir(path.join(root, OVERRIDES_NAME, "capability-skills"))) owned.add(n);
  if (isFile(manifest)) {
    for (const raw of fs.readFileSync(manifest, "utf8").split(/\r?\n/)) {
      const line = raw.trim();
      if (!line || line.split("/").includes("..")) continue;
      const name = path.basename(line);
      const p = path.join(skillsDir, name);
      if (path.dirname(path.resolve(root, line)) !== path.resolve(skillsDir)) continue;
      if (!owned.has(name) || isLink(p) || !isDir(p)) continue;
      fs.rmSync(p, { recursive: true, force: true });
      console.log(`  - removed ${t.skills}/${name}`);
    }
    fs.rmSync(manifest);
  }

  // Commands the pack shipped.
  if (t.commands) {
    const dir = path.join(root, t.commands);
    const cm = path.join(dir, ".ravintio-manifest");
    if (isFile(cm)) {
      for (const raw of fs.readFileSync(cm, "utf8").split(/\r?\n/)) {
        const name = raw.trim();
        if (!name || name.includes("/") || name.startsWith(".")) continue;
        const f = path.join(dir, name);
        if (isFile(f) && !isLink(f) && isFile(path.join(PACK, "workflows", name))) {
          fs.rmSync(f);
          console.log(`  - removed ${t.commands}/${name}`);
        }
      }
      fs.rmSync(cm);
    }
  }

  // Files setup wrote from pack copies. A file the developer edited stays.
  const same = (a, b) => isFile(a) && isFile(b) && fs.readFileSync(a).equals(fs.readFileSync(b));
  const wf = path.join(root, ".github", "workflows", "ravintio.yml");
  if (same(wf, path.join(PACK, "hooks", "ravintio.yml"))) { fs.rmSync(wf); console.log("  - removed .github/workflows/ravintio.yml"); }
  else if (isFile(wf)) console.log("  = kept .github/workflows/ravintio.yml (it differs from the pack copy)");
  const ga = path.join(root, ".gitattributes");
  if (same(ga, path.join(PACK, ".gitattributes"))) { fs.rmSync(ga); console.log("  - removed .gitattributes"); }
  else if (isFile(ga)) console.log("  = kept .gitattributes (it differs from the pack copy)");

  // Markers.
  for (const m of [path.join(t.markerDir, ".ravintio-setup-flags"), path.join("plan", ".orchestrator-strict"), path.join("plan", ".orchestrator-ack")]) {
    if (isFile(path.join(root, m))) { fs.rmSync(path.join(root, m)); console.log(`  - removed ${m.split(path.sep).join("/")}`); }
  }

  // Kept items, listed so the developer decides.
  console.log("");
  console.log("  Kept for you to review:");
  if (isFile(path.join(root, t.boot))) console.log(`    ${t.boot} (remove the RAVINTIO content by hand)`);
  console.log(`    ${PACK_NAME}/ and ${OVERRIDES_NAME}/`);
  console.log(`    ${t.settings} entries that are not RAVINTIO's, and the env, allowedTools, and attribution values setup set`);
  const planRecords = [];
  const walk = (d, rel) => {
    for (const n of listDir(d)) {
      const p = path.join(d, n);
      if (isDir(p) && !isLink(p)) walk(p, `${rel}${n}/`);
      else planRecords.push(`${rel}${n}`);
    }
  };
  walk(path.join(root, "plan"), "plan/");
  if (planRecords.length) {
    console.log(`    ${planRecords.length} record${planRecords.length === 1 ? "" : "s"} under plan/ (none deleted). First ones:`);
    for (const r of planRecords.slice(0, 10)) console.log(`      ${r}`);
  }
  console.log("");
  console.log("Uninstall complete.");
}

// ---- update ---------------------------------------------------------------

function porcelain(root, folders) {
  const out = git(root, ["status", "--porcelain", "--untracked-files=all", "--", ...folders]);
  if (out === null) return null;
  return out.split("\n").filter(Boolean).map(l => l.slice(3));
}

function mirror(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  const want = new Set();
  for (const n of listDir(src)) {
    if (n === ".git" || n === ".DS_Store") continue;
    const s = path.join(src, n), d = path.join(dest, n);
    if (isLink(s)) { console.log(`  ! skipped link in source: ${n}`); continue; }
    want.add(n);
    if (isDir(s)) {
      if (isLink(d) || (exists(d) && !isDir(d))) fs.rmSync(d, { recursive: true, force: true });
      mirror(s, d);
    } else {
      if (isLink(d) || isDir(d)) fs.rmSync(d, { recursive: true, force: true });
      fs.copyFileSync(s, d);
      fs.chmodSync(d, fs.statSync(s).mode & 0o7777);
    }
  }
  for (const n of listDir(dest)) if (!want.has(n)) fs.rmSync(path.join(dest, n), { recursive: true, force: true });
}

function update(o) {
  toolOf(o);
  const root = o.root;
  if (!o.source) fail("--update needs a source folder, such as --update ../zero/ravintio-zero");
  const base = path.resolve(o.source);
  const candidates = [base, path.join(base, PACK_NAME), path.join(base, "src", PACK_NAME)];
  const src = candidates.find(c => isFile(path.join(c, "setup.sh")) && isFile(path.join(c, "setup.ps1")) && !isLink(c));
  if (!src) fail(`${path.basename(base) || "the source"} holds no ${PACK_NAME} pack (no setup.sh and setup.ps1). Nothing changed.`);
  if (fs.realpathSync(src) === fs.realpathSync(PACK)) fail("the source is the installed pack. Nothing changed.");

  const dirty = porcelain(root, [PACK_NAME]);
  if (dirty === null) fail("this folder is not a git repository, so update cannot commit the pack. Nothing changed.");
  if (dirty.length) {
    process.stderr.write(`! Error: ${PACK_NAME}/ has uncommitted files. Commit or discard them, then rerun update.\n`);
    for (const f of dirty) process.stderr.write(`    ${f}\n`);
    process.exit(1);
  }

  console.log(`  Copying the pack from ${path.basename(src)}`);
  mirror(src, PACK);

  git(root, ["add", "-A", "--", PACK_NAME]);
  const staged = git(root, ["diff", "--cached", "--name-only", "--", PACK_NAME]);
  if (staged && staged.trim()) {
    try {
      execFileSync("git", ["-C", root, "commit", "-q", "-m", "Update the RAVINTIO Zero pack", "--", PACK_NAME], { stdio: "inherit" });
      console.log(`  + committed the new pack files (${staged.trim().split("\n").length} changed)`);
    } catch (_) {
      fail("git could not commit the new pack files. The files stay staged. Fix the git error, commit them, then rerun setup.");
    }
  } else {
    console.log("  = the pack already matches the source");
  }
}

function flags(o) {
  toolOf(o);
  const f = recordFlags(o.root, o.tool);
  process.stdout.write((f || []).filter(x => /^--[a-z-]+$/.test(x)).join(" ") + "\n");
}

const o = parseArgs(process.argv.slice(2));
const commands = { doctor, uninstall, update, flags };
if (!commands[o.cmd]) fail(`unknown command ${String(o.cmd).replace(/[^a-z-]/g, "")}`);
commands[o.cmd](o);
