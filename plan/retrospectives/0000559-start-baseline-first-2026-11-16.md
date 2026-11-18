---
title: "Retrospective: 2026-11-16 - Baseline run first in P0"
summary: "A blameless review of step 15, which moved the baseline run ahead of the P0 artifacts."
status: "open"
---
# Retrospective: 2026-11-16 - Baseline run first in P0

**Mode:** run
**Subject:** 0000559-start-baseline-first
**Date:** 2026-11-16

## Summary

The step moved the decision rows and the baseline run to follow the pre-flight and renumbered the later actions. The clean-clone run passed apart from the three inherited suites. The baseline finished before P3, so P3 did not wait on it.

## What helped

- The baseline started at 05:33:50Z and finished before P3 began at 05:57Z (plan/_archive/0000559-start-baseline-first-2026-11-16/build-log.md, P0 and P3 blocks).
- Rule anchors let most suites survive the renumbering (plan/_archive/0000559-start-baseline-first-2026-11-16/execution-plan.md, Test impact).

## What slowed the work

- Two suites pinned action numbers. The plan missed them and P2 found them (plan/postmortems/2026-11-16-pin-update-after-renumbering-logged-as-rework.md).
- The sentinel guard blocked one command that wrote the sentinel with other plan files.

## Keep

- Start the baseline in the background before any artifact work (plan/_archive/0000559-start-baseline-first-2026-11-16/build-report.md, Parallelism).

## Change

- Name renumbered lists in the test impact scan (plan/backlog/0000594-scan-cause-for-renumbered-list/entry.md).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Add a `Renumbered list` cause to the scan | the coordinator | `ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` | a test that reads the cause | 0000594 |
