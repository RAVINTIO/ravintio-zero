---
title: "Initiative: 0000613 - full backlog"
summary: "Builds all 32 open backlog entries in 30 steps, with the 0000544 retrospective fixes first, four at a time."
status: "charted"  # proposed | charted | active | delivered | blocked
---
# Initiative: 0000613 - full backlog

**Goal:** Build every open backlog entry. The 0000544 retrospective fixes and the high-priority queue fixes come first. Pipeline text fixes follow, and the larger features come last.

**Branch:** initiative/0000613-full-backlog

**Status:** charted

**Position:** 1

**Step CI fixes:** stop

**Concurrency:** 4

## Chart answers

The human asked on 2026-11-28 to "Add all backlog entries to the initiative". The human confirmed the chart the same day with "Go".

- The coordinator closed entry 0000584. Step 38 of initiative 0000544 delivered it in the revised scope of ADR-0352.
- The coordinator closed entry 0000220. The human chose the repeatable test in 0000221 over that manual check.
- Entries 0000590 and 0000596 ask for the same plan change, so step 14 builds both.
- The confirmation approves the guard widening for 0000586 in `## Decisions`.
- The confirmation approves the sharpened outcome for 0000174 below. It is now the `## Wanted outcome` section of that entry.

| Entry | Wanted outcome and check |
|-------|--------------------------|
| 0000174 | The runner runs locally on request, never in CI, on the maintainer's Claude account. One command runs at least 3 fixed briefs and prints a score per brief. |

## Stop conditions

- A step prints `Blocked:` or `Question:`, or exits without merging after its resumes.
- CI fails on a step PR. `**Step CI fixes:**` is `stop`.
- A planned human stop in step 27 or step 30.
- A replay conflict at delivery that no admin fold clears.

## Schema changes

**Unpredicted additive changes:** stop

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1-30 | none | none | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1-29 | none | none | none |
| 30 | `langfuse` npm package | library | Send traces and scores from the evaluation runner |
| 30 | Langfuse web and worker images | service | Self-hosted Langfuse v3 in Docker Compose on the maintainer's machine |
| 30 | Postgres image | service | Langfuse v3 storage |
| 30 | ClickHouse image | service | Langfuse v3 trace storage |
| 30 | Redis image | service | Langfuse v3 queue and cache |
| 30 | MinIO image | service | Langfuse v3 blob storage |

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1-30 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`. If the command differs in any way, stop for the human. | none |
| 1-30 | The step PR conflicts after ship archived the run | Restore `design.md` and `build-log.md` from `plan/_archive/{feature-id}-{date}/` to `plan/current/`. Merge the initiative branch, log a `Rework:` line, push, and watch CI to green. Archive the run again, then write `ready`. | none |
| 1-30 | When to write `ready` | Only after `gh pr checks {n} --watch --fail-fast` shows every check passed on the PR head, and only after ship archived `plan/current/` | none |
| 1-30 | A test pins text that the step edits | Update the pin in the same step and log a `Rework:` line. After step 16 merges, log a `Pin update:` line instead when the plan names the suite. | none |
| 1-30 | Pack edits | Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`. A new test goes in both test trees. Run suites from the repo root. | none |
| 1-11 | Known baseline failures | `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh` fail in a clean clone. They are not new failures. Step 12 fixes them. | none |
| 1-30 | A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it | Log a `RED:` and a `GREEN:` line for the unit at the real time. Each line says the unit has no executable check. The `GREEN:` line names the check that passed. Never state a test run that did not happen. | none |
| 1-30 | A full local suite run passes the tool time limit | Run the suites for the files the step touches, with a background `timeout` of 7200000. Leave the full run to CI and say so in the P3 report. | none |
| 1-30 | `mktemp` fails or a suite workspace path is empty | Stop with a `Blocked:` line that names the suite. Never commit files that a suite wrote into the repo. | none |
| 3 | A conflict hunk is not a `Last updated:` line or rows that both sides added | The queue stops as it does now | none |
| 8 | The live probe fails on the installed Claude Code version | Ship the sandbox behind `RAVINTIO_STEP_SANDBOX=1`, off by default, and record the probe result in an ADR-0352 revision | none |
| 8 | The live probe needs a real push | Push a throwaway branch named `probe/{feature-id}` and delete it in the same run | none |
| 16 | Widening: `build-log-check.mjs` passes a `Pin update:` line with no postmortem (0000586) | Approved by the human on 2026-11-28. The check passes the line only when the plan names the pinned suite. Every `Rework:` line still needs a postmortem. | none |
| 26 | The style test finds many existing hits | Fix each hit that the step can test. List each other hit as reviewed with a reason. | none |
| 27 | Confirmation: model calls on the human's OpenAI account and the hand-made trust record (0000221) | Human stop: the step waits at P3 for the human to create the trust record and approve the run | none |
| 29 | Where the evaluation runner runs and who pays (0000174) | Locally on request, never in CI, on the maintainer's Claude account | none |
| 30 | Confirmation: Langfuse keys and model calls (0000254) | Human stop: the step waits at P3 for the human to set the keys and approve the run. Keys stay in the environment and out of every file and log. | none |

## Baselines

| Step | Target | Baseline | Source |
|------|--------|----------|--------|
| 1-30 | none | none | none |

## Criteria

| Step | Criterion | Noise and margin | Checked in |
|------|-----------|------------------|------------|
| 1-30 | The full suite passes apart from the known baseline failures | Known flaky: `test-0000169-req-003` and `test-0000040-req-002-003` under parallel shards | CI |
| 8 | The live probe reports push, `mktemp`, and blocked-write results | Depends on the installed Claude Code version | local |
| 21 | A step's P0 baseline with the named command ends in under 5 minutes | Run time varies with machine load. The margin is wide. | local |
| 27 | The Codex end-to-end test prints pass or fail for each check | Depends on the installed `codex`, 0.163.0 at chart | local |
| 30 | One Langfuse trace per brief, tagged with skill, commit, and model | none | local |

## P1 skips

| Step | Skip P1 | Reason |
|------|---------|--------|
| 1-30 | no | Every step changes a script, a skill with a test, or a test |

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status | Lane | After |
|------|------------|-------|-----------------|------|---------|--------|------|-------|
| 1 | 0000614-step-temp-variable | Step scratch uses RAVINTIO_STEP_TMP | 0000608 | minor | | pending | driver | |
| 2 | 0000615-queue-refuses-unarchived-plan | Queue refuses a step PR with plan/current | 0000607 | minor | | pending | queue | |
| 3 | 0000616-queue-resolves-living-docs | Queue resolves living doc conflicts | 0000598 | minor | | pending | queue | 2 |
| 4 | 0000617-build-log-marker-order | Build log check rejects out-of-order markers | 0000609 | minor | | pending | build-log | |
| 5 | 0000618-cleanup-keeps-dirty-worktrees | Cleanup keeps worktrees with unsaved work | 0000610 | minor | | pending | cleanup | |
| 6 | 0000619-activate-accepts-early-branch | Activation accepts an early initiative branch | 0000612 | minor | | pending | activate | |
| 7 | 0000620-scan-cause-anchor-edits | Plan scan cause for anchor edits | 0000606 | minor | | pending | scan | |
| 8 | 0000621-working-step-sandbox | Opt-in step sandbox tested live | 0000611 | minor | | pending | driver | 1 |
| 9 | 0000622-restart-refreshes-stale-worktree | Restarted step refreshes a stale worktree | 0000599 | minor | | pending | driver | 8 |
| 10 | 0000623-seven-digit-adr-collisions | ID collisions accept seven-digit ADR ids | 0000600 | minor | | pending | queue | 3 |
| 11 | 0000624-setup-ignores-initiative-ack | Setup ignores the initiative ack in consumers | 0000604 | minor | | pending | setup | |
| 12 | 0000625-clean-clone-suite-gaps | Clean-clone suites set up what they need | 0000585 | minor | | pending | suites | |
| 13 | 0000626-background-suite-timeout | Background suite runs pass a long timeout | 0000601 | minor | | pending | p0-text | |
| 14 | 0000627-plan-names-both-test-trees | Plan lists both test trees for a new test | 0000590, 0000596 | minor | | pending | scan | 7 |
| 15 | 0000628-scan-cause-renumbered-list | Plan scan cause for a renumbered list | 0000594 | minor | | pending | scan | 14 |
| 16 | 0000629-pin-update-marker | Pin update marker needs no postmortem | 0000586 | minor | | pending | build-log | 4 |
| 17 | 0000630-marker-insert-position | Marker script inserts inside the phase block | 0000593 | minor | | pending | build-log | 16 |
| 18 | 0000631-sentinel-own-call | P0 writes the sentinel in its own call | 0000587 | minor | | pending | p0-text | 13 |
| 19 | 0000632-design-first-root-paths | P0 writes design.md first with root paths | 0000588 | minor | | pending | p0-text | 18 |
| 20 | 0000633-monitor-expiry-rearm | Name the monitor expiry and re-arm | 0000591 | minor | | pending | p0-text | 19 |
| 21 | 0000634-fast-baseline-command | Named fast baseline command | 0000603 | minor | | pending | p0-text | 20 |
| 22 | 0000635-commit-p3-reports | Commit P3 reports as each one lands | 0000595 | minor | | pending | p0-text | 21 |
| 23 | 0000636-ship-literal-add-paths | Ship archive writes literal git add paths | 0000589 | minor | | pending | ship | |
| 24 | 0000637-empty-input-criterion | Empty-input prompt in the requirement template | 0000602 | minor | | pending | template | |
| 25 | 0000638-refuse-boot-file-link | Setup refuses a link at a boot file path | 0000592 | minor | | pending | setup | 11 |
| 26 | 0000639-grep-q-pipefail-check | Style test for grep -q under pipefail | 0000597 | minor | | pending | alone | 1-25 |
| 27 | 0000640-codex-end-to-end-test | Codex end-to-end setup test | 0000221 | minor | | pending | setup | 26 |
| 28 | 0000641-local-web-console | Optional local web console | 0000605 | minor | | pending | console | 26 |
| 29 | 0000642-skill-evaluation-suite | Skill evaluation suite | 0000174 | minor | | pending | eval | 26 |
| 30 | 0000643-langfuse-skill-evaluation | Langfuse skill evaluation | 0000254 | minor | | pending | eval | 29 |

## Merges

The merge queue adds one row for each step it merges. See the merge queue section of the roadmap standards.

| Step | PR | Merge commit | Version | Merged at |
|------|----|--------------|---------|-----------|
