---
title: "Initiative: 0000544 - priority backlog"
summary: "Builds 39 open backlog entries in 36 steps, in the priority order the human set on 2026-11-14, four at a time."
status: "charted"  # proposed | charted | active | delivered | blocked
---
# Initiative: 0000544 - priority backlog

**Goal:** Build the open backlog as fast as possible, top priority first. Queue and run blockers come first, then coordinator oversight, then the test impact scan, then test and pipeline upkeep.

**Branch:** initiative/0000544-priority-backlog

**Status:** charted

**Position:** 1

**Speed:** fast

**Step CI fixes:** allowed

**Concurrency:** 4

The human chose on 2026-11-14 to leave out 0000174, 0000220, 0000221, and 0000254. Each needs a paid service, an account, or a human partway through a step.

## Chart answers

The human confirmed the chart on 2026-11-14 with "build the initiative as fast as possible. go".

- The confirmation approves the sharpened outcomes below. Each one is now the `## Wanted outcome` section of its entry. The coordinator closed entry 0000513, because 0000536 covers it.
- The confirmation approves no guard widening. The coordinator cut back each possible widening to a fix that widens nothing, in `## Decisions`.
- "As fast as possible" sets `**Speed:** fast` and `**Concurrency:** 4`. Lanes keep steps that share files in order.

| Entry | Wanted outcome and check |
|-------|--------------------------|
| 0000418 | The plan scan has a `Prose rewrite` cause that greps the tests for each changed sentence. A test checks that the plan skill names the cause. |
| 0000419 | The plan scan has a `Path move` cause covering `$ZERO_DIR/..`, `SCRIPT_DIR/../..`, and path-keyed state files. A test checks for the cause. |
| 0000513 | Strike it. 0000536 shipped the rule that a pending migration never stops a step. Step 16 checks whatever remains with 0000403. |
| 0000515 | Take the second option. `baseline-failures.mjs check` exits 1 with "no baseline recorded" when the file is missing. A test covers the missing-file case. |
| 0000517 | I-D Advance says to run `backlog-index.mjs` after a manual base merge, and it names the CI check that fails otherwise. A standards test checks the line. |
| 0000523 | The plan scan has a `Hook change` cause covering the four grep targets the entry lists. A test checks for the cause. |
| 0000529 | The plan skill has a step that lists every path producing a pass signal, including launcher failures. A test checks for the step. |
| 0000530 | The initiative skill relays watcher activity only at phase events, blocks, and stops. The coordinator reads step test output only after a stop. A test checks the skill text. The chart drops the OpenTelemetry baseline, because that data lives outside the repo. |
| 0000532 | The P0 start actions and `ravintio-validate-and-accept` say to wait on the end marker or the returned process id. A test checks that no skill or standard tells a session to wait with `pgrep -f`. |
| 0000533 | The plan scan has an `Output order` cause that lists suites reading changed lines or the last line. A test checks for the cause. |
| 0000540 | The plan scan has a `Pack file edit` cause that lists `test-0000493-req-004-handoff-text.sh`. P0 lists `src/ravintio-zero/` in `## Component Paths`. A test checks both. |

## Stop conditions

- A step prints `Blocked:` or `Question:`, or exits without merging after its resumes.
- CI fails twice on one step PR after the step's own fix.
- A replay conflict at delivery that no admin fold clears.

## Schema changes

**Unpredicted additive changes:** stop

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1-36 | none | none | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1-36 | none | none | none |

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1-36 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`. If the command differs in any way, stop for the human. | none |
| 1-36 | The step PR fails CI or conflicts after ship archived the run | Restore `design.md` and `build-log.md` from `plan/_archive/{feature-id}-{date}/` to `plan/current/`. Fix the check or merge the initiative branch, log a `Rework:` line, push, and watch CI to green. Archive the run again, then write `ready`. | none |
| 1-36 | When to write `ready` | Only after `gh pr checks {n} --watch --fail-fast` shows every check passed on the PR head | none |
| 1-36 | A test pins text that the step edits | Update the pin in the same step and log a `Rework:` line | none |
| 1-36 | Pack edits | Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`. Run suites from the repo root. | none |
| 1-36 | Known baseline failures | `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh` fail on the base. They are not new failures. | none |
| 1 | Fix for 0000514 | Ship Step 8 deletes `plan/.feature-id` for an initiative step, and `shared-files.mjs` also resolves it at a base merge. Delete the tracked file from the initiative branch. | none |
| 2 | How much the queue may reset (0000477) | Reset only the version files that the failed run wrote, and only in the queue worktree | none |
| 18 | The plan skill nears its size cap | Move the Test impact scan causes to `skills/ravintio-plan/references/test-impact-causes.md` with a Pack Index row, before adding a cause. Steps 19 to 27 add causes there. | none |
| 16 | 0000403 and the 0000536 rule | Keep the `not applicable` rule in `resume-detect.mjs`. Close what 0000536 already covers, and build only the remaining gap. | none |
| 4 | Guard cut-back: the `run-tests.sh` tree check (0000476, ack write) | Never exempt `plan/.orchestrator-ack` from the tree check. Fix the cause instead: the strict hook does not ask a step session for an ack while its suite runs, or the session writes the ack before the suite starts. | none |
| 14 | Guard cut-back: CI on a plan-only push (0000476) | Every push still runs every suite. The step may cancel a superseded run on the same PR and may avoid an extra push, but skips no suite. | none |
| 17 | Guard cut-back: the old-name guard (0000527) | Keep the allowlist as it is. Make the guard read a stable copy of the tree, or fix the earlier suite that changes it. | none |
| 36 | Guard cut-back: `build-log-check.mjs` (0000410) | Every unit still logs `RED:` and `GREEN:`. The step records the class next to the markers and relaxes no check. | none |
| 35 | Rule anchors touch most tests (0000401) | Step 35 runs after steps 1 to 34, and step 36 runs after it | none |
| 1-36 | Fast batches | `**Speed:** fast`. Each phase dispatches its listed fast batch. Every gate and exception stop stays. | none |

## Baselines

| Step | Target | Baseline | Source |
|------|--------|----------|--------|
| 1-36 | none | none | none |

## Criteria

| Step | Criterion | Noise and margin | Checked in |
|------|-----------|------------------|------------|
| 14 | A plan-only push runs fewer suites | Count of jobs, no noise | CI |
| 1-36 | The full suite passes apart from the known baseline failures | Known flaky: `test-0000169-req-003` and `test-0000040-req-002-003` under parallel shards | local |

## P1 skips

| Step | Skip P1 | Reason |
|------|---------|--------|
| 1 | no | The step changes a script, a skill with a test, or a test |
| 2 | no | The step changes a script, a skill with a test, or a test |
| 3 | no | The step changes a script, a skill with a test, or a test |
| 4 | no | The step changes a script, a skill with a test, or a test |
| 5 | no | The step changes a script, a skill with a test, or a test |
| 6 | no | The step changes a script, a skill with a test, or a test |
| 7 | no | The step changes a script, a skill with a test, or a test |
| 8 | no | The step changes a script, a skill with a test, or a test |
| 9 | no | The step changes a script, a skill with a test, or a test |
| 10 | no | The step changes a script, a skill with a test, or a test |
| 11 | no | The step changes a script, a skill with a test, or a test |
| 12 | no | The step changes a script, a skill with a test, or a test |
| 13 | no | The step changes a script, a skill with a test, or a test |
| 14 | no | The step changes a script, a skill with a test, or a test |
| 15 | no | The step changes a script, a skill with a test, or a test |
| 16 | no | The step changes a script, a skill with a test, or a test |
| 17 | no | The step changes a script, a skill with a test, or a test |
| 18 | no | The step changes a script, a skill with a test, or a test |
| 19 | no | The step changes a script, a skill with a test, or a test |
| 20 | no | The step changes a script, a skill with a test, or a test |
| 21 | no | The step changes a script, a skill with a test, or a test |
| 22 | no | The step changes a script, a skill with a test, or a test |
| 23 | no | The step changes a script, a skill with a test, or a test |
| 24 | no | The step changes a script, a skill with a test, or a test |
| 25 | no | The step changes a script, a skill with a test, or a test |
| 26 | no | The step changes a script, a skill with a test, or a test |
| 27 | no | The step changes a script, a skill with a test, or a test |
| 28 | no | The step changes a script, a skill with a test, or a test |
| 29 | no | The step changes a script, a skill with a test, or a test |
| 30 | no | The step changes a script, a skill with a test, or a test |
| 31 | no | The step changes a script, a skill with a test, or a test |
| 32 | no | The step changes a script, a skill with a test, or a test |
| 33 | no | The step changes a script, a skill with a test, or a test |
| 34 | no | The step changes a script, a skill with a test, or a test |
| 35 | no | The step changes a script, a skill with a test, or a test |
| 36 | no | The step changes a script, a skill with a test, or a test |

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status | Lane | After |
|------|------------|-------|-----------------|------|---------|--------|------|-------|
| 1 | 0000545-clear-feature-id-at-ship | Ship leaves plan/.feature-id behind | 0000514 | minor | | pending | queue |  |
| 2 | 0000546-queue-failure-leaves-dirty-files | A failed queue run can leave written files in the queue worktree | 0000477 | minor | | pending | queue |  |
| 3 | 0000547-step-merge-regenerates-index | Step base merge regenerates the backlog index | 0000517 | minor | | pending | coord |  |
| 4 | 0000548-ack-write-mid-suite-fails-run | Strict-mode ack write mid-suite fails the suite run | 0000476-ack-write-mid-suite-fails-run | minor | | pending | tests |  |
| 5 | 0000549-baseline-record-checks | Baseline record checks its input and its file | 0000525, 0000515 | minor | | pending | baseline |  |
| 6 | 0000550-no-head-diffs-in-tests | No HEAD diffs in tests | 0000416 | minor | | pending | tests |  |
| 7 | 0000551-refuse-symlink-style-outputs | Refuse a symlink at the writing style output paths | 0000408 | minor | | pending | setup |  |
| 8 | 0000552-duplicate-backlog-ids | Two open entries share one backlog id | 0000542 | minor | | pending | queue |  |
| 9 | 0000553-coordinator-oversight-not-micromanagement | Initiative skills do not micromanage | 0000530 | minor | | pending | coord |  |
| 10 | 0000554-coordinator-starts-defined-stages | Coordinator starts a defined stage without asking | 0000541 | minor | | pending | coord |  |
| 11 | 0000555-initiative-pause-reaches-every-step | Initiative pause reaches every step | 0000538 | minor | | pending | coord |  |
| 12 | 0000556-step-session-finds-unfinished-step | A step session finds an unfinished step | 0000531 | minor | | pending | resume |  |
| 13 | 0000557-self-matching-pgrep-wait | Step sessions wait on a suite without matching their own shell | 0000532 | minor | | pending | baseline |  |
| 14 | 0000558-plan-only-push-short-ci | CI avoids extra runs on a plan-only push | 0000476-plan-only-push-short-ci | minor | | pending | ci |  |
| 15 | 0000559-start-baseline-first | Start the baseline run before the P0 artifacts | 0000478 | minor | | pending | baseline |  |
| 16 | 0000560-step-sessions-and-pending-migrations | Step sessions meet pending migrations | 0000403 | minor | | pending | resume |  |
| 17 | 0000561-old-name-guard-fails-in-full-suite | Old-name guard fails in the full suite | 0000527 | minor | | pending | tests |  |
| 18 | 0000562-test-impact-scan-lists-the-mirrored-pack-tree | Test impact scan lists the mirrored pack tree | 0000540 | minor | | pending | plan |  |
| 19 | 0000563-test-impact-misses-output-readers | Plan test impact misses suites that read driver output order | 0000533 | minor | | pending | plan |  |
| 20 | 0000564-test-impact-hook-pins | Test impact scan names hook pins | 0000523 | minor | | pending | plan |  |
| 21 | 0000565-layout-move-test-impact | Test impact scan for layout moves | 0000419 | minor | | pending | plan |  |
| 22 | 0000566-test-impact-for-history-moves | Test impact scan misses suites that scan live files | 0000405 | minor | | pending | plan |  |
| 23 | 0000567-test-impact-size-caps-and-frozen-lines | Test impact scan covers size caps and frozen lines | 0000406, 0000526 | minor | | pending | plan |  |
| 24 | 0000568-wording-pin-scan | Scan for wording pins before a prose rewrite | 0000418 | minor | | pending | plan |  |
| 25 | 0000569-scan-new-pack-files-for-wording-allowlist | Scan new pack files for the wording allowlist | 0000415 | minor | | pending | plan |  |
| 26 | 0000570-sibling-test-copies-in-impact-scan | List sibling copies of a pinned test in the impact scan | 0000407 | minor | | pending | plan |  |
| 27 | 0000571-scan-cause-skill-wide-grep-pins | Test impact scan covers skill-wide grep pins | 0000404 | minor | | pending | plan |  |
| 28 | 0000572-tests-share-a-repo-root-helper | Tests share a repo-root helper for both pack trees | 0000528, 0000539 | minor | | pending | tests |  |
| 29 | 0000573-require-unit-reports | Require unit reports | 0000417 | minor | | pending | dispatch |  |
| 30 | 0000574-delivery-pr-lists-steps-in-version-order | Delivery PR lists steps in version order | 0000543 | minor | | pending | coord |  |
| 31 | 0000575-build-log-marker-helper | Build log marker helper | 0000524 | minor | | pending | dispatch |  |
| 32 | 0000576-phase-start-time-at-phase-start | Record each phase start time when the phase begins | 0000402 | minor | | pending | dispatch |  |
| 33 | 0000577-plan-lists-change-shapes | Plan lists the change shapes a diff reader must handle | 0000516 | minor | | pending | plan |  |
| 34 | 0000578-plan-lists-pass-signals | Plan lists every way a check can pass | 0000529 | minor | | pending | plan |  |
| 35 | 0000579-convert-remaining-suites-to-rule-anchors | Convert remaining suites to rule anchors | 0000401 | minor | | pending | anchors | 1-34 |
| 36 | 0000580-log-non-tdd-units | Log a non-TDD unit with a class | 0000410 | minor | | pending | anchors | 35 |

## Merges

The merge queue adds one row for each step it merges. See the merge queue section of the roadmap standards.

| Step | PR | Merge commit | Version | Merged at |
|------|----|--------------|---------|-----------|
