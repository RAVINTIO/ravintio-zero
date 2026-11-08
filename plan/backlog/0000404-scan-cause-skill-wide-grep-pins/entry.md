---
title: "Backlog Entry: 0000404 - test impact scan covers skill-wide grep pins"
summary: "A retrospective finding: a new file name in a skill tripped a test that greps every skill."
status: "open"
priority: "low"
theme: "pipeline-checks"
---
# Backlog Entry: 0000404 - test impact scan covers skill-wide grep pins

**Source feature:** 0000383-test-impact-scan
**Source phase:** P2
**Deferral source:** retrospective `plan/retrospectives/0000383-test-impact-scan-2026-11-07.md`
**Date filed:** 2026-11-07

---

## Problem

Step 7 added the file name `run-tests.sh` to the plan skill. `test-0000151-req-008-quiet-test-output.sh` greps every `SKILL.md` for `run-tests` and requires a quiet-mode command on that line, so it failed in the full suite. It cost one rework cycle (`build-log.md`, P2 `Rework:` line).

## Suggested Action

Add a cause to the `## Test impact scan` in `ravintio-plan`: the run adds a file name, command, or flag to a `SKILL.md`. The scan greps `ravintio-zero/tests/` for tests that loop over every skill and match that term.

## Wanted outcome

The plan lists the skill-wide pin in `## Test impact` before P2 edits the skill. A test checks that the plan skill names the cause.

## Why Deferred

Step 7 had already closed its scope. The edit needs its own test.
