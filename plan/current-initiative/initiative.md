---
title: "Initiative: 0000360 - backlog sweep"
summary: "Closes 62 open backlog entries in 21 steps, and makes the driver run independent steps at once in worktrees."
status: "active"  # proposed | charted | active | delivered | blocked
---
# Initiative: 0000360 - backlog sweep

**Goal:** Close every open backlog entry except the four that need paid services. The first three steps make the driver run independent steps at once, each in its own worktree, with each version set as its step merges. Step 20 moves the pack source to `src/ravintio-zero/`. The last step, step 21, makes activation smoother for the human.
**Branch:** initiative/0000360-backlog-sweep
**Status:** active
**Position:** 1
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
| 3 | ravintio-zero | `## Steps` gains `Lane` and `After` columns and the `running` and `ready` statuses. The `**Concurrency:**` field. A per-step log and control area. | additive |
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

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1-21 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`. If the command differs in any way, stop for the human. | none |
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

## Baselines

| Step | Target | Baseline | Source |
|------|--------|----------|--------|
| 1-21 | none | none | No step sets a speed or size target |

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

## P1 skips

| Step | Skip P1 | Reason |
|------|---------|--------|
| 1-21 | no | Every step changes scripts, hooks, skills, or tests |

## Lanes

Step 3 moves these columns into `## Steps`. Until then, steps 1 to 3 run one at a time in chart order.

| Step | Lane | After |
|------|------|-------|
| 1 | driver | |
| 2 | driver | 1 |
| 3 | driver | 2 |
| 4 | tests | 3 |
| 5 | setup | 4 |
| 6 | setup | 5 |
| 7 | plan | 4 |
| 8 | plan | 7 |
| 9 | run | 4 |
| 10 | run | 9 |
| 11 | orchestrator | 8 |
| 12 | orchestrator | 4 |
| 13 | writing | 4 |
| 14 | writing | 6, 13 |
| 15 | writing | 6, 14 |
| 16 | ship | 4 |
| 17 | guards | 6 |
| 18 | github | 4 |
| 19 | writing | 5-18 |
| 20 | layout | 19 |
| 21 | initiative | 20 |

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | 0000377-driver-stops-and-headroom | Driver stops and headroom | 0000371, 0000370, 0000373 | minor | | pending |
| 2 | 0000378-merge-time-versioning | Merge-time versioning | 0000374, 0000376, 0000372, 0000368 | minor | | pending |
| 3 | 0000379-parallel-steps-on-worktrees | Parallel steps on worktrees | 0000375 | minor | | pending |
| 4 | 0000380-test-helpers-and-rule-anchors | Test helpers and rule anchors | 0000261, 0000308, 0000337 | minor | | pending |
| 5 | 0000381-setup-safety | Setup safety | 0000262, 0000289, 0000293, 0000290 | minor | | pending |
| 6 | 0000382-install-lifecycle | Install lifecycle | 0000283, 0000299, 0000292, 0000291, 0000298, 0000286 | minor | | pending |
| 7 | 0000383-test-impact-scan | Test impact scan | 0000361, 0000362, 0000363, 0000369, 0000297 | minor | | pending |
| 8 | 0000384-plan-checks | Plan checks | 0000255, 0000263, 0000333, 0000347, 0000280, 0000364 | minor | | pending |
| 9 | 0000385-faster-test-runs | Faster test runs | 0000294, 0000295, 0000296 | minor | | pending |
| 10 | 0000386-unit-dispatch | Unit dispatch | 0000330, 0000366 | minor | | pending |
| 11 | 0000387-light-discovery-and-audits | Light discovery and audits | 0000281, 0000284, 0000348, 0000328, 0000329 | minor | | pending |
| 12 | 0000388-replies-and-questions | Replies and questions | 0000257, 0000258, 0000259, 0000306 | minor | | pending |
| 13 | 0000389-writing-standard | Writing standard | 0000300 | minor | | pending |
| 14 | 0000390-prose-checks | Prose checks | 0000301, 0000303, 0000304 | minor | | pending |
| 15 | 0000391-standards-archetypes | Standards archetypes | 0000305 | minor | | pending |
| 16 | 0000392-ship-postmortems | Ship postmortems | 0000285 | minor | | pending |
| 17 | 0000393-session-integrity-and-guards | Session integrity and guards | 0000271, 0000367, 0000272, 0000260 | minor | | pending |
| 18 | 0000394-github-security-and-ci-lint | GitHub security and CI lint | 0000323, 0000324, 0000325 | minor | | pending |
| 19 | 0000395-pack-prose-to-the-standard | Pack prose to the standard | 0000302 | minor | | pending |
| 20 | 0000397-pack-source-in-src | Pack source in src | 0000396 | minor | | pending |
| 21 | 0000399-smoother-activation | Smoother activation | 0000398 | minor | | pending |
