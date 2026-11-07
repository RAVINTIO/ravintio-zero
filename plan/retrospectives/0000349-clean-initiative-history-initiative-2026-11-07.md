---
title: "Retrospective: 2026-11-07 - clean initiative history"
summary: "A blameless review of initiative 0000349, which shipped 8 steps as 0.49.0 to 0.56.0, and the changes it files."
status: "open"  # open | closed
---
# Retrospective: 2026-11-07 - clean initiative history

> Path: `plan/retrospectives/0000349-clean-initiative-history-initiative-2026-11-07.md`. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool.

**Mode:** initiative
**Subject:** 0000349-clean-initiative-history
**Date:** 2026-11-07

## Summary

All 8 charted steps shipped as minor bumps, `0.49.0` to `0.56.0`, and 22 of 22 charted backlog entries closed. Each step ran P0 to P4 without a human in the session. The run had one planned human stop, a setup stop after each of steps 5 to 7, and one long wait between steps 6 and 7.

## What helped

- Setup stops were routine. The coordinator ran the one approved command from the chart's `Confirmation:` row and checked all 12 hooks each time. (chart `## Decisions` row "Confirmation: setup rerun at each `Setup:` stop")
- Step 4 let steps run to the end, so steps 5 to 8 committed the build report, retrospective, version, and tag inside the step PR. (`plan/_archive/0000354-steps-run-to-the-end-2026-11-06/`)
- The P3 probes in step 6 found two defects in the new forced-add guard before the PR. (`plan/_archive/0000357-guard-gaps-closed-2026-11-06/build-log.md`, `Rework: REQ-002`)
- The test runner from step 7 names each failed suite under the totals. In step 8 and at delivery, that name led straight to the cause. (`plan/_archive/0000358-clean-step-stops-and-logs-2026-11-07/`)
- The step 6 forced-add guard blocked the coordinator's own `git add` of a variable path at delivery, as designed.

## What slowed the work

- Tests that pin pack text caused rework in 6 of 8 steps. Each step lost at least one full suite run. (`Rework:` lines in the build logs of 0000351, 0000352, 0000354, 0000355, 0000357, and 0000358)
- A step that changed the tree while its own suite ran got a false failure. This happened in step 6 (`verification-report.md` written mid-run) and step 8 (commit `b1f7fc2` made mid-run).
- Phase times were typed by hand in steps 5 and 6, and two were set in the future before the step corrected them. (`0000357` build log, P0 and P3 corrections)
- The P4 version bump in step 5 missed `ravintio-zero/component.yml`, and CI on PR #115 failed once. (commit `f0c9610`)

## Initiative questions

1. **Charted versus shipped.** All 8 steps shipped in chart order, each as a minor bump, at the charted versions `0.49.0` to `0.56.0`. Steps 1 to 4 squashed with the charted title form `{feature-id}: {Title}`. Steps 5 to 8 squashed with the slug in the title, so `check-initiative-history.mjs` reported them missing until the reshape rewrote the titles from the chart.
2. **Repeated friction.** The repeats were fixture and text pins in tests (6 steps), tree changes during a suite run (2 steps), and guards that read the text of a heredoc as a command (steps 6 and 8).
3. **Stops and step times.**

   | Step | Feature | Start | Merged | Time | Stops |
   |------|---------|-------|--------|------|-------|
   | 1 | 0000351 | 2026-11-05T23:51:38Z | 2026-11-06T00:28:27Z | 37 min | not in the archive |
   | 2 | 0000352 | 2026-11-06T00:30:45Z | 2026-11-06T01:26:11Z | 55 min | not in the archive |
   | 3 | 0000353 | 2026-11-06T01:28:32Z | 2026-11-06T01:51:46Z | 23 min | not in the archive |
   | 4 | 0000354 | 2026-11-06T01:54:30Z | 2026-11-06T02:29:24Z | 35 min | not in the archive |
   | 5 | 0000355 | 2026-11-06T02:31:13Z | 2026-11-06T08:22:23Z | 5 h 51 min | Blocked for 5 h 4 min, then Setup |
   | 6 | 0000357 | 2026-11-06T08:25:57Z | 2026-11-06T09:30:00Z | 64 min | Setup |
   | 7 | 0000358 | 2026-11-07T05:01:09Z | 2026-11-07T05:54:10Z | 53 min | Setup |
   | 8 | 0000359 | 2026-11-07T06:04:08Z | 2026-11-07T06:38:56Z | 35 min | none |

   The step 5 stop was planned. CodeQL default setup was on, and the advanced workflow can't upload while it is. It ended when the human turned default setup off (`Resolved:` line, 2026-11-06T08:04:56Z). Between steps 6 and 7, the driver stayed stopped for about 19 hours while human decisions on two backlog entries were open.
4. **Tooling gaps.**
   - The driver acts on `Blocked:` only. Step 7 moved the product id stop to `Question:`, which the driver would resume twice. (0000370)
   - The driver printed no `Setup:` line after step 8, which changed skills. The first delivery suite run failed until setup ran again. (0000373)
   - No check compares a step PR title with the chart before the merge. (0000372)
   - The forced-add guard from step 6 misreads git option values and brace groups. (0000367)

## Keep

- The `Confirmation:` row with the exact setup command. It let every setup stop end without a question. (chart `## Decisions`)
- P3 probes that run a guard against hostile input, as step 6 did. (`plan/_archive/0000357-guard-gaps-closed-2026-11-06/security-report.md`, S-003)

## Change

- Check each step PR title against the chart before the merge. (0000372)
- Make the driver stop on `Question:` and check for a setup stop after the last step. (0000370, 0000373)
- Find text pins in the P1 test impact scan. (0000369, with 0000361, 0000362, and 0000363)

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Check a step PR title against the chart before the merge | ravintio-ship | `ravintio-zero/skills/ravintio-ship/SKILL.md` | a test with a slug title | 0000372 |
| Driver checks for a setup stop after the last step | initiative driver | `ravintio-zero/scripts/initiative-run.mjs` | a driver test | 0000373 |
| Driver stops on `Question:` | initiative driver | `ravintio-zero/scripts/initiative-run.mjs` | a driver test | 0000370 |
| Forced-add guard reads option values and brace groups | guards | `ravintio-zero/hooks/enforcement/block-forced-add.mjs` | a test per form | 0000367 |
| Version check after the P4 bump | ravintio-ship | `ravintio-zero/skills/ravintio-ship/SKILL.md` | a ship test | 0000368 |
| Test impact scan finds fixture and text pins | ravintio-plan | `ravintio-zero/skills/ravintio-plan/SKILL.md` | a plan skill test | 0000369 |
