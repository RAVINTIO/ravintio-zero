#!/usr/bin/env node
// initiative-activate.mjs: runs I-B Activate in order after one confirmation.
// Usage: node ravintio-zero/scripts/initiative-activate.mjs [draft-path] [--yes] [--dry-run]
// Runs only git and gh. Never force-pushes. Merges only into initiative/* branches.
// A rerun after a stop resumes at the PR step. Prints the driver and watcher commands.

import { spawnSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

const PREFIX = "I-B Activate:";
const args = process.argv.slice(2);
const yes = args.includes("--yes");
const dryRun = args.includes("--dry-run");
const positional = args.filter((a) => !a.startsWith("--"));
const root = process.cwd();

function block(reason) {
  console.log(`${PREFIX} Blocked: ${reason}`);
  process.exit(1);
}

function run(cmd, cmdArgs) {
  if (cmd !== "git" && cmd !== "gh") throw new Error(`refused command: ${cmd}`);
  if (cmdArgs.some((a) => a === "--force" || a === "-f" || a.startsWith("--force-"))) {
    throw new Error("refused: force flag");
  }
  const r = spawnSync(cmd, cmdArgs, { cwd: root, encoding: "utf8" });
  return { ok: r.status === 0, out: (r.stdout || "").trim(), err: (r.stderr || "").trim() };
}

const git = (...a) => run("git", a);
const gh = (...a) => run("gh", a);

function must(r, what) {
  if (!r.ok) block(`${what} failed${r.err ? `: ${r.err.split("\n")[0]}` : ""}`);
  return r;
}

function fmStatus(text) {
  const m = text.match(/^status:\s*"?([a-z]+)"?/m);
  return m ? m[1] : "";
}

// Find the draft: an explicit path, or the single charted draft in plan/roadmap/.
function findDraft() {
  if (positional.length > 0) {
    let p = path.resolve(root, positional[0]);
    if (fs.existsSync(p) && fs.statSync(p).isFile()) p = path.dirname(p);
    if (!fs.existsSync(path.join(p, "initiative.md"))) block(`no initiative.md at ${positional[0]}`);
    return p;
  }
  const dir = path.join(root, "plan", "roadmap");
  const found = [];
  if (fs.existsSync(dir)) {
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      const f = path.join(dir, e.name, "initiative.md");
      if (e.isDirectory() && fs.existsSync(f) && fmStatus(fs.readFileSync(f, "utf8")) === "charted") {
        found.push(path.join(dir, e.name));
      }
    }
  }
  return found.length === 1 ? found[0] : found.length === 0 ? null : block(`${found.length} charted drafts, pass the draft path`);
}

const currentBranch = git("rev-parse", "--abbrev-ref", "HEAD").out;
const onActivateBranch = currentBranch.match(/^feat\/(\d{7}-.+)-activate$/);

let draftDir = findDraft();
let idSlug;
if (draftDir) {
  idSlug = path.basename(draftDir);
} else if (onActivateBranch) {
  idSlug = onActivateBranch[1];
} else {
  block("no charted draft in plan/roadmap/");
}
if (!/^\d{7}-[a-z0-9][a-z0-9-]*$/.test(idSlug)) block(`bad initiative folder name: ${idSlug}`);

const initBranch = `initiative/${idSlug}`;
const featBranch = `feat/${idSlug}-activate`;
const draftRel = `plan/roadmap/${idSlug}`;
const title = `${idSlug}: activate initiative`;

// Checks. All are read-only.
if (!git("remote", "get-url", "origin").ok) block("no remote named origin");
if (!gh("auth", "status").ok) block("gh access failed");
if (git("status", "--porcelain", "--untracked-files=no").out) block("working tree has uncommitted changes");

const idPrefix = idSlug.slice(0, 7);
const ls = git("ls-remote", "--heads", "origin", `refs/heads/initiative/${idPrefix}-*`);
if (!ls.ok) block(`cannot list branches on origin: ${ls.err.split("\n")[0]}`);
const remoteHasBranch = ls.out.split("\n").some((l) => l.endsWith(`refs/heads/${initBranch}`));
if (ls.out && !remoteHasBranch) block(`an initiative/${idPrefix}-* branch already exists on origin`);

const activeFile = path.join(root, "plan", "current-initiative", "initiative.md");
if (fs.existsSync(activeFile) && !onActivateBranch) {
  if (fmStatus(fs.readFileSync(activeFile, "utf8")) === "active") {
    const t = (fs.readFileSync(activeFile, "utf8").match(/^title:\s*"?(.*?)"?\s*$/m) || [])[1] || "unknown";
    block(`another initiative is already active: ${t}`);
  }
}

const localFeat = git("rev-parse", "--verify", "-q", `refs/heads/${featBranch}`).ok;
let resume = false;
if (remoteHasBranch) {
  if (localFeat || onActivateBranch) {
    resume = true;
  } else {
    const f = git("fetch", "-q", "origin", initBranch);
    const hasDraft = f.ok && git("cat-file", "-e", `FETCH_HEAD:${draftRel}/initiative.md`).ok;
    if (!hasDraft) block(`${initBranch} already exists on origin and holds no draft to activate`);
    resume = true;
  }
}

const plan = [
  resume ? `resume: ${initBranch} is already on origin` : `cut ${initBranch} from main and push it`,
  `on ${featBranch}: write plan/current-initiative/initiative.md with status active, delete ${draftRel}/`,
  `commit and push ${featBranch}`,
  `gh pr create --base ${initBranch} --title "${title}"`,
  "gh pr checks --watch",
  "gh pr merge --squash --delete-branch",
];

console.log(`${PREFIX} Starting: ${resume ? "resuming " : ""}activation of ${idSlug}`);
plan.forEach((s, i) => console.log(`  ${i + 1}. ${s}`));

if (dryRun) {
  console.log(`${PREFIX} Skipped: dry run, nothing changed`);
  process.exit(0);
}

if (!yes) {
  process.stdout.write("Go? [y/N] ");
  const buf = Buffer.alloc(256);
  let n = 0;
  try {
    n = fs.readSync(0, buf, 0, 256, null);
  } catch {
    n = 0;
  }
  if (!/^\s*y(es)?\s*$/i.test(buf.toString("utf8", 0, n))) {
    console.log(`${PREFIX} Skipped: not confirmed`);
    process.exit(0);
  }
}

// Step 1: cut and push the unchanged initiative branch.
if (!resume) {
  must(git("branch", initBranch, "main"), `cutting ${initBranch}`);
  must(git("push", "origin", initBranch), `pushing ${initBranch}`);
}

// Step 2: write the active initiative on the feature branch.
const current = git("rev-parse", "--abbrev-ref", "HEAD").out;
if (current !== featBranch) {
  if (localFeat) must(git("checkout", "-q", featBranch), `checking out ${featBranch}`);
  else must(git("checkout", "-q", "-b", featBranch, `refs/remotes/origin/${initBranch}`), `cutting ${featBranch}`);
}
const draftFile = path.join(root, draftRel, "initiative.md");
if (fs.existsSync(draftFile)) {
  const text = fs
    .readFileSync(draftFile, "utf8")
    .replace(/^status:\s*"?charted"?/m, 'status: "active"')
    .replace(/^(\*\*Status:\*\*)\s*charted/m, "$1 active");
  fs.mkdirSync(path.dirname(activeFile), { recursive: true });
  fs.writeFileSync(activeFile, text);
  must(git("rm", "-r", "-q", "--", draftRel), `deleting ${draftRel}`);
  must(git("add", "--", "plan/current-initiative/initiative.md"), "staging the active initiative");
  must(git("commit", "-q", "-m", title), "committing the activation");
}
must(git("push", "-u", "origin", featBranch), `pushing ${featBranch}`);

// Step 3: open the PR, or reuse the one a stopped run opened.
const listed = gh("pr", "list", "--head", featBranch, "--base", initBranch, "--json", "number", "--jq", ".[0].number");
let prNumber = listed.ok ? listed.out : "";
if (!/^\d+$/.test(prNumber)) {
  const created = must(
    gh("pr", "create", "--base", initBranch, "--head", featBranch, "--title", title, "--body", `Activates initiative ${idSlug}.`),
    "opening the PR",
  );
  prNumber = (created.out.match(/\/pull\/(\d+)/) || [])[1] || "";
  if (!prNumber) block("PR number missing from gh output");
}
console.log(`${PREFIX} PR #${prNumber} open`);

// Step 4: wait for checks, then merge. The merge only targets initiative/*.
if (!gh("pr", "checks", prNumber, "--watch").ok) block(`checks failed on PR #${prNumber}`);
if (!initBranch.startsWith("initiative/")) block("refusing to merge into a non-initiative branch");
must(gh("pr", "merge", prNumber, "--squash", "--delete-branch"), `merging PR #${prNumber}`);

console.log(`${PREFIX} Complete: ${idSlug} merged into ${initBranch}`);
console.log("Start the driver and the watcher as background tasks:");
console.log("  node ravintio-zero/scripts/initiative-run.mjs");
console.log("  node ravintio-zero/scripts/initiative-watch.mjs");
