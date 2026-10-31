---
title: "Hook enforcement"
summary: "What each RAVINTIO enforcement hook does, and which hooks Codex runs."
status: "active"
version: "0.1.0"
---
# Hook enforcement

Read this file when a hook blocks an action. Each block message names it.

## Claude Code

RAVINTIO installs these deterministic enforcement hooks via `setup.sh`:

- **gate-write** (PreToolUse: Write, Edit): Gates every in-project path that is not always permitted. The write needs `plan/current/design.md` AND a declared component match. `plan/current/` also needs `plan/.orchestrator-active`. `plan/` (with `plan/backlog/` and `plan/roadmap/`), `docs/`, and permitted basenames pass. Targets outside the project pass.
- **block-forced-add** (PreToolUse: Bash): Blocks a `git add` that carries `-f`, `--force` or an abbreviation of it, or a short flag group that contains `f`, such as `-fA`. It also blocks `git -C {dir} add -f`. A forced add stages a file that an ignore rule matches, as in initiative 0000238. If a file is ignored on purpose, leave it out. If it must be tracked, add a negation rule to `.gitignore`. The CI check on `git ls-files -ci --exclude-standard` catches any form the hook misses.
- **auto-trigger-orchestrator** (UserPromptSubmit): At the start of every session in a RAVINTIO project (`ravintio-zero/` present and `plan/.orchestrator-active` absent), automatically loads the `ravintio-orchestrator` skill before the first prompt is processed. This is the primary trigger mechanism for Claude Code.
- **check-design** (UserPromptSubmit): Injects active component scope from `design.md` as additional context.
- **check-reply-prefix** (Stop): While a run is active, warns when a reply lacks a valid phase or stage prefix and logs the miss to `plan/.prefix-misses.log`. It never blocks.
- **commit-msg** (git hook): Blocks commits that break `commit-standards.md`. Exit 1 on violation; use `git commit --no-verify` to bypass intentionally.
- **ratchet-check** (PreToolUse: Write, Edit): While a loop is active (a `plan/current/loop-state-*.md` with `status: active`), blocks writes that remove acceptance-criteria or in-scope lines from `plan/current/` artifacts. Strengthening passes; intentional weakening needs a human-written `plan/current/.ratchet-approve` line (single-use). Agents must never write that marker.

Enforcement failures exit 2 and surface a human-readable message. An unexpected error in an advisory hook exits 0, so it never blocks your session.

**Launcher.** Setup wires every Claude Code hook through `.claude/hooks/enforcement/guard-run.mjs`. The command reads `${CLAUDE_PROJECT_DIR}`, so a changed working directory can't break it. Setup also sets `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` to `1` under `env`, so a `cd` lasts only for its own Bash command.

- **Guard mode** runs `gate-write`, `ratchet-check`, `em-dash-guard`, `merge-guard`, and `block-forced-add`. A missing script, a crash, a signal, or any exit other than 0 and 2 becomes exit 2. The message names the script. Claude Code treats exit 1 as non-blocking, so this keeps a broken guard from allowing a call.
- **Advisory mode** runs the other four hooks. A missing script exits 0 and prints one line that names the script, once for each script.

If a block message reads `guard-run: the hook script {name} is missing`, rerun setup.

## Codex

Codex runs fewer RAVINTIO hooks than Claude Code. Setup wires the hook below. You enforce every other rule yourself.

Active hooks, wired in `.codex/hooks.json`:

- **merge-guard** (PreToolUse: Bash): Blocks any pull request merge command unless it squash-merges your own feature PR into an `initiative/*` base. Merging into `main` is human-only.

Fallback hooks, which Codex does not run for RAVINTIO. Follow each rule as an instruction:

- **gate-write**: Before you write any file, confirm that `plan/current/design.md` exists and that the path belongs to a declared component. `plan/current/` also needs `plan/.orchestrator-active`. `plan/`, `docs/`, and always-permitted basenames pass. Never write application code without a confirmed design.
- **ratchet-check**: While a loop is active (a `plan/current/loop-state-*.md` with `status: active`), never remove acceptance-criteria or in-scope lines from `plan/current/` artifacts. Never write `plan/current/.ratchet-approve`.
- **em-dash-guard**: Write no em dash (U+2014) in RAVINTIO prose paths.
- **auto-trigger-orchestrator**: At the start of every session in a RAVINTIO project (`ravintio-zero/` present and `plan/.orchestrator-active` absent), load the `ravintio-orchestrator` skill before you process the first prompt.
- **check-orchestrator-presence**: In strict mode (`plan/.orchestrator-strict` present), load the orchestrator and write your session ID to `plan/.orchestrator-ack` before you act.
- **check-design**: At the start of each prompt, read the active component scope in `plan/current/design.md`.
- **check-reply-prefix**: Begin every reply in an active run with a valid prefix, as the reply conventions in the boot file describe.
- **commit-msg** (git hook): Blocks commits that break `commit-standards.md`. Exit 1 on violation. Use `git commit --no-verify` to bypass intentionally.

Project hooks run only after a person trusts them. Run `/hooks` in Codex to review and trust the RAVINTIO hook. Until a person trusts the hook, nothing blocks a merge, including in `codex exec`. Never run a pull request merge command against `main` yourself.
