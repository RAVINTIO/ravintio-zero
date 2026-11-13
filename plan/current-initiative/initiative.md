---
title: "Initiative: 0000360 - backlog sweep"
summary: "Closes 62 open backlog entries in 21 steps, and makes the driver run independent steps at once in worktrees."
status: "active"  # proposed | charted | active | delivered | blocked
---
# Initiative: 0000360 - backlog sweep

**Goal:** Close every open backlog entry except the four that need paid services. The first three steps make the driver run independent steps at once, each in its own worktree, with each version set as its step merges. Step 20 moves the pack source to `src/ravintio-zero/`. The last step, step 21, makes activation smoother for the human.
**Branch:** initiative/0000360-backlog-sweep
**Status:** active
**Position:** 62
**Speed:** standard
**Step CI fixes:** allowed
**Concurrency:** 3

Left out at the human's choice, because each needs a paid service or account: 0000174, 0000254, 0000220, and 0000221.

## Stop conditions

- A step prints `Blocked:` or `Question:`, or exits without merging after its resumes.
- CI fails twice on one step PR after the step's own fix.
- A replay conflict at delivery that no admin fold clears.

## Schema changes

**Unpredicted additive changes:** pre-approved

The pack has no `src/` component. Each row is a file format in the pack that a script or test parses.

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1 | ravintio-zero | none | none |
| 2 | ravintio-zero | Chart `Version` and `Status` set by the merge queue. A merge queue record per step. | additive |
| 3 | ravintio-zero | `## Steps` gains `Lane` and `After` columns. The parser accepts `running` and `ready`, which the driver derives and never commits. The `**Concurrency:**` field. A per-step log and control area. | additive |
| 4 | ravintio-zero | `<!-- rule: {id} -->` anchors in skills, standards, and templates, read by a test helper | additive |
| 5 | ravintio-zero | `.ravintio-manifest` paths relative to the repo root | additive |
| 6 | ravintio-zero | The setup manifest records every write, including pack-owned commands | additive |
| 7 | ravintio-zero | none | none |
| 8 | ravintio-zero | `docs/adr/` with `docs/adr/.next-id`. ADR front matter names its component. Execution plan concurrency table gains `Shared resources`. Design template gains `## Component Paths`. | additive |
| 9 | ravintio-zero | `plan/current/baseline-failures.md`. A build-log tests-run line. | additive |
| 10 | ravintio-zero | Build-log `Done:` line gains the unit class, tier, and effort | additive |
| 11 | ravintio-zero | A track marker in `discovery.md`. A build-log `Audit:` line. | additive |
| 12 | ravintio-zero | Driver and watcher lines gain a leading `hh:mm` time | additive |
| 13 | ravintio-zero | `.claude/settings.json` gains `outputStyle` | additive |
| 14 | ravintio-zero | A per-file prose breach baseline | additive |
| 15 | ravintio-zero | `ravintio-overrides/standards/` and `ravintio-overrides/templates/`, and an archetype folder format | additive |
| 16 | ravintio-zero | A build-log `Postmortem: {path}` line, and a CAPA table in the postmortem template | additive |
| 17 | ravintio-zero | A `plan/state/` record of the last confirmed pack version | additive |
| 18 | ravintio-zero | A shared brand guard allowlist file | additive |
| 19 | ravintio-zero | none | none |
| 20 | ravintio-zero | none. The pack source moves to `src/ravintio-zero/`, and no file format changes. | none |
| 21 | ravintio-zero | none | none |
| 22 | none | none | none |
| 23 | none | none | none |
| 24 | none | none | none |
| 25 | none | none | none |
| 26 | none | none | none |
| 27 | none | none | none |
| 28 | none | none | none |
| 29 | none | none | none |
| 30 | none | none | none |
| 31 | none | none | none |
| 32 | none | none | none |
| 33 | none | none | none |
| 34 | none | none | none |
| 35 | none | none | none |
| 36 | none | none | none |
| 37 | none | none | none |
| 38 | none | none | none |
| 39 | none | none | none |
| 40 | none | none | none |
| 41 | none | none | none |
| 42 | none | none | none |
| 43 | none | none | none |
| 44 | none | none | none |
| 45 | none | none | none |
| 46 | none | none | none |
| 47 | none | none | none |
| 48 | none | none | none |
| 49 | none | none | none |
| 50 | none | none | none |
| 51 | none | none | none |
| 52 | none | none | none |
| 53 | none | none | none |
| 54 | none | none | none |
| 55 | none | none | none |
| 56 | none | none | none |
| 57 | none | none | none |
| 58 | none | none | none |
| 59 | none | none | none |
| 60 | none | none | none |
| 61 | none | none | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1 | none | none | none |
| 2 | none | none | none |
| 3 | none | none | none. `git worktree` is part of git. |
| 4 | none | none | none |
| 5 | none | none | none |
| 6 | none | none | none |
| 7 | none | none | none |
| 8 | none | none | none |
| 9 | none | none | none |
| 10 | none | none | none |
| 11 | none | none | none |
| 12 | none | none | none |
| 13 | none | none | none. Uses the Claude Code output styles feature. |
| 14 | none | none | none. A Node script with no packages. |
| 15 | Pact, Stryker or PIT, Playwright MCP | library | Named by the strict-testing archetype for consumer repos. The pack installs none of them. |
| 16 | none | none | none |
| 17 | none | none | none |
| 18 | `actions/dependency-review-action`, `ossf/scorecard-action`, `actions/attest-build-provenance` | library | GitHub Actions for dependency review, Scorecard, and release provenance (0000323) |
| 18 | Dependabot, GitHub secret scanning and push protection, private vulnerability reporting | service | Free GitHub features (0000323) |
| 18 | actionlint, zizmor | library | Workflow lint job in CI (0000325) |
| 19 | none | none | none |
| 20 | none | none | none |
| 21 | none | none | none |
| 22 | none | none | none |
| 23 | none | none | none |
| 24 | none | none | none |
| 25 | none | none | none |
| 26 | none | none | none |
| 27 | none | none | none |
| 28 | none | none | none |
| 29 | none | none | none |
| 30 | none | none | none |
| 31 | none | none | none |
| 32 | none | none | none |
| 33 | none | none | none |
| 34 | none | none | none |
| 35 | none | none | none |
| 36 | none | none | none |
| 37 | none | none | none |
| 38 | none | none | none |
| 39 | none | none | none |
| 40 | none | none | none |
| 41 | none | none | none |
| 42 | none | none | none |
| 43 | none | none | none |
| 44 | none | none | none |
| 45 | none | none | none |
| 46 | none | none | none |
| 47 | none | none | none |
| 48 | none | none | none |
| 49 | none | none | none |
| 50 | none | none | none |
| 51 | none | none | none |
| 52 | none | none | none |
| 53 | none | none | none |
| 54 | none | none | none |
| 55 | none | none | none |
| 56 | none | none | none |
| 57 | none | none | none |
| 58 | none | none | none |
| 59 | none | none | none |
| 60 | none | none | none |
| 61 | none | none | none |

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1-21 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`. If the command differs in any way, stop for the human. | none |
| 25-41 | Local suite runs | Approved by the human on 2026-11-10. Run the local suite in 4 parallel shards with `RAVINTIO_SHARD=1/4` to `4/4`, and read every shard's summary. Reuse the known baseline: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh` fail in a clean clone on the base. Record them with `baseline-failures.mjs` without a base run. If any other suite fails, run that suite on the base commit to tell an inherited failure from a new one. CI still runs every suite. | none |
| 1 | The orchestrator skill has 118 bytes left under its 9000 byte cap | Move the Context Hygiene section to `references/orchestrator-context-hygiene.md` with a Pack Index row, and update the cap tests (0000371), before the `Question:` edit | none |
| 1 | The driver changes while it runs | The coordinator takes the `Restart:` stop and starts a new driver and watcher | none |
| 2 | Steps 1 and 2 still bump in P4 | Steps 1 and 2 use today's P4 bump. The merge queue sets versions from step 3 on. | none |
| 2 | Where the PR title check runs (0000372) | In the merge queue, before each merge. It may also tighten `merge-guard`. | none |
| 2 | Version files differ after a bump (0000368) | The merge queue checks every version file after it bumps, and stops on a difference | none |
| 3 | How many steps run at once | `**Concurrency:** 3` | none |
| 3 | The repo `CLAUDE.md` says "Don't use git worktrees" | Scope the rule to human sessions in `ravintio-zero/templates/standard-boot.md`. Setup regenerates this repo's `CLAUDE.md`. | none |
| 3 | A stop line arrives while other steps run | Start no new step. Let the other steps reach their next commit, then stop them and report each step's state. | none |
| 3 | The driver changes to parallel mode | After step 3 merges, the coordinator takes the `Restart:` stop and starts the new driver. Steps 4 to 19 run in parallel mode. | none |
| 4 | Rule anchors touch most tests and skills (0000308) | Step 4 runs alone. Every later step waits for it. | none |
| 5 | The manifest loop runs `rm -rf` on any listed path (0000262) | Resolve each path under the repo root and refuse any path outside it, in `setup.sh` and `setup.ps1` | none |
| 6 | Widening: 0000292 adds an uninstall that removes every guard | Approved by the human. Uninstall needs an explicit `--uninstall` flag, prints each guard it removes, and refuses while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists. | none |
| 6 | 0000291 would turn strict mode off on a plain re-run | Cut back, as the human chose. Strict mode stays on across re-runs. Only an explicit `--no-strict-orchestrator` turns it off, and setup prints that it did. | none |
| 6 | 0000299 refuses uncommitted pack files, which breaks updates | 0000283's update command commits the pack files first, in the same step | none |
| 8 | 0000280 open question: recover the ADRs of features 0000001 to 0000029 | Yes. The migration restores them from git history before it numbers. | none |
| 8 | 0000280 open question: per-component ADR folders | No. One repo-wide `docs/adr/` folder and counter. Front matter names the component. | none |
| 8 | 0000280 ADR number width | Four digits, as in `0042-commit-counter-by-path.md` | none |
| 10 | 0000366 class list and tier table | Classes `content`, `code`, `test`, and `config`. Tiers and effort come from a table in `agent-dispatch-standards.md` that the step writes. An inline unit from 0000330 is class `content`. | none |
| 11 | 0000281 needs the design `## Component Paths` from 0000263 | Step 11 waits for step 8 | none |
| 12 | 0000258 solution | Rename the warning "Reply prefix check", quote the first words of the reply, and name the session. Skip the check in the coordinator session while a driver step runs, using the step session's environment marker. | none |
| 13 | A writing style a developer doesn't want | Add a `--no-writing-style` setup flag | none |
| 13 | `em-dash-guard.mjs` suggests a semicolon as a replacement | Change the suggestion to match the writing standard | none |
| 14 | The prose linter blocks existing breaches | It blocks new breaches only, against the per-file baseline | none |
| 15 | The archetype resolver could let an override weaken a hook-enforced rule | The resolver ignores any override of a rule a hook enforces, and a test proves it. Otherwise stop. | none |
| 18 | Human-only settings (0000323, 0000325) | Human stop: the step prints a checklist of secret scanning, push protection, Dependabot security updates, private vulnerability reporting, topics, and the lint job as a required check, then waits | none |
| 19 | The pack prose rewrite breaks wording-pinned tests | Step 19 runs after steps 1 to 18, and tests read rule anchors from step 4 | none |
| 20 | How the pack source moves (0000396) | Commit a pure `git mv ravintio-zero src/ravintio-zero` first. Then copy `src/ravintio-zero/` back to `ravintio-zero/` as a plain file system copy with no history. No symlink. | none |
| 20 | Consumer repos after the move | Consumer installs keep the `ravintio-zero/` path. Pack references that consumers read stay unchanged. | none |
| 20 | The two copies diverge | By design. `src/ravintio-zero/` is the source. `ravintio-zero/` is the installed copy, and it changes only through a refresh from the source. | none |
| 20 | Guards that cover `ravintio-zero/` | Extend each one to cover `src/ravintio-zero/` too. No guard gains a new allowed form. | none |
| 20 | Step 20 runs last | Step 20 runs after step 19, so steps 1 to 19 edit `ravintio-zero/` at the old layout | none |
| 21 | Step 21 runs last (0000398) | Step 21 runs after step 20. It edits the pack source in `src/ravintio-zero/` and refreshes the installed copy. | none |
| 1-21 | A test pins text that the step edits | Update the pin in the same step and log a `Rework:` line | none |
| 1-21 | A step changes the tree while its own suite runs | Rerun the suite on a clean tree before closing the phase | none |
| 22 | none | none | none |
| 23 | none | none | none |
| 24 | none | none | none |
| 25 | none | none | none |
| 26 | none | none | none |
| 27 | none | none | none |
| 28 | The driver runs setup at a `Setup:` stop | Approved by the human on 2026-11-10. The driver runs only the exact command from the `Confirmation:` row, then continues. A missing or different command still stops the run. | none |
| 29 | none | none | none |
| 30 | 0000412: archive after CI, or a reopen route | The human chose on 2026-11-10: ship waits for green CI and archives as its last push before `ready`. No reopen route, so `gate-write` stays as it is. | none |
| 31 | none | none | none |
| 32 | none | none | none |
| 33 | Narrow `merge-guard` | Approved by the human on 2026-11-10. `merge-guard` refuses `--squash` when `RAVINTIO_INITIATIVE_QUEUE=1`. A test shows the queue still merges. | none |
| 34 | Scope of the brand guard skip | The human chose on 2026-11-10: the exact-path skip covers both `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt`. | none |
| 35 | none | none | none |
| 36 | none | none | none |
| 37 | none | none | none |
| 38 | none | none | none |
| 39 | none | none | none |
| 40 | none | none | none |
| 41 | none | none | none |
| 42 | none | none | none |
| 43 | none | none | none |
| 44 | none | none | none |
| 45 | none | none | none |
| 46 | none | none | none |
| 47 | none | none | none |
| 48 | none | none | none |
| 49 | none | none | none |
| 50 | none | none | none |
| 51 | none | none | none |
| 52 | none | none | none |
| 53 | none | none | none |
| 54 | none | none | none |
| 55 | none | none | none |
| 56 | none | none | none |
| 57 | none | none | none |
| 58 | none | none | none |
| 59 | none | none | none |
| 60 | none | none | none |
| 61 | none | none | none |

## Baselines

| Step | Target | Baseline | Source |
|------|--------|----------|--------|
| 1-21 | none | none | No step sets a speed or size target |
| 22 | none | none | none |
| 23 | none | none | none |
| 24 | none | none | none |
| 25 | none | none | none |
| 26 | none | none | none |
| 27 | none | none | none |
| 28 | none | none | none |
| 29 | none | none | none |
| 30 | none | none | none |
| 31 | none | none | none |
| 32 | none | none | none |
| 33 | none | none | none |
| 34 | none | none | none |
| 35 | none | none | none |
| 36 | none | none | none |
| 37 | none | none | none |
| 38 | none | none | none |
| 39 | none | none | none |
| 40 | none | none | none |
| 41 | none | none | none |
| 42 | none | none | none |
| 43 | none | none | none |
| 44 | none | none | none |
| 45 | none | none | none |
| 46 | none | none | none |
| 47 | none | none | none |
| 48 | none | none | none |
| 49 | none | none | none |
| 50 | none | none | none |
| 51 | none | none | none |
| 52 | none | none | none |
| 53 | none | none | none |
| 54 | none | none | none |
| 55 | none | none | none |
| 56 | none | none | none |
| 57 | none | none | none |
| 58 | none | none | none |
| 59 | none | none | none |
| 60 | none | none | none |
| 61 | none | none | none |

## Criteria

| Step | Criterion | Noise and margin | Checked in |
|------|-----------|------------------|------------|
| 3 | Two stub steps in different lanes run at once | Deterministic | local |
| 13 | The output style installs for Claude Code and Codex | Deterministic | local |
| 18 | Each GitHub setting reads on through `gh api` | Deterministic after the human stop | CI |
| 18 | The workflow lint job passes | Deterministic | CI |
| 20 | `git log --follow src/ravintio-zero/setup.sh` reaches commits from before the move | Deterministic | local |
| 20 | `ravintio-zero/` matches `src/ravintio-zero/` byte for byte at the step's end | Deterministic | local |
| 1-21 | Windows setup tests pass | Deterministic | CI |
| 22 | none | none | none |
| 23 | none | none | none |
| 24 | none | none | none |
| 25 | none | none | none |
| 26 | none | none | none |
| 27 | none | none | none |
| 28 | none | none | none |
| 29 | none | none | none |
| 30 | none | none | none |
| 31 | none | none | none |
| 32 | none | none | none |
| 33 | none | none | none |
| 34 | none | none | none |
| 35 | none | none | none |
| 36 | none | none | none |
| 37 | none | none | none |
| 38 | none | none | none |
| 39 | none | none | none |
| 40 | none | none | none |
| 41 | none | none | none |
| 42 | none | none | none |
| 43 | none | none | none |
| 44 | none | none | none |
| 45 | none | none | none |
| 46 | none | none | none |
| 47 | none | none | none |
| 48 | none | none | none |
| 49 | none | none | none |
| 50 | none | none | none |
| 51 | none | none | none |
| 52 | none | none | none |
| 53 | none | none | none |
| 54 | none | none | none |
| 55 | none | none | none |
| 56 | none | none | none |
| 57 | none | none | none |
| 58 | none | none | none |
| 59 | none | none | none |
| 60 | none | none | none |
| 61 | none | none | none |

## P1 skips

| Step | Skip P1 | Reason |
|------|---------|--------|
| 1-21 | no | Every step changes scripts, hooks, skills, or tests |
| 22 | no | Added after the chart. The human sets this at P1. |
| 23 | no | Added after the chart. The human sets this at P1. |
| 24 | no | Added after the chart. The human sets this at P1. |
| 25 | no | Added after the chart. The human sets this at P1. |
| 26 | no | Added after the chart. The human sets this at P1. |
| 27 | no | Added after the chart. The human sets this at P1. |
| 28 | no | Added after the chart. The human sets this at P1. |
| 29 | no | Added after the chart. The human sets this at P1. |
| 30 | no | Added after the chart. The human sets this at P1. |
| 31 | no | Added after the chart. The human sets this at P1. |
| 32 | no | Added after the chart. The human sets this at P1. |
| 33 | no | Added after the chart. The human sets this at P1. |
| 34 | no | Added after the chart. The human sets this at P1. |
| 35 | no | Added after the chart. The human sets this at P1. |
| 36 | no | Added after the chart. The human sets this at P1. |
| 37 | no | Added after the chart. The human sets this at P1. |
| 38 | no | Added after the chart. The human sets this at P1. |
| 39 | no | Added after the chart. The human sets this at P1. |
| 40 | no | Added after the chart. The human sets this at P1. |
| 41 | no | Added after the chart. The human sets this at P1. |
| 42 | no | Added after the chart. The human sets this at P1. |
| 43 | no | Added after the chart. The human sets this at P1. |
| 44 | no | Added after the chart. The human sets this at P1. |
| 45 | no | Added after the chart. The human sets this at P1. |
| 46 | no | Added after the chart. The human sets this at P1. |
| 47 | no | Added after the chart. The human sets this at P1. |
| 48 | no | Added after the chart. The human sets this at P1. |
| 49 | no | Added after the chart. The human sets this at P1. |
| 50 | no | Added after the chart. The human sets this at P1. |
| 51 | no | Added after the chart. The human sets this at P1. |
| 52 | no | Added after the chart. The human sets this at P1. |
| 53 | no | Added after the chart. The human sets this at P1. |
| 54 | no | Added after the chart. The human sets this at P1. |
| 55 | no | Added after the chart. The human sets this at P1. |
| 56 | no | Added after the chart. The human sets this at P1. |
| 57 | no | Added after the chart. The human sets this at P1. |
| 58 | no | Added after the chart. The human sets this at P1. |
| 59 | no | Added after the chart. The human sets this at P1. |
| 60 | no | Added after the chart. The human sets this at P1. |
| 61 | no | Added after the chart. The human sets this at P1. |

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status | Lane | After |
|------|------------|-------|-----------------|------|---------|--------|------|-------|
| 1 | 0000377-driver-stops-and-headroom | Driver stops and headroom | 0000371, 0000370, 0000373 | minor | 0.57.0 | merged | driver | |
| 2 | 0000378-merge-time-versioning | Merge-time versioning | 0000374, 0000376, 0000372, 0000368 | minor | 0.58.0 | merged | driver | 1 |
| 3 | 0000379-parallel-steps-on-worktrees | Parallel steps on worktrees | 0000375 | minor | 0.59.0 | merged | driver | 2 |
| 4 | 0000380-test-helpers-and-rule-anchors | Test helpers and rule anchors | 0000261, 0000308, 0000337 | minor | 0.60.0 | merged | tests | 3 |
| 5 | 0000381-setup-safety | Setup safety | 0000262, 0000289, 0000293, 0000290 | minor | 0.61.0 | merged | setup | 4 |
| 6 | 0000382-install-lifecycle | Install lifecycle | 0000283, 0000299, 0000292, 0000291, 0000298, 0000286 | minor | 0.63.0 | merged | setup | 5 |
| 7 | 0000383-test-impact-scan | Test impact scan | 0000361, 0000362, 0000363, 0000369, 0000297 | minor | 0.62.0 | merged | plan | 4 |
| 8 | 0000384-plan-checks | Plan checks | 0000255, 0000263, 0000333, 0000347, 0000280, 0000364 | minor | 0.65.0 | merged | plan | 7 |
| 9 | 0000385-faster-test-runs | Faster test runs | 0000294, 0000295, 0000296 | minor | 0.67.0 | merged | run | 4 |
| 10 | 0000386-unit-dispatch | Unit dispatch | 0000330, 0000366 | minor | 0.71.0 | merged | run | 9 |
| 11 | 0000387-light-discovery-and-audits | Light discovery and audits | 0000281, 0000284, 0000348, 0000328, 0000329 | minor | 0.70.0 | merged | orchestrator | 8 |
| 12 | 0000388-replies-and-questions | Replies and questions | 0000257, 0000258, 0000259, 0000306 | minor | 0.64.0 | merged | orchestrator | 4 |
| 13 | 0000389-writing-standard | Writing standard | 0000300 | minor | 0.68.0 | merged | writing | 4 |
| 14 | 0000390-prose-checks | Prose checks | 0000301, 0000303, 0000304 | minor | 0.73.0 | merged | writing | 6, 13 |
| 15 | 0000391-standards-archetypes | Standards archetypes | 0000305 | minor | 0.74.0 | merged | writing | 6, 14 |
| 16 | 0000392-ship-postmortems | Ship postmortems | 0000285 | minor | 0.72.0 | merged | ship | 4 |
| 17 | 0000393-session-integrity-and-guards | Session integrity and guards | 0000271, 0000367, 0000272, 0000260 | minor | 0.66.0 | merged | guards | 6 |
| 18 | 0000394-github-security-and-ci-lint | GitHub security and CI lint | 0000323, 0000324, 0000325 | minor | 0.69.0 | merged | github | 4 |
| 19 | 0000395-pack-prose-to-the-standard | Pack prose to the standard | 0000302 | minor | 0.75.0 | merged | writing | 5-18 |
| 20 | 0000397-pack-source-in-src | Pack source in src | 0000396 | minor | 0.76.0 | merged | layout | 19 |
| 21 | 0000399-smoother-activation | Smoother activation | 0000398 | minor | 0.77.0 | merged | initiative | 20 |
| 22 | 0000421-initiative-retrospective | Initiative retrospective | 0000422 | patch | 0.77.1 | merged | initiative | 21 |
| 23 | 0000438-add-step-writes-full-feature-id | Add-step writes the full feature id | 0000423 | patch | 0.77.2 | merged | chart-scripts | 22 |
| 24 | 0000440-driver-reads-reply-blocks | Driver reads blocks from the reply | 0000413 | minor | 0.79.0 | merged | driver | 22 |
| 25 | 0000442-ready-file-helper | Ready file helper | 0000424 | minor | 0.84.0 | merged | driver | 24 |
| 26 | 0000444-step-reads-its-queue-items | Steps read their queue items | 0000425 | minor | 0.89.0 | merged | driver | 25 |
| 27 | 0000446-drain-ready-prs-after-a-stop | Merge ready PRs after a stop | 0000426 | minor | 0.91.0 | merged | driver | 26 |
| 28 | 0000448-driver-runs-approved-setup-command | Driver runs the approved setup command | 0000427 | minor | 0.92.0 | merged | driver | 27 |
| 29 | 0000450-coordinator-status-view | Coordinator status view | 0000428 | minor | 0.96.0 | merged | driver | 28 |
| 30 | 0000452-ci-wait-before-archive | Ship waits for CI before it archives | 0000412 | minor | 0.78.0 | merged | ship | 22 |
| 31 | 0000454-queue-failure-recovery | Queue failure recovery | 0000429 | minor | 0.80.0 | merged | queue | 22 |
| 32 | 0000456-regenerate-shared-files-at-merge | Regenerate shared files at merge | 0000430 | minor | 0.82.0 | merged | queue | 31 |
| 33 | 0000458-refuse-step-merge-outside-queue | Refuse a step merge outside the queue | 0000431 | minor | 0.81.0 | merged | guard | 31 |
| 34 | 0000460-narrow-brand-guard-self-entry | Narrow the brand guard self-entry | 0000432 | patch | 0.80.1 | merged | tests | 22 |
| 35 | 0000462-tests-without-git-identity | Tests catch runner-only failures | 0000414 | minor | 0.83.0 | merged | tests | 34 |
| 36 | 0000464-merge-queue-test-gaps | Merge queue test gaps | 0000400 | minor | 0.87.0 | merged | tests | 31, 35 |
| 37 | 0000466-version-files-completeness-check | Version files completeness check | 0000433 | minor | 0.88.0 | merged | tests | 36 |
| 38 | 0000468-reply-time-matches-the-clock | Reply time matches the clock | 0000434 | minor | 0.85.0 | merged | hooks | 22 |
| 39 | 0000470-plan-rereads-files-at-the-branch-point | Plan rereads files at the branch point | 0000435 | minor | 0.86.0 | merged | plan-skill | 22 |
| 40 | 0000472-ci-duration-metric | CI duration metric | 0000436 | minor | 0.90.0 | merged | ci | 22 |
| 41 | 0000474-coordinator-shell-guidance | Coordinator shell guidance | 0000437 | minor | 0.99.0 | merged | initiative-skill | 29 |
| 42 | 0000481-regenerate-after-every-merge | Regenerate shared files after every base merge | 0000482 | minor | 0.95.0 | merged | queue | 22 |
| 43 | 0000483-mergeability-before-ci-wait | Check mergeability before a CI wait | 0000484 | minor | 0.93.0 | merged | ship | 30 |
| 44 | 0000485-adr-number-collision | Parallel steps reserve distinct ids | 0000479 | minor | 0.94.0 | merged | adr | 22 |
| 45 | 0000487-steps-apply-decision-rows | Steps apply the chart's Decisions rows | 0000488 | minor | 0.98.0 | merged | skills | 22 |
| 46 | 0000489-question-only-for-questions | Steps use Question only for real questions | 0000490 | minor | 0.100.0 | merged | skills | 45 |
| 47 | 0000491-driver-favours-critical-path | Driver favours the critical path | 0000492 | minor | 0.104.0 | merged | driver | 41 |
| 48 | 0000493-driver-starts-after-restart | Driver keeps starting steps after a Restart | 0000494 | minor | 0.105.0 | merged | driver | 47 |
| 49 | 0000495-driver-clears-dead-lock | Driver clears a dead lock | 0000496 | minor | 0.106.0 | merged | driver | 48 |
| 50 | 0000497-keep-worktree-entries | Driver keeps uncommitted entries from a worktree | 0000498 | minor | 0.107.0 | merged | driver | 49 |
| 51 | 0000499-reply-times-match-clock | Reply times match the clock | 0000500 | minor | 0.101.0 | merged | skills | 46 |
| 52 | 0000501-remove-merged-worktrees | Driver removes merged step worktrees | 0000502 | minor | 0.108.0 | merged | driver | 50 |
| 53 | 0000503-planned-restart-exit-code | Planned restart exits with its own code | 0000504 | minor | 0.109.0 | merged | driver | 52 |
| 54 | 0000505-coordinator-branch-regenerate | Coordinator branches regenerate shared files | 0000506 | minor | 0.97.0 | merged | queue | 42 |
| 55 | 0000507-hook-check-after-setup | Check every hook after setup | 0000508 | minor | 0.110.0 | merged | driver | 53 |
| 56 | 0000509-clear-merged-ready-files | Driver clears ready files of merged steps | 0000510 | minor | 0.111.0 | merged | driver | 55 |
| 57 | 0000511-driver-stop-summary | Driver prints a stop summary | 0000512 | minor | 0.112.0 | merged | driver | 56 |
| 58 | 0000519-ship-removal-needs-human-approval | Ship removes plan/current with git rm | 0000518 | minor | 0.102.0 | merged | ship | 43 |
| 59 | 0000521-replies-name-actors-by-role | Replies name actors by role | 0000522 | minor | 0.103.0 | merged | skills | 51 |
| 60 | 0000534-step-sessions-receive-clock | Step sessions receive the clock | 0000535 | minor | 0.113.0 | merged | skills | 59 |
| 61 | 0000536-pending-migrations-reach-the-human-early | Pending migrations reach the human early | 0000537 | minor | 0.114.0 | merged | initiative-skill | 41 |

## Merges

| Step | PR | Merge commit | Version | Merged at |
|------|----|--------------|---------|-----------|
| 3 | #128 | tag v0.59.0 | 0.59.0 | 2026-11-07T19:15:39Z |
| 4 | #129 | tag v0.60.0 | 0.60.0 | 2026-11-07T21:21:46Z |
| 5 | #131 | tag v0.61.0 | 0.61.0 | 2026-11-08T01:04:33Z |
| 7 | #132 | tag v0.62.0 | 0.62.0 | 2026-11-08T02:38:25Z |
| 6 | #136 | tag v0.63.0 | 0.63.0 | 2026-11-08T15:23:07Z |
| 12 | #133 | tag v0.64.0 | 0.64.0 | 2026-11-08T16:55:17Z |
| 8 | #138 | tag v0.65.0 | 0.65.0 | 2026-11-09T00:27:39Z |
| 17 | #142 | tag v0.66.0 | 0.66.0 | 2026-11-09T02:56:13Z |
| 9 | #130 | tag v0.67.0 | 0.67.0 | 2026-11-09T06:47:22Z |
| 13 | #135 | tag v0.68.0 | 0.68.0 | 2026-11-09T09:10:30Z |
| 18 | #137 | tag v0.69.0 | 0.69.0 | 2026-11-09T13:15:22Z |
| 11 | #143 | tag v0.70.0 | 0.70.0 | 2026-11-09T14:27:49Z |
| 10 | #145 | tag v0.71.0 | 0.71.0 | 2026-11-09T15:42:35Z |
| 16 | #134 | tag v0.72.0 | 0.72.0 | 2026-11-09T16:44:31Z |
| 14 | #146 | tag v0.73.0 | 0.73.0 | 2026-11-09T18:09:03Z |
| 15 | #148 | tag v0.74.0 | 0.74.0 | 2026-11-09T19:48:19Z |
| 19 | #149 | tag v0.75.0 | 0.75.0 | 2026-11-09T21:30:06Z |
| 20 | #150 | tag v0.76.0 | 0.76.0 | 2026-11-10T00:06:56Z |
| 21 | #152 | tag v0.77.0 | 0.77.0 | 2026-11-10T01:56:33Z |
| 22 | #155 | tag v0.77.1 | 0.77.1 | 2026-11-10T03:16:08Z |
| 23 | #158 | tag v0.77.2 | 0.77.2 | 2026-11-10T14:56:17Z |
| 30 | #157 | tag v0.78.0 | 0.78.0 | 2026-11-10T15:09:08Z |
| 24 | #159 | tag v0.79.0 | 0.79.0 | 2026-11-10T15:31:08Z |
| 31 | #160 | tag v0.80.0 | 0.80.0 | 2026-11-10T15:51:23Z |
| 34 | #161 | tag v0.80.1 | 0.80.1 | 2026-11-10T16:16:16Z |
| 33 | #162 | tag v0.81.0 | 0.81.0 | 2026-11-10T17:46:33Z |
| 32 | #164 | tag v0.82.0 | 0.82.0 | 2026-11-10T18:17:04Z |
| 35 | #165 | tag v0.83.0 | 0.83.0 | 2026-11-10T18:59:00Z |
| 25 | #163 | tag v0.84.0 | 0.84.0 | 2026-11-10T19:54:46Z |
| 38 | #167 | tag v0.85.0 | 0.85.0 | 2026-11-10T20:27:02Z |
| 39 | #168 | tag v0.86.0 | 0.86.0 | 2026-11-10T20:51:47Z |
| 36 | #166 | tag v0.87.0 | 0.87.0 | 2026-11-10T21:22:46Z |
| 37 | #170 | tag v0.88.0 | 0.88.0 | 2026-11-10T22:18:06Z |
| 26 | #171 | tag v0.89.0 | 0.89.0 | 2026-11-10T22:31:25Z |
| 40 | #172 | tag v0.90.0 | 0.90.0 | 2026-11-10T23:13:30Z |
| 27 | #173 | tag v0.91.0 | 0.91.0 | 2026-11-11T00:22:34Z |
| 28 | #175 | tag v0.92.0 | 0.92.0 | 2026-11-11T01:45:18Z |
| 43 | #176 | tag v0.93.0 | 0.93.0 | 2026-11-11T02:09:04Z |
| 44 | #178 | tag v0.94.0 | 0.94.0 | 2026-11-11T02:46:32Z |
| 42 | #177 | tag v0.95.0 | 0.95.0 | 2026-11-11T03:58:15Z |
| 29 | #180 | tag v0.96.0 | 0.96.0 | 2026-11-11T04:33:24Z |
| 54 | #181 | tag v0.97.0 | 0.97.0 | 2026-11-11T04:48:52Z |
| 45 | #179 | tag v0.98.0 | 0.98.0 | 2026-11-11T07:03:07Z |
| 41 | #182 | tag v0.99.0 | 0.99.0 | 2026-11-11T07:51:16Z |
| 46 | #183 | tag v0.100.0 | 0.100.0 | 2026-11-11T08:25:33Z |
| 51 | #186 | tag v0.101.0 | 0.101.0 | 2026-11-11T10:05:27Z |
| 58 | #187 | tag v0.102.0 | 0.102.0 | 2026-11-11T10:28:00Z |
| 59 | #188 | tag v0.103.0 | 0.103.0 | 2026-11-11T19:10:23Z |
| 47 | #185 | tag v0.104.0 | 0.104.0 | 2026-11-11T20:06:47Z |
| 48 | #189 | tag v0.105.0 | 0.105.0 | 2026-11-11T21:48:25Z |
| 49 | #190 | tag v0.106.0 | 0.106.0 | 2026-11-11T22:43:16Z |
| 50 | #191 | tag v0.107.0 | 0.107.0 | 2026-11-11T23:46:39Z |
| 52 | #192 | tag v0.108.0 | 0.108.0 | 2026-11-12T01:22:53Z |
| 53 | #193 | tag v0.109.0 | 0.109.0 | 2026-11-12T02:19:39Z |
| 55 | #195 | tag v0.110.0 | 0.110.0 | 2026-11-12T15:07:12Z |
| 56 | #196 | tag v0.111.0 | 0.111.0 | 2026-11-13T02:38:32Z |
| 57 | #197 | tag v0.112.0 | 0.112.0 | 2026-11-13T04:04:17Z |
| 60 | #199 | tag v0.113.0 | 0.113.0 | 2026-11-13T05:40:55Z |
| 61 | #200 | tag v0.114.0 | 0.114.0 | 2026-11-13T08:16:45Z |
