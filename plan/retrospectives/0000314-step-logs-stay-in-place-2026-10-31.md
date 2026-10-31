---
title: "Retrospective: 2026-10-31 - step logs stay in place"
summary: "A blameless review of step 2 of initiative 0000312."
status: "open"
---
# Retrospective: 2026-10-31 - step logs stay in place

> Path: `plan/retrospectives/0000314-step-logs-stay-in-place-2026-10-31.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000314-step-logs-stay-in-place
**Date:** 2026-10-31

## Summary

The phase guard now skips the git-ignored step logs, and the orchestrator skill, initiative skill, and roadmap standards tell a step to leave driver files alone. The step ran from P0 to P4 with no stop and no self-correction.

## What helped

- The chart row for step 2 named the fix ("skip `plan/.initiative-logs/` only"), so P1 had no fork (`initiative.md`, `## Decisions`).
- RED then GREEN for the guard took two runs, because the new cases sit beside the guard function (`test-0000042-req-006`, section (d)).
- The live tree held 18 real step logs, so P3 observed the fix against real data (`verification-report.md`).

## What slowed the work

- I wrote estimated phase times into the build log and corrected them at ship (`build-log.md`).
- One commit subject ran to 74 characters and the `commit-msg` hook blocked it. The chained shell command then skipped a file write, which I found on the next run.
- The full suite still fails `test-0000164-req-007`, so P3 needed an explanation again (`acceptance-evidence.md`).

## Keep

- Put new guard cases beside the guard function, so one file proves both sides.
- Name the planted-cite check after the folder it skips, so a lookalike path is still scanned.

## Change

- Take phase times from `date -u` at each boundary, not from an estimate (`build-log.md`).
- Keep commit subjects under 72 characters by writing them before the command, and run commits apart from file writes.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Fix the stale generated `CLAUDE.md` read | initiative 0000312 step 3 | `ravintio-zero/tests/test-0000164-req-007*.sh` | the suite | entry 0000267, already in step 3 |
| Real phase times in the build log | pack maintainer | orchestrator P0 start actions | `build-log-check.mjs` at ship | none filed. Raise it if the estimate recurs. |
