---
title: "Retrospective: 2026-10-31 - isolated test state"
summary: "A blameless review of step 3 of initiative 0000312."
status: "open"
---
# Retrospective: 2026-10-31 - isolated test state

> Path: `plan/retrospectives/0000315-isolated-test-state-2026-10-31.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000315-isolated-test-state
**Date:** 2026-10-31

## Summary

Both runners now clear `RAVINTIO_` variables for each suite and fail the run when the tree changes. `test-0000164-req-007` reads the file that holds the rules. The step ran from P0 to P4 with no stop and two self-corrections.

## What helped

- The step 2 retrospective said to take phase times from the clock, so the build log carries commit-based times (`build-log.md`).
- The suite ran under `RAVINTIO_INITIATIVE_STEP=1`, so P3 observed the fix in the session that had the original leak (`verification-report.md`).
- Existing probe-suite tests for 0000251 gave a pattern for the new runner tests (`test-0000251-req-001-runners-clear-step-variable.sh`).

## What slowed the work

- The first full run took about four minutes and then failed on `test-0000164-req-008`. The runner used process substitution, which that guard bans (`build-log.md`, P2).
- Clearing `RAVINTIO_TEST_QUIET` broke `test-0000151-req-008`, because `assert.sh` reads it. The plan listed the keep set before anyone searched `tests/helpers/`.
- I wrote placeholder phase times in the first build-log draft and corrected them from commit timestamps at ship (`build-log.md`).

## Keep

- Test a runner change in a temporary tests folder with probe suites, so the proof does not depend on the real suite (`test-0000315-req-001-runners-clear-environment.sh`).
- Run the tree check on every full run, so a suite that writes repo state fails at once (`ravintio-zero/tests/run-tests.sh`).

## Change

- Search `tests/helpers/` for each variable a runner change touches, before the plan fixes the keep set.
- Run the guard suites that name a file after each edit to it, not only the full run.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Search helpers for each variable before the plan fixes a keep set | pack maintainer | `.claude/skills/ravintio-plan/SKILL.md` test impact scan | a plan review | none filed. Raise it if the miss recurs. |
| Placeholder phase times in the build log | pack maintainer | orchestrator P0 start actions | `build-log-check.mjs` at ship | none filed. Same item as the step 2 retrospective. |
