---
title: "Retrospective: 2026-11-07 - Test helpers and rule anchors"
summary: "A blameless review of step 4 of initiative 0000360, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-07 - Test helpers and rule anchors

> Path: `plan/retrospectives/0000380-test-helpers-and-rule-anchors-2026-11-07.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000380-test-helpers-and-rule-anchors
**Date:** 2026-11-07

## Summary

The step shipped three test helpers, 72 rule anchors, and 16 converted suites with no block and no rework loop. The full Bash suite passed (302 feature, 19 regression).

## What helped

- Three parallel subagents converted 16 suites against a written helper contract, with no conflicting edits (build log `Parallel task batches: 1`).
- Test fixtures for the helpers (`test-0000380-req-001`, `-002`) let the helper design change early without touching real skills.

## What slowed the work

- Anchoring numbered steps broke 8 suites that match step lines by regex. The plan's test impact scan has no cause for reformatting skill lines (`execution-plan.md`, `## Test impact`).
- The first `rule_text` treated anchor mentions in docs as anchors, so the anchor suite failed until the match required a line start (commit "Add test helpers for sections, rules and timeouts").
- Phase blocks for P1 to P3 were written at phase end, so their wall clock reads 0 (`build-log.md`, P1 to P3 blocks).

## Keep

- Write helper tests with fixture pack folders (`ORCH_PACK_ROOT`, `RULE_PACK_ROOT`), so a move or a delete is testable without editing the real pack (`tests/test-0000380-req-002-rule-anchors.sh`).

## Change

- Record each phase start time when the phase begins (`plan/backlog/0000402-phase-start-time-at-phase-start/entry.md`).
- Convert the remaining suites that pin whole sentences (`plan/backlog/0000401-convert-remaining-suites-to-rule-anchors/entry.md`).
- Step 7 extends the test impact scan (0000361). It should name skill-line reformatting as a cause.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Phase start time recorded at phase start | pack maintainers | `scripts/build-log-check.mjs` | A test of the check | 0000402 |
| Convert remaining suites | pack maintainers | `ravintio-zero/tests/` | The full suite after a reword | 0000401 |
| Add skill-line reformatting to the test impact scan | step 7 | `skills/ravintio-plan/SKILL.md` | Step 7 suite | raised for step 7 (0000361) |
