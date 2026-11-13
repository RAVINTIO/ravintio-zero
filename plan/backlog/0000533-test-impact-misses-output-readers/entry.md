---
title: "Backlog Entry: 0000533 - Plan test impact misses suites that read driver output order"
summary: "A change that adds a driver line broke five suites that read the last line, and the plan listed none."
status: "open"
priority: "medium"
theme: "plan"
---
# Backlog Entry: 0000533 - Plan test impact misses suites that read driver output order

**Source feature:** 0000511-driver-stop-summary
**Source phase:** P2 Implement
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-13

---

## Problem

Step 57 added a summary block to the driver output. The plan's test impact table said "none found" for the added lines. The first design printed the block last. Five existing suites read the last line of the driver output, and the full suite failed them: `test-0000205-req-006-driver-final-report`, `test-0000379-req-002-003-005-scheduler`, `test-0000379-req-004-queue-handoff`, `test-0000446-req-001-drain-after-queue-failure`, and `test-0000450-req-003-driver-queue-line`. The agent found them only after a 25-minute run.

## Suggested Action

Add a test impact cause for output order to the plan skill. A change to printed lines names each suite that matches the line text or reads the last line. A search of the tests folder finds them.

## Why Deferred

The fix changes the plan skill. It is outside the driver change in step 57.
