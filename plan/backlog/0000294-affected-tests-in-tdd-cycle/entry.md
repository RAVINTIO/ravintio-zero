---
title: "Backlog Entry: 0000294 - run only affected tests in each TDD cycle"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000294 - run only affected tests in each TDD cycle

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

P2 runs the full suite after every requirement. Six retrospectives record that the suite took most of P2's wall clock.

Most of those runs repeat tests that the requirement can't affect. The full suite is still needed, but once per phase rather than once per requirement.

## Suggested Action

- In each TDD cycle, run the new test and the tests that cover the files the unit changes.
- Run the full suite once at the end of P2, in the background while docs are written.
- Have P3 rerun only the suites that failed, then the full suite once before acceptance.
- Record in the build log which tests each cycle ran.

## Wanted outcome

P2 spends less time on suite runs and still runs the full suite before P3 passes. Tests check these conditions:

- The implement skill names the affected-tests rule for each cycle.
- The implement skill requires one full suite run before P2 completes.
- P3 still requires a full green suite before acceptance.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
