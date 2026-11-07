---
title: "Backlog Entry: 0000369 - the test impact scan covers lines that fixtures pin"
summary: "A retrospective finding, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000369 - the test impact scan covers lines that fixtures pin

**Source feature:** 0000358-clean-step-stops-and-logs
**Source phase:** P2
**Deferral source:** retrospective `plan/retrospectives/0000358-clean-step-stops-and-logs-2026-11-07.md`
**Date filed:** 2026-11-07

---

## Problem

Step 7 edited the orchestrator skill, and `test-0000151-req-011-orchestrator-references-split.sh` failed twice. The test compares every line of a base fixture with the current skill, so it pins the status line, the product id line, and hard limit 9. The plan's test impact scan greps for skill names and caps, but it does not grep for lines that a fixture holds. Each failure cost a full suite run of about 5 minutes (`build-log.md`, P2 `Rework:` lines).

## Suggested Action

- Add a cause to the `## Test impact scan` in `ravintio-plan`: the run edits an existing line in a pack file that a fixture under `ravintio-zero/tests/fixtures/` holds. The scan greps the fixture for the line.
- Tell P2 to run the suites the plan names before it runs the full suite.

## Wanted outcome

The plan lists a fixture-pinned line in `## Test impact` before P2 edits it. A test checks that the plan skill names the fixture cause.

## Why Deferred

The fix edits the plan skill and needs its own design and tests.
