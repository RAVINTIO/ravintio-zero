---
title: "Backlog Entry: 0000295 - record failing tests on the base commit at P0"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000295 - record failing tests on the base commit at P0

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Runs can't tell an inherited failure from one they caused. Inherited failures caused repeat notes across runs. In initiative 0000238 step 4, one led to a stop of about 5 hours (`plan/postmortems/2026-10-31-step-4-content-test-failed-on-coordinator-entry.md`).

## Suggested Action

- At P0, run the suite on the base commit and record each failing test in `plan/current/baseline-failures.md`.
- At P3, stop only on failures that the baseline doesn't list.
- List the inherited failures in the build report and offer a backlog entry for each.

## Wanted outcome

P3 stops on new failures and reports old ones. Tests check these conditions:

- A run whose only failures match the baseline passes P3 and lists them in the build report.
- A run with a failure missing from the baseline stops at P3.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
