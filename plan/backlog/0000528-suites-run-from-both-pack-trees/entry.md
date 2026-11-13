---
title: "Backlog Entry: 0000528 - Suites run from both pack trees"
summary: "A new test must pass from src/ravintio-zero/tests and from ravintio-zero/tests, and no helper says how to find the other tree."
status: "open"
priority: "low"
theme: "tests"
---
# Backlog Entry: 0000528 - Suites run from both pack trees

**Source feature:** 0000493-driver-starts-after-restart
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-11

---

## Problem

The pack keeps two identical trees, `src/ravintio-zero/` and `ravintio-zero/`. The clean-clone full suite runs each test from both. A suite that builds a path to the other tree with `../../..` passes from `src/ravintio-zero/tests/` and fails from `ravintio-zero/tests/`. Step 48 hit this in `test-0000493-req-004-handoff-text.sh`. See the retrospective `plan/retrospectives/0000493-driver-starts-after-restart-2026-11-11.md`.

## Suggested Action

Add a `helpers/` function that returns the repo top and both tree paths. State in the testing standards that a new suite runs from both trees before it counts as green.

## Why Deferred

The two-tree layout may go away when the pack source moves fully to `src/`. The fix is outside the driver change.
