---
title: "Backlog Entry: 0000269 - the test runner lists the failing suites by name"
summary: "A retrospective finding, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000269 - the test runner lists the failing suites by name

**Source feature:** none (initiative 0000238 retrospective)
**Source phase:** none (I-E Delivery)
**Deferral source:** retrospective `plan/retrospectives/0000238-backlog-clearance-two-initiative-2026-10-29.md`
**Date filed:** 2026-10-29

---

## Problem

Step 15 (0000253) ran the full suite six times in about 45 minutes. It needed that many runs to name three failures. Each run takes about 5 minutes, and several runs ended with a `grep` filter that missed the failure lines (`plan/.initiative-logs/step-15.log`, 00:15 to 00:59 UTC on 2026-10-29).

`run-tests.sh` prints only the totals at the end, such as "Feature suites: 223 passed, 1 failed."

## Suggested Action

- Make `run-tests.sh` print the name of each failed suite under the totals, even with `RAVINTIO_TEST_QUIET=1`.
- Point the validate skill at that list.

## Wanted outcome

One suite run names every failure. Tests check these conditions:

- With one failing suite, `run-tests.sh` prints that suite's file name after the totals.
- With `RAVINTIO_TEST_QUIET=1` set, the list still prints.

## Why Deferred

The initiative retrospective found it at I-E Delivery. No step remained to take it.
