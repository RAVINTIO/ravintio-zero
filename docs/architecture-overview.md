# Architecture Overview

Last updated: 0000327-squash-before-main

## What this repo is

This repo is RAVINTIO Zero itself. It holds one component, `ravintio-zero`, which other projects install into their working tree.

RAVINTIO Zero is not a service. It has no runtime of its own. It ships these things:

1. **Skills.** Markdown instructions that Claude Code auto-discovers from `.claude/skills/`. Thirteen skills drive the five-phase pipeline and its support work.
2. **Hooks.** Node `.mjs` scripts that Claude Code invokes synchronously at tool-call boundaries. Enforcement hooks block or annotate. Git hooks guard commits and pushes. No hook makes an outbound network call.
3. **Standards, templates, and schemas.** The reference material that skills read from `ravintio-zero/` by full path.
4. **Setup scripts.** `setup.sh` and `setup.ps1` copy the above into a target project and wire `.claude/settings.json`.

The repo runs its own pipeline on the `ravintio-zero/` it ships. Git reads its hooks from `ravintio-zero/hooks` through `core.hooksPath`.

---

## Pipeline

The pipeline runs five phases, numbered P0 to P4. There is one route: every change is a feature change, and a small change is a small run. Each agent message starts with its phase prefix, then a status and a one-liner, as in `P1 Plan: Complete: 4 requirements, 2 ADRs`.

| Phase | Prefix | Owning skill |
|-------|--------|--------------|
| Discovery | `P0 Discovery:` | ravintio-orchestrator |
| Plan | `P1 Plan:` | ravintio-plan |
| Implement | `P2 Implement:` | ravintio-implement |
| Validate and accept | `P3 Validate:` | ravintio-validate-and-accept |
| Ship | `P4 Ship:` | ravintio-ship |

### Story map and Gherkin criteria

P1 starts with a story mapping pass. It writes `plan/current/story-map.md` from `templates/story-map.template.md`, with the user's activities along the top and the stories under each one. A gap that the brief states or implies becomes a new story and a requirement. Any other gap goes to the out-of-scope list.

Each acceptance criterion is one checkbox line, `- [ ] AC-{n}: {name}`, with indented `Given`, `When`, and `Then` bullets under it. `And` and `But` continue the step above. The limit of three criteria counts checkbox lines.

`scripts/consistency-check.mjs` reports a criterion that lacks a step or holds steps out of order, with the file and criterion. It also reports a plan that has requirements but no `story-map.md`, and a story map that misses a requirement's story. Every execution plan holds a `## Concurrency plan` table of units, dependencies, write targets, and batches. Check 8 reports a plan that lacks the section, a unit alone in its batch with no reason, two units in one batch that share a write target, and a dependency on a unit in the same or a later batch. The implement phase dispatches by those batches. Before the concurrency plan, the plan skill's Test impact scan greps `ravintio-zero/tests/` for tests that hold a skill count, a skill-text budget, a size cap or a backlog entry id. The execution plan lists each match in a `## Test impact` table (0000246 ADR-001). `ratchet-check` guards each step line, so a loop edit that removes or rewords one exits 2. Both programs cut an echoed line to 200 characters and append ` …[truncated]` if they cut it, so a long line never floods the agent's context. Ship Step 3 runs `scripts/build-log-check.mjs` on the build log before Archive. It names each phase with a blank `Start`, `End`, or `Wall clock`, a `Wall clock` more than one minute from `End` minus `Start`, or a missing block that has no `Skipped: P{n}` line. It also fails a `Total wall clock` that is blank or reads `not recorded` (0000248 ADR-001). The validate-and-accept skill tells the agent to run `command -v {program}` and then search the common install folders before a report says a program is missing. It also gives a claim that only documentation backs the outcome `unverified (docs only)`, which never counts as `verified`. The acceptance evidence lists the search commands and each unverified claim by name (0000249).

### Resume findings

`hooks/enforcement/auto-trigger-orchestrator.mjs` runs `scripts/resume-detect.mjs` with a 2 second timeout on the prompt where it injects the load instruction. The script prints one fixed line per signal for the 12 Resume Detection checks, in check order, and `no resume signals` when it finds none. It prints no repo text. An id that fails its pattern prints as `unreadable`. If the script is missing, exits non-zero, or passes the timeout, the hook injects `resume detection did not run` and the skill runs every check. A step session and an initiative session get the same findings, and each names its own skill. `skills/ravintio-orchestrator/references/orchestrator-resume-detection.md` holds the 12 checks in full, and the Resume Detection rule in the orchestrator `SKILL.md` points there.

The load instruction fires once per session. The hook writes the `session_id` to the ignored file `plan/.orchestrator-loaded` when it injects the instruction, and stays silent while the file holds the current id. Without a `session_id` it injects every time. The advisory banner of `check-orchestrator-presence.mjs` follows the same rule.

Migration findings come from the ledger `plan/state/migrations.md`, which sits outside the pack. Each row holds a migration id, a result (`done` or `not applicable`), and the pack version. A `done` row gives no finding. A `not applicable` row gives none at the same pack version, unless a `**Detect:**` line in the migration file shows its condition is now true. The migrator appends rows and edits nothing inside `ravintio-zero/`. Migration 0006 copies the pack's `_done/` records into the ledger.

Each backlog entry carries `priority` (`high`, `medium`, or `low`) and `theme` in its frontmatter. A missing field reads as `medium` and `unsorted`. `scripts/backlog-index.mjs` writes `plan/backlog/index.md`, grouped by theme and ordered by priority. With `--check` it exits 1 when the committed index differs from a fresh run, and CI runs that check. With `--review` it lists entries older than `backlogReviewDays` in `product.yml` (default 5), counted from **Date filed**. Discovery Start Actions step 10 runs the review and offers entries in index order. Migration 0007 sets the defaults on existing entries.

`check-reply-prefix.mjs` checks `last_assistant_message` from the Stop payload. If the field is absent, it reads the last assistant message that follows the last user prompt and holds no `tool_use` block, and rereads the transcript up to 4 times. If it finds no final reply, it stays silent.

### Run modes

At the end of P0, the orchestrator asks how to run P1 to P4. It writes the answer, `gated` or `autonomous`, to `plan/.run-mode` and logs it. No other value is valid.

- **Gated.** The run stops for the human at the P1, P2, P3, and P4 gates. The P4 gate comes before the PR.
- **Autonomous.** The run stops at none of those gates. P3 writes its evidence to `plan/current/acceptance-evidence.md`. P4 copies it into the PR body and ends with `P4 Ship: Complete: PR #{n} ready for your review`.

On resume, a missing or unknown `plan/.run-mode` makes the orchestrator ask the question again and name the value it found.

**Run speed.** After the run mode, the orchestrator asks for a run speed and writes `standard` or `fast` to `plan/.run-speed`. A missing or unknown value counts as `standard`. An initiative step takes the initiative's `**Speed:**` field.

- **Standard.** Each phase applies its own parallelism rules.
- **Fast.** Each phase skill dispatches the units in its `### Fast batch` list, each batch in one message. The rules sit in `## Fast batches` of the dispatch standard. A subagent in a batch never runs `git stash`, `git checkout`, or `git reset`, because a stash takes the uncommitted work of every other subagent (0000247). In an active initiative, a step stages by explicit path and leaves queued backlog entries untracked.

Phases run in order at either speed, and the gates and exception stops stay the same. Each build-log phase block records `End` and `Wall clock`, and the build report lists them with the agent count. Ship Step 8 deletes `plan/.run-speed` with the other sentinels.

**Exception stops.** Both modes stop and print `{prefix} Blocked: {action needed}` in these cases:

- A requirement or check still fails after 5 attempts.
- P2 needs a schema change. In an initiative step, a change that matches a chart-approved additive row does not stop.
- The P3 security review finds an unmitigated critical or high issue.
- A push or `gh pr create` fails.
- A possible credential appears in a file the run will commit, or in the PR body.
- P1 or P2 adds a library or service that is not on the approved dependency list. The list is `design.md` "Approved dependencies" in a gated or autonomous run, and `initiative.md` "## Dependencies" in an initiative step.

Each stop adds a `Blocked:` line to the build log. A resumed run does not pass it until a `Resolved:` line follows.

No mode merges a PR or commits to `main`. The human merges every PR.

**Context size.** At each gate in a gated run, the orchestrator reports the context size. Past about 150,000 tokens, it recommends `/clear`.

**Ship order.** P4 creates no tag. Step 8 reads the run mode, then clears the pipeline sentinels in a commit. Step 9 checks the PR body with `scripts/check-attribution.mjs`, pushes the branch, and raises the PR. Step 10 is the final gate. So the sentinels never reach `main` through the PR.

**Orchestrator references.** The orchestrator `SKILL.md` is 9,000 bytes or fewer. It keeps the Hard Limits, the prefix table, a short Resume Detection rule, the Pack Index, and Context Hygiene. Fourteen files under `skills/ravintio-orchestrator/references/` hold the sections that apply at one moment of a run. They cover adoption modes, discovery coaching, discovery records, mid-pipeline changes, run speed, scope lock, session commands, the skills catalogue, resume detection, P0 coaching, the fresh P0 start, the P0 gate, phase invocation, and exception stops. Each moved section keeps its lines word for word. The initiative stage prefix block sits in `ravintio-zero/standards/roadmap-standards.md`. The Pack Index names one trigger for each file and one rule for template reads. A line-preservation test fails if a moved line is missing.

**Model tiers.** Every Agent call passes `model`, set to `sonnet` or `haiku`. The three TDD skills set `model: haiku`. A haiku unit that fails twice retries on sonnet. A WebFetch of a full reference page goes through a sonnet or haiku subagent that returns an extract.

### Release sizing

Discovery sizes each release against a budget. The optional `releaseSize` field in `product.yml` sets it to `small`, `medium`, or `large`, and the default is `medium`. Discovery gives each candidate requirement a size class from the files it touches, then recommends a fill up to the budget.

**Ids.** Backlog, feature, and initiative ids come from the counter file `plan/backlog/.next-id`. `scripts/reserve-id.mjs [qty]` takes an exclusive lock beside the file, reads the next free id, writes the id plus `qty`, and prints the block, one id per line. A held lock, a malformed or symlinked counter, or a bad quantity exits 1 and leaves the file unchanged. `--init` creates a missing counter from the highest id in the plan folders, once. `--commit` then commits the counter file alone with `git commit -- {counter}`, so a session on another branch sees the reservation (0000247 ADR-001). A failed commit exits 1 and keeps the new counter value. A copied entry reserves a local id and names its source id. If two branches reserve the same ids, git shows a conflict on `.next-id`. Keep the higher value and renumber the entries on the branch that merges second.

**Park.** When the human says "park", the orchestrator shelves the feature on its branch. It writes `plan/current/park.md`, pushes the branch, and raises a `chore/park-{feature-id}` PR. That PR files a backlog entry with status `parked`. The working tree then returns to `main`. The git and `gh` steps live in the orchestrator's `scripts/park.mjs`. If a local add or commit fails on the chore branch, park unstages and deletes the entry, then returns to the feature branch. Park refuses an `--entry` that is the target path, so that cleanup never deletes the only copy. Park also refuses any symlink in the entry path. It checks each part with `lstat` and the real path against the real `plan/backlog/`, before it creates, writes, or removes anything. At a later discovery, backlog pickup offers resume or discard for a parked entry. Park and pickup never merge a PR, never commit to `main`, and never force-push.

### Workflow governance

The pipeline measures its own workflow as well as the product. Phase skills write four fixed marker lines to the build log: `Rework:`, `Blocked:`, `Requirement change:`, and `Gate revised:`. At ship, `scripts/workflow-metrics.mjs` counts them in the archived build log and loop-state files. It compares each count against a threshold in `standards/workflow-governance-standards.md`.

Ship adds the resulting `## Workflow governance` section to `build-report.md` and the PR description. A breach shows in both places and never stops ship. If the script fails, ship writes `Workflow governance: not measured` with the reason.

### Initiatives

An initiative is a chain of feature steps that the human approves once. The standard `ravintio-zero/standards/roadmap-standards.md` holds the detail, and the orchestrator and ship skills point to it. Five stage prefixes sit beside the five phases: `I-A Chart:`, `I-B Activate:`, `I-C Run:`, `I-D Advance:`, and `I-E Delivery:`. They are stage letters, not phase numbers. The pipeline keeps exactly five phases.

- **Storage.** A draft lives in `plan/roadmap/{id}-{slug}/initiative.md` on any branch. The one active initiative lives in `plan/current-initiative/initiative.md` on the branch `initiative/{id}-{slug}`. Initiative ids share the backlog sequence.
- **Chart and activate.** I-A Chart runs on `main`, checks that each entry is clear enough to draft from, collects the approved dependency list, and ends with the human's single approval. That approval covers each step's predicted schema change, listed in the initiative's `## Schema changes` table. I-B Activate cuts the initiative branch, writes the active initiative, and offers the driver. One initiative is active per working tree. Chart also runs a guard check on each entry. If an entry widens `merge-guard`, `gate-write`, `ratchet-check`, or another fail-closed hook, chart names the guard and asks for a separate approval. Chart lists each confirmation that a step's skills ask for and records the exact command as a `Confirmation:` row in `## Decisions`, or plans a human stop. The `## P1 skips` table says whether each step may skip P1. A step with no `yes` row stops with `I-C Run: Blocked:` if it would skip P1 (0000252).
- **Run.** Each step runs P0 to P4 in `autonomous` mode on a feature branch cut from the initiative branch. P0 builds the brief from the step's backlog entries and self-confirms the design and scope lock, marked `[source: draft-accepted (roadmap)]`.
- **Watch.** The driver starts each step with `--output-format stream-json --verbose`, so the step log holds one JSON event per line. `scripts/initiative-watch.mjs` reads new bytes of the current step log every 10 seconds. It prints one `I-C Run: activity:` line per tool call, subagent start, and assistant text, each at 200 characters or fewer, and never prints tool results. It reports a stale log once per stale state, reports a branch switch in one line, and reads the lock state on each heartbeat. The initiative skill relays each line to the human.
- **Advance.** At P4, the agent raises the step PR against the initiative branch and waits for green CI. It squash-merges the PR, fetches, and tags the squash commit. Outside an initiative, the CI `release-tag` job tags the merge commit after the human merges.
- **Delivery.** I-E Delivery archives the initiative and raises one PR to `main` that asks for a merge commit. The human merges it.
- **History checks.** `scripts/check-initiative-history.mjs` lists the first-parent commits of an initiative branch and fails on any subject that breaks `{7-digit id}-{slug}: {summary} (#{n})`. I-E Delivery runs it before the PR, lists each failing commit in the PR body, and stops. The title and the first body line ask for a merge commit. CI runs it as the `initiative-history` job on a PR from `initiative/*` to `main`, and CI runs the suite on each push to `initiative/**`. The `main-merge-check` job runs `scripts/check-main-merge.mjs` on each push to `main` and fails when an initiative PR landed as a one-parent commit. Both scripts read git only and keep no state. `docs/main-ruleset.md` in the pack names the ruleset that allows only the merge commit method on `main`, which the human applies (0000319 ADR-001).
- **Coordinator PRs.** Nothing commits directly on an initiative branch. Activation, queued backlog entries, scope edits, and the I-E Delivery archive and retrospective each arrive as a titled PR (`{id}-{slug}: {summary} (#{n})`). The coordinator raises it only while the driver is stopped, runs the full suite first, and squash-merges it after green CI. `merge-guard` is unchanged. It checks only the PR base. Ship sets the changelog `**PR:**` field and pushes it before the squash (0000318 ADR-001).
- **PRs into main.** Only `initiative/*`, `chore/*`, and `hotfix/*` branches may target `main`. Before the agent asks for a merge, a `chore/*` or `hotfix/*` branch holds one commit on top of `origin/main`. The agent squashes a `chore/*` branch in place and pushes with `git push --force-with-lease`. For a `hotfix/*` branch it raises a replacement PR and never force-pushes. `scripts/check-pr-into-main.mjs` runs in the CI job `squash-before-main` and fails a PR that breaks the rule. It ignores `initiative/*`.
- **Driver.** `ravintio-zero/scripts/initiative-run.mjs` runs each step as its own `claude -p` session. A lock file at `plan/.initiative-runner.lock` stops a second driver. The driver stops on a `Blocked:` line, a stalled `position`, or a failed `claude` call, and a restart resumes the same step. It passes `--model` (default `sonnet`) and an optional `--max-turns` to each child. A capped step that exits non-zero stops with `I-C Run: Blocked:`. Each step writes `plan/.initiative-logs/step-{position}.log`. If that log exists when the step starts, the driver renames it to `step-{position}.attempt-{k}.log` first, and a stop line names the kept attempts after `Earlier:` (0000251). The driver appends `work.kind`, `ravintio.initiative`, and `ravintio.step` labels to the child's `OTEL_RESOURCE_ATTRIBUTES`. The label encoder is `scripts/initiative-labels.mjs`. After a merged step, the driver compares the initiative branch ref before and after the step. If the step changed `initiative-run.mjs`, `initiative-watch.mjs`, or the initiative skill, the driver prints `I-D Advance: Restart:` with the changed files, releases the lock, and exits 1. The initiative skill then starts a new driver and watcher without asking (0000250). If the step changed a file under `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, or `ravintio-zero/setup/`, the installed copies in `.claude/` are stale. The driver then prints `I-D Advance: Setup:`, or one `I-D Advance: Restart: Setup:` line when a restart file also changed, releases the lock, and exits 1. The initiative skill reruns the setup command that a `Confirmation:` row approves, checks that every hook runs, and starts a new driver (0000313). A repo instruction that the human asks for mid-run goes into the scope of the current or next pending step in `initiative.md`. The initiative session never writes the override itself, so `gate-write` stays as it is. A step session never moves, renames, or deletes the driver files `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, or `plan/.initiative-queue/`, and the phase guard in the test suite skips `plan/.initiative-logs/` (0000314).
- **Merge guard.** The `merge-guard` hook blocks any `gh pr merge` unless the command uses `--squash` and the PR base starts with `initiative/`. It reads the base with `gh pr view` and blocks when it cannot read one. Merging into `main` stays human-only. A command that names a merge in text, such as a heredoc line, also blocks. The message says so and tells the agent to write files with the Write tool. The ship skill gives the merge as one plain line, `gh pr merge --squash --delete-branch {n}`. `{n}` is the literal PR number, and the line takes no command substitution, variables, or pipes, so the guard can confirm the squash (0000248).

The implement phase dispatches a TDD trio per requirement: ravintio-test-writer, ravintio-implementer, and ravintio-refactor. After GREEN and refactor, an improvement loop of up to 2 cycles per requirement runs a fresh-context reviewer and applies its finding through ravintio-refactor. Each cycle writes an `Improve:` marker to the build log. Eight support skills complete the set of sixteen: ravintio-initiative, ravintio-loop-runner, ravintio-optimise-agent, ravintio-migrator, ravintio-refresh-setup, ravintio-file-backlog, ravintio-postmortem, and ravintio-retrospective. After a `Resolved:` line, the orchestrator runs ravintio-postmortem, which writes a blameless record to `plan/postmortems/`. Ship runs ravintio-retrospective after the build report, and I-E Delivery runs it before the initiative PR. Both write to `plan/retrospectives/`, which P0 discovery and I-A Chart read. In the human's session, ravintio-initiative charts, activates, watches, and delivers an initiative. It starts the driver and the read-only watch script, and it never resumes a step. The orchestrator runs each step in its own session.

---

## Install flow

Setup targets Claude Code and Codex. It copies skills into the tool folder, prunes retired skills, writes the boot file, wires the hooks, and wires the git hooks. The Claude Code flow follows.

```
ravintio-zero/          setup.sh claude-code          target project
├── skills/          ──────────────────────────────────▶   .claude/skills/
├── templates/       ── stays in place, read by full path
├── standards/       ── stays in place, read by full path
├── workflows/       ──────────────────────────────────▶   .claude/commands/
├── hooks/enforcement/ ────────── always ──────────────▶   .claude/hooks/enforcement/
└── templates/standard-boot.md ───────────────────────▶   CLAUDE.md
```

Setup installs only each skill's own folder. Skills read templates, standards, and schemas from the one copy in `ravintio-zero/`, named by full path, such as `ravintio-zero/templates/requirement.template.md` (0000171 ADR-004). A suite fails when a skill names a pack file by a short path or names one that does not exist. A rerun removes bundled files that an older install left.

For Codex, `setup.sh codex` and `setup.ps1 codex` install skills in `.agents/skills/`, write `AGENTS.md` from `templates/codex-boot.md`, and wire only `merge-guard` in `.codex/hooks.json`. The Codex docs confirm its `Bash` hook contract. They don't state the `apply_patch` input or the prompt hook context, so the other rules stay instructions in `AGENTS.md` (0000207 ADR-002). Setup prints the active and fallback hooks.

Boot files are disposable build outputs. Every run regenerates `CLAUDE.md` from the template, then re-appends the contents of `ravintio-overrides/instructions/` between sentinel markers. Durable local customisation lives in the overrides directory, never in the boot file. An override with a `target:` field goes to that installed skill instead of the boot file (0000245 ADR-001). The hook rules live in `standards/hook-enforcement.md` (0000245 ADR-002).

---

## Setup-config record

`setup.sh` and `setup.ps1` write the tracked record of active setup flags to `plan/state/{tool}.md`, creating the folder when it is absent. The record and the gitignored flags marker hold `tool`, `flags`, and `writtenAt`. The `ravintio-refresh-setup` skill reads and validates that record before falling back to the gitignored marker and hook inference.

---

## Enforcement model

Enforcement is deterministic where it can be, and instructional where it cannot.

**Deterministic.** A hook exits 2 with a human-readable message and Claude Code blocks the tool call. `gate-write`, `em-dash-guard`, `ratchet-check`, and `merge-guard` write the reason to stderr and stdout, so the agent sees why the call stopped. `gate-write` gates this project only. It passes a target whose real path lies outside the project's real root, and resolves symlinks first. So a link inside the project that points outside counts as outside. For an in-project target, it blocks a write that has no confirmed design or no matching declared component. `plan/`, `docs/`, and a few root files always pass. `ratchet-check` blocks weakening edits to an active loop's artifacts. `em-dash-guard` rejects U+2014 in scoped prose paths. `merge-guard` blocks a `gh pr merge` that is not a squash into a `initiative/*` branch.

**Instructional.** Skills tell the agent what to do. The orchestrator's hard limits, the one-question-at-a-time rule, and the phase gates all rely on the agent following its instructions.

Every hook fails open on an unexpected error. Exit 0 with no output means the tool call proceeds. That is deliberate: a broken hook must never stop a session.

---

## Upgrade cleanup

Setup no longer removes legacy telemetry wiring. A consumer that last ran a setup from before 0000033 removes four items by hand:

- the `mcp__structured-telemetry-mcp__emit_event` matcher entries in `.claude/settings.json`
- `.claude/telemetry-enabled`
- `plan/.telemetry-failures/`
- `plan/.telemetry-receipts/`

Setup still prunes retired hooks. See Retired hooks under Re-run safety.

**Rename upgrade.** Version 1.0.0 renamed the pack, the overrides folder, the skills, and the marker files. If setup finds the earlier pack or overrides folder in the project root, it stops before it installs anything. It names the folder and the migration helper to run. Each run also removes the two earlier marker files when present, and skips a symlink. Skill pruning removes the earlier skill folders.

Migration 0004 and its helpers, `migrations/migrate-ravintio-rename.sh` and `.ps1`, do the upgrade. They move the overrides folder and the workflow file. Inside the workflow they rewrite the pack paths and the pack's own variables, and leave other names such as secrets. They remove the earlier markers. They never delete the earlier pack folder. They stop git tracking it and move it to `.ravintio-backup/`, which `.git/info/exclude` hides. The human deletes the backup after checking it. A conflict, an earlier backup, or a symlink at a moved path stops the helper before it moves anything. A symlinked parent folder skips only the step that writes through it, with a warning. A rerun changes nothing. After a run that changes the project, the helper moves 0004 to `migrations/_done/`.

A migration can declare an `Applies when:` condition. The orchestrator and `ravintio-migrator` skip a migration whose condition is false and leave it pending. So 0004 ships pending, and never runs in this repo.

---

## Re-run safety

Setup is safe to re-run on a project that an older release installed.

**Retired flags.** Setup accepts four flags that earlier releases removed:

- `--structured-telemetry-mcp`
- `--backend-url`
- `--context-mode-mcp`
- `--include-full-skill-library`

Each exits 1 during argument parsing, before setup changes anything. The error names the flag, says that it was removed and does nothing, and tells the user to remove it. Setup never prints or stores a `--backend-url` value, in either the spaced or the `=` form. Any other unknown flag also exits 1, and its error shows the flag name only. Matching is exact and case-sensitive in both scripts.

Setup checks the tool straight after argument parsing, ahead of the old-folder check. An unknown tool exits 1 and leaves the repo unchanged. A missing tool prints the usage text and exits 0, also with no change. The `ravintio-refresh-setup` skill names a retired flag that a record or marker holds, and leaves it out of the command it proposes.

`setup.ps1` never prints a tool name that isn't a plain name.

**Retired hooks.** Both scripts prune a hook only if its name is on the retired list, which `setup.sh` keeps as `RETIRED_HOOK_NAMES` and `setup.ps1` as `$RetiredHookNames`. Pruning deletes the installed hook file. The hook install step also drops each `settings.json` entry that runs a retired hook, on every event. A hook that is not on the list stays.

**Write failures.** One catch around the shared `writeSettings` prints a fixed line with the relative path and exits 1. It covers the hook install and the allowed-tools write, and `setup.ps1` prints the same line.

**Atomic settings writes.** Every `settings.json` write goes to `settings.json.ravintio-tmp` in the same folder first, then replaces the target. So `settings.json` is always the old file or the new one. Setup removes a leftover temporary file before it writes, and creates the new one exclusively, so it never follows a planted link. The new file keeps the original's mode, or its ACL on Windows. Setup leaves a read-only `settings.json` unchanged. `setup.sh` writes a symlinked `settings.json` through to its real file. Other files setup writes, such as the boot file, are rewritten whole on each run.

**Leftover temporary file.** Each run removes a leftover `settings.json.ravintio-tmp` before its first settings write, even when `node` is missing. It removes a file or a link, never a folder, and never follows a link.

**Hooks run from the project root.** Both scripts set `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` to `1` under `env` in `.claude/settings.json` and keep every other `env` entry. They wire each Claude Code hook as `node "${CLAUDE_PROJECT_DIR}/.claude/hooks/enforcement/guard-run.mjs" {guard|advisory} {hook}.mjs`. Codex gets the absolute project path, because it sets no project-dir variable. The launcher finds the hook beside itself. In guard mode it turns a missing or crashing script into exit 2 and names the script. In advisory mode it reports a missing script once and exits 0 (0000316).

**Forced adds are blocked.** The `block-forced-add` guard runs on Bash calls and exits 2 on `git add -f`, `--force` and its abbreviations, and any short flag group that contains `f`. The tracked `.gitignore` lists `plan/.initiative-logs/`, `plan/.initiative-queue/`, and `plan/.initiative-runner.lock`. Ship and CI run `git ls-files -ci --exclude-standard` and fail on a listed file (0000317).

**Two scripts, one result.** `setup.sh` and `setup.ps1` wire the same nine hooks, in the same events, matchers, and order. A parity suite fails if they drift. `setup.ps1` runs on Windows PowerShell 5.1 and PowerShell 7. It reads and writes `settings.json` as UTF-8 with no BOM. Flags and the tool name match case in both scripts.

**Hook entry repair.** Both scripts find a RAVINTIO `PreToolUse` entry by its module name, on any matcher. So an older `Write|Edit` entry gives way to one `Write` entry and one `Edit` entry, and `gate-write` runs once per tool. If `PreToolUse`, `UserPromptSubmit`, or `Stop` holds a value that isn't an array, setup prints a warning that names the event and the file. The warning never prints the old value, because a hook command can hold a secret. It then replaces the value with the RAVINTIO entries and exits 0. An absent or null value gets the entries with no warning.

**Per-command filter.** Both scripts filter `PreToolUse` and `UserPromptSubmit` one command at a time. Setup removes each RAVINTIO command and keeps any user command in the same entry. If an entry holds only RAVINTIO commands, setup drops it. A `hooks` value that holds one object counts as a one-item array, so setup filters it the same way. An entry with no commands stays as it was. A command counts as RAVINTIO only when it runs `<module>.mjs` at a path boundary, matched case-sensitively.

**Invalid JSON.** If `settings.json` isn't valid JSON, the hook install step prints one fixed line that names the file. The line never holds the file's contents. Setup leaves the file unchanged and exits 1, because it can't install the hooks.

**Not a settings object.** If `settings.json` is valid JSON but not a settings object, both scripts print one fixed line that names the file. That covers a top level that isn't an object, and a `hooks` value that is present and isn't an object. Setup leaves the file unchanged and exits 1. `setup.ps1` also gives this line for keys that differ only by case, because `ConvertFrom-Json` can't read them. `setup.sh` accepts those keys, because Node reads them.

**Nesting cap.** `setup.ps1` checks JSON nesting with a counter and a stack, so the check runs in linear time. Nesting deeper than 1024 levels gets the not-a-settings-object line.

**JSON depth.** `setup.ps1` writes `settings.json` with `ConvertTo-Json -Depth 100`, so a deeply nested user value survives a rewrite.

**File copy.** `setup.ps1` copies skill and hook files with `System.IO` calls through `Copy-RavintioItem` and `Copy-RavintioTree`. A cmdlet call per file cost about 4 times as much. The folder copy keeps dot files and empty folders. The SKILL.md path rewrite keeps `Set-Content`, so each host keeps its own BOM rule. A tree suite checks each installed skill against its source folder, file by file.

---

## Tests

A wording test greps every tracked file outside history for the retired word that once described RAVINTIO Zero. It passes only lines that match an allowlist of generic uses. A phase guard test fails on a phase number outside P0 to P4 or on a retired letter prefix. A brand guard test fails on any tracked path or line outside history that holds the earlier product name, unless an allowlist entry matches. It also fails on a stale allowlist entry.

`ravintio-zero/tests/run-tests.sh` runs every Bash and PowerShell suite. Before any suite runs, it checks every file under `tests/`. A file that is neither a suite nor on its known list fails the run, and the runner names it. Without `pwsh`, it prints how many PowerShell suites it skipped. Each suite starts without any `RAVINTIO_` variable except `RAVINTIO_PWSH`, `RAVINTIO_TIMING_FILE`, and `RAVINTIO_TEST_QUIET`. The runner compares tracked and untracked files before the first suite and after the last, and it fails the run and names each path that changed (0000315).

Set `RAVINTIO_TEST_QUIET=1` to hide PASS lines and banners. The runner then keeps every FAIL line with its detail, the failing suite name, the summary, and the exit codes. A quiet full run prints about 3 KB. Skills that run the full suite set it.

`helpers/assert.sh` fails a Bash suite that calls an undefined `assert_*` function, and it offers `assert_not_contains`. The installed-copies check in `test-0000151-req-014` skips while an initiative is active and `.claude/skills/.ravintio-manifest` is older than the newest pack skill.

The PowerShell suites run `setup.ps1` in temporary projects. In CI, the `windows-powershell` job runs them as a two-entry matrix, one entry for Windows PowerShell 5.1 and one for PowerShell 7. The entries run in parallel and neither cancels the other. Helpers print per-case timing. `run-tests.ps1` also prints `[timing] setup.ps1 total: {ms} ms over {n} cases` before its summary. Suites append each setup time to the file that `RAVINTIO_TIMING_FILE` names, and the runner deletes it at the end. The `bash-suites` job runs `run-tests.sh` on `ubuntu-latest` with `RAVINTIO_REQUIRE_PWSH=1`. So it runs every Bash suite and fails if `pwsh` is missing.

The workflow guards each of those jobs to `pull_request` events. On a pull request, `validate-branch` also runs `scripts/check-attribution.mjs` on the PR description, which it reads from an `env:` entry. On a push to `main` or `master`, only the `release-tag` job runs. It holds `contents: write` and runs `scripts/release-tag.mjs`, which tags `HEAD` with `v{version}` from `product.yml` and skips a tag that exists. The consumer template `hooks/ravintio.yml` carries `validate-branch` and `release-tag` only.

---

## Version derivation

`product.yml` holds the product-level version manifest. Under `versionPolicy: max-component-version`, `scripts/product-version.mjs` reads each listed `component.yml` live and takes the highest. Nothing caches a version, so the list only changes when a component is added or removed.

This project has one component and keeps `product.yml` anyway. Its top-level `id` gives the product a stable name for versioning and for attributing archived runs, wherever the repo is cloned. The orchestrator hard-stops at discovery when that `id` is missing.

The five phase names live in prose in `ravintio-zero/pipeline-reference.md`. No module encodes them.
