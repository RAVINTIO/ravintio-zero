---
title: "Backlog Entry: 0000407 - list sibling copies of a pinned test in the impact scan"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "unsorted"
---
# Backlog Entry: 0000407 - list sibling copies of a pinned test in the impact scan

**Source feature:** 0000389-writing-standard
**Source phase:** P1
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-08
**Source retrospective:** plan/retrospectives/0000389-writing-standard-2026-11-08.md

---

## Problem

The plan's test impact scan named `test-0000034-req-003-atomic-settings-writes.sh` but missed its copy under `tests/regression/`. The full suite found the gap in P2.

## Suggested Action

Add a line to the plan skill's Test impact scan: for each test file listed, grep `tests/regression/` for a file with the same name.

## Wanted outcome

A plan lists the regression copy of any test it edits. A test in the pack checks that the plan skill text holds the sibling-copy line.

## Why Deferred

Outside the scope of 0000389-writing-standard.
