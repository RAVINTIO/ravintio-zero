---
title: "Backlog Entry: 0000523 - Test impact scan names hook pins"
summary: "The plan skill's test impact scan has no cause for a new hook, so step 51 found six pinning suites only in P2."
status: "open"
priority: "medium"
theme: "pipeline"
---
# Backlog Entry: 0000523 - Test impact scan names hook pins

**Source feature:** 0000499-reply-times-match-clock
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-11

---

## Problem

Step 51 added a `PostToolUse` hook and cut the reply-time margin from 5 to 2 minutes. Six existing suites pinned the old behaviour. They counted advisory hooks, counted settings filters, listed the hook fixture, or named the margin. The plan listed three of them under frozen-line tests and missed the rest. The full suite found them in P2.

## Suggested Action

Add a cause to the Test impact scan in `ravintio-plan`: the run adds, removes, or changes a hook. The cause tells the planner to grep the tests for these:

- The hook name.
- Hook count words such as "five commands".
- The `expected-after.txt` fixture and `pack-facts`.
- The margin or status text the hook checks.

## Wanted outcome

The plan scan has a `Hook change` cause covering the four grep targets the entry lists. A test checks for the cause.

The human approved this outcome at the chart of initiative 0000544 on 2026-11-14.

## Why Deferred

Found in the step 51 P2 rework. The plan skill is outside the step's scope.
