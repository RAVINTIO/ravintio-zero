---
title: "Backlog Entry: 0000297 - test impact scan covers the repo's own tests"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000297 - test impact scan covers the repo's own tests

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

The plan skill's test impact scan greps `ravintio-zero/tests/` only (`ravintio-plan/SKILL.md:78`). In a developer's repo, the product's tests live elsewhere, so the scan finds nothing. A plan that changes a string, constant, or snapshot then misses the tests that check it.

## Suggested Action

- Scan the repo's own test folders as well as the pack's. Take the folders from the stack declaration or from common names such as `tests/`, `test/`, and `__tests__/`.
- List each match under `## Test impact` in the execution plan, as today.
- Update the test-writer, refactor, and validate skills where they name `ravintio-zero/tests/`.

## Wanted outcome

The test impact scan finds the developer's own tests. Tests check these conditions:

- A plan that changes a string in a file under `src/` lists the repo test that asserts that string.
- The scan still lists matches in `ravintio-zero/tests/`.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
