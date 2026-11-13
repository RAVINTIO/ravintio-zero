---
title: "Postmortem: 2026-11-08 - tests pinned lines that the step edited"
summary: "Three suites failed on lines the step edited, and the plan's test impact scan did not list them."
status: "open"
---
# Postmortem: 2026-11-08 - tests pinned lines that the step edited

> Path: `plan/postmortems/2026-11-08-step-16-tests-pinned-edited-lines.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000392-ship-postmortems
**Date:** 2026-11-08

## Summary

The first full suite run failed three suites. Each pinned a line the step had edited. The fix kept the pinned wording and cost one extra full run.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-08 | The step edited resume-detection item 9 and the ship title sentence | commit 21927f2f |
| 2026-11-08 | The full suite reported 3 failed suites | `test-0000151-req-011`, `test-0000243-req-005`, `test-0000351-req-001-004` |
| 2026-11-08 | The step restored the pinned wording and the suite passed | commit after 21927f2f, 306 passed |

First missed chance to catch it: the P1 test impact scan could have listed these suites.

## 5 whys

1. The full suite failed three suites.
2. The suites compare whole lines of item 9 and a title form, and the step changed both.
3. The test impact scan greps for skill counts, caps, ids, and workflow edits only.
4. The scan has no cause for editing a line that a suite compares line by line.
5. The scan does not search the tests for the text of a line the plan edits.

**Gap:** The test impact scan has no cause for an edit to an existing line of a skill or reference file.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Restore the pinned wording of item 9 and the title form, and add the new rules as separate bullets | done | step 16 | `ravintio-zero/skills/` | full suite, 306 passed | commit fix(0000392) keep pinned lines |
| preventive | none, because backlog 0000361 to 0000363 in step 7 already add test impact causes for edited lines | none | | | | |
| detective | none, because the full suite caught it before the PR | none | | | | |
