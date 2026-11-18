---
title: "Retrospective: 2026-11-18 - Phase start time check"
summary: "A blameless review of the 0000576 run and the changes it files."
status: "open"
---
# Retrospective: 2026-11-18 - Phase start time check

**Mode:** run
**Subject:** 0000576-phase-start-time-at-phase-start
**Date:** 2026-11-18

## Summary

Check 10 of `build-log-check.mjs` now fails a phase block that starts after its first artifact commit. The run passed P3 with no self-correction cycle, and one CI failure came after the PR opened.

## What helped

- The plan listed the test impact per unit, so no existing suite broke (`plan/_archive/0000576-phase-start-time-at-phase-start-2026-11-18/execution-plan.md`).
- `baseline-failures.mjs check` separated the three inherited suites from new failures in one command (build log, P3).

## What slowed the work

- The first full-suite run hit the 10-minute background limit before it printed a summary. The agent reran it for about 25 minutes (build log, P3 block).
- The session paused for two days between P2 and P3. The P2 wall clock needed the last commit time as its `End` (build log, P2 block).
- The two new tests existed in `ravintio-zero/tests/` only. `sync-installed.mjs --check` failed the `validate-branch` job on PR 246.

## Keep

- Run `baseline-failures.mjs check` on the full-suite output (build log, P3).

## Change

- The plan skill lists the `src/ravintio-zero/tests/` copy of each new test. The check passed locally only after the copy existed (PR 246, `validate-branch` log).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| List the source-tree copy of each new test in the plan | plan skill | `src/ravintio-zero/skills/ravintio-plan/` | A test on the skill wording | `plan/backlog/0000596-plan-lists-source-tree-test-copy/entry.md`, from this retrospective |
