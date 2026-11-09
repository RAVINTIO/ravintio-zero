#!/usr/bin/env node
// Generates ravintio-zero/pack-facts.json, the one file that lists the pack's
// user-facing facts (0000382, backlog 0000286).
//
//   node pack-facts.mjs           write the file
//   node pack-facts.mjs --check   exit 1 when the committed file differs from a fresh run
//
// The script reads the pack's own sources. It runs setup.sh in a scratch git
// repository and reads what setup wrote, so the hook list comes from the real
// install and not from a copy of it.

import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const PACK = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const OUT = path.join(PACK, "pack-facts.json");

// What each hook module does. A hook with no row here fails the run, so a new
// hook cannot ship without a fact.
const HOOK_FACTS = {
  "gate-write": "Blocks a write to a plan artefact or a source path until the orchestrator sentinel and a confirmed design exist.",
  "ratchet-check": "Blocks a write that weakens loop criteria or scope while a loop is active.",
  "em-dash-guard": "Blocks an em dash in scoped prose paths.",
  "merge-guard": "Blocks a merge into main. The agent may squash-merge only into initiative branches.",
  "block-forced-add": "Blocks git add with a force flag, and git add with a variable path.",
  "auto-trigger-orchestrator": "Tells the model to load the orchestrator skill once per session, with resume findings and an install check.",
  "check-orchestrator-presence": "Warns once per session when the orchestrator is not loaded. In strict mode it asks for an acknowledgement first.",
  "check-design": "Adds the confirmed design scope to the context of each prompt.",
  "check-reply-prefix": "Warns when a reply lacks the phase prefix.",
  "check-reply-writing": "Warns when a reply breaks the sentence-length or blocklist rule of the writing standard.",
};

const GIT_HOOK_FACTS = {
  "pre-commit": { blocks: false, does: "Prints an advisory when source changes land without plan, docs, or component manifest changes." },
  "pre-push": { blocks: true, does: "Blocks a push when the branch diff lacks plan, docs, or component manifest changes." },
  "commit-msg": { blocks: true, does: "Rejects AI attribution, affirmatory language, and subjects over 72 characters." },
};

// What setup creates or changes in the repository. The doctor and uninstall
// commands in install-lifecycle.mjs cover the same list.
const SETUP_WRITES = [
  { path: "git config core.hooksPath", effect: "Set to ravintio-zero/hooks." },
  { path: ".claude/skills/", effect: "Pack skills and capability skills, with a .ravintio-manifest." },
  { path: ".claude/commands/", effect: "Pack commands, with a .ravintio-manifest." },
  { path: ".claude/hooks/enforcement/", effect: "Copies of the pack's enforcement hook scripts." },
  { path: ".claude/settings.json", effect: "Wires the hooks, sets env, allowedTools, and attribution." },
  { path: ".claude/.ravintio-setup-flags", effect: "Local record of the last setup run. Git ignores it." },
  { path: "CLAUDE.md", effect: "Regenerated from the pack template. A first install moves the developer's content to ravintio-overrides/instructions/." },
  { path: ".github/workflows/ravintio.yml", effect: "Created when absent." },
  { path: ".gitattributes", effect: "Created when absent." },
  { path: ".gitignore", effect: "Created when absent." },
  { path: "src/", effect: "Created with a README when absent." },
  { path: "plan/", effect: "Created with README.md, feature-structure.md, current/, and state/{tool}.md." },
  { path: "plan/.orchestrator-strict", effect: "Written with --strict-orchestrator and removed with --no-strict-orchestrator." },
];

function listDir(p) { try { return fs.readdirSync(p); } catch (_) { return []; } }

function frontmatterDescription(file) {
  const text = fs.readFileSync(file, "utf8");
  const m = /^---\n([\s\S]*?)\n---/.exec(text);
  const d = m && /^description:\s*(.*)$/m.exec(m[1]);
  return d ? d[1].trim().replace(/^["']|["']$/g, "") : "";
}

function parseHelp(helpText) {
  const flags = [];
  let cur = null;
  for (const line of helpText.split("\n")) {
    const m = /^  (-[^\s].*?)\s{2,}(\S.*)$/.exec(line);
    if (m) {
      cur = { flag: m[1].trim(), effect: m[2].trim() };
      flags.push(cur);
    } else if (cur && /^\s{20,}\S/.test(line)) {
      cur.effect += " " + line.trim();
    } else if (!/^\s{20,}\S/.test(line)) {
      cur = null;
    }
  }
  return flags;
}

function phases() {
  const text = fs.readFileSync(path.join(PACK, "templates", "standard-boot.md"), "utf8");
  const rows = [...text.matchAll(/^\| `([^`]+?):` \| ([^|]+?) \|$/gm)];
  const all = rows.map(r => ({ prefix: r[1], use: r[2].trim() }));
  return {
    phases: all.filter(r => /^P\d /.test(r.prefix)),
    stages: all.filter(r => /^I-[A-E] /.test(r.prefix)),
  };
}

function scratchInstall() {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ravintio-facts-"));
  try {
    fs.cpSync(PACK, path.join(tmp, "ravintio-zero"), { recursive: true, filter: s => !s.includes(`${path.sep}.git${path.sep}`) });
    const run = (cmd, args, extra = {}) => execFileSync(cmd, args, { cwd: tmp, stdio: "pipe", encoding: "utf8", ...extra });
    run("git", ["init", "-q", "."]);
    run("git", ["add", "-A", "."]);
    run("git", ["-c", "user.email=facts@example.com", "-c", "user.name=facts", "-c", "commit.gpgsign=false", "commit", "-q", "-m", "pack"]);
    run("bash", ["ravintio-zero/setup.sh", "claude-code"], { env: { ...process.env, GIT_CEILING_DIRECTORIES: path.dirname(tmp) } });
    const settings = JSON.parse(fs.readFileSync(path.join(tmp, ".claude", "settings.json"), "utf8"));
    const hooks = [];
    for (const [event, entries] of Object.entries(settings.hooks || {})) {
      for (const e of entries) {
        for (const h of e.hooks || []) {
          const m = /guard-run\.mjs"?\s+(guard|advisory)\s+([a-z-]+)\.mjs/.exec(h.command || "");
          if (!m) continue;
          hooks.push({ module: m[2], event, matcher: e.matcher || "", mode: m[1] });
        }
      }
    }
    const skills = listDir(path.join(tmp, ".claude", "skills")).filter(n => fs.existsSync(path.join(tmp, ".claude", "skills", n, "SKILL.md"))).sort();
    const commands = listDir(path.join(tmp, ".claude", "commands")).filter(n => n.endsWith(".md")).sort();
    return { hooks, skills, commands };
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
  }
}

function build() {
  const help = execFileSync("bash", [path.join(PACK, "setup.sh"), "--help"], { encoding: "utf8" });
  const flags = parseHelp(help);
  const install = scratchInstall();

  const hooks = install.hooks
    .map(h => {
      if (!HOOK_FACTS[h.module]) throw new Error(`hook ${h.module} has no entry in HOOK_FACTS`);
      return { ...h, blocks: h.mode === "guard", does: HOOK_FACTS[h.module] };
    })
    .sort((a, b) => (a.event + a.matcher + a.module).localeCompare(b.event + b.matcher + b.module));

  const gitHooks = listDir(path.join(PACK, "hooks")).filter(n => GIT_HOOK_FACTS[n]).sort()
    .map(n => ({ name: n, ...GIT_HOOK_FACTS[n] }));

  const skills = install.skills.map(name => {
    const src = path.join(PACK, "skills", name, "SKILL.md");
    return { name, description: fs.existsSync(src) ? frontmatterDescription(src) : "" };
  });

  const { phases: ph, stages } = phases();
  return {
    generatedBy: "ravintio-zero/scripts/pack-facts.mjs",
    note: "Generated file. Run node ravintio-zero/scripts/pack-facts.mjs to refresh it. CI fails when it is stale.",
    tools: ["claude-code", "codex"],
    setupFlags: flags,
    setupWrites: SETUP_WRITES,
    hooks,
    gitHooks,
    commands: install.commands,
    skills,
    phases: ph,
    initiativeStages: stages,
  };
}

const check = process.argv.includes("--check");
const fresh = JSON.stringify(build(), null, 2) + "\n";
if (check) {
  const current = fs.existsSync(OUT) ? fs.readFileSync(OUT, "utf8") : "";
  if (current !== fresh) {
    process.stderr.write("! Error: ravintio-zero/pack-facts.json is stale. Run node ravintio-zero/scripts/pack-facts.mjs and commit the file.\n");
    process.exit(1);
  }
  console.log("pack-facts: current");
} else {
  fs.writeFileSync(OUT, fresh);
  console.log("pack-facts: wrote ravintio-zero/pack-facts.json");
}
