---
title: "Backlog Entry: 0000594 - The scan has no cause for a renumbered list"
summary: "A run that renumbers a list breaks suites that pin the old numbers, and the test impact scan does not name them."
status: "open"
priority: "low"
theme: "scan"
---
# Backlog Entry: 0000594 - The scan has no cause for a renumbered list

**Source feature:** 0000559-start-baseline-first

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-16

---

## Problem

Step 15 renumbered the Discovery Start Actions. Two suites pinned the old numbers, `test-0000151-req-011` and `test-0000321-req-004-pickup-text`. The plan did not list them, and P2 found them. The scan has no cause for a numbered list that a run reorders. Source: `plan/retrospectives/0000559-start-baseline-first-2026-11-16.md`.

## Suggested Action

Add a `Renumbered list` cause to `skills/ravintio-plan/references/test-impact-causes.md`. It tells the plan to grep the tests for `step {n}`, `^{n}\.`, and fixtures that hold the list. A test checks that the cause exists.

## Why Deferred

The scan holds 21 lines at most, so a new cause needs its own merge of two lines.
