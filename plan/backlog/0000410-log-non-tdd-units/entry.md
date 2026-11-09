---
title: "Backlog Entry: 0000410 - Log a non-TDD unit with a class"
summary: "A discovered item deferred for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "agent-dispatch"
---
# Backlog Entry: 0000410 - Log a non-TDD unit with a class

**Source feature:** 0000386-unit-dispatch
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-09

---

## Problem

Source: `plan/retrospectives/0000386-unit-dispatch-2026-11-09.md`.

`build-log-check.mjs` requires a `RED:` and a `GREEN:` marker for every `Done:` line with tier `inline`. A living-docs unit has no test, so it cannot log tier `inline`. Step 10 logged `U-004` in the older form with no class fields, and the metrics report counts it as `unclassified`.

## Suggested Action

Define how a unit with no test logs its `Done:` line. Options are a class value such as `docs`, or a tier value that does not need the markers. Pick one, update the dispatch standards, and make `workflow-metrics.mjs` count it in its own row.

## Wanted outcome

A living-docs unit logs `{class}, {tier}, {effort}` on its `Done:` line, `build-log-check.mjs` accepts it, and the metrics report counts it under a named row.

## Why Deferred

It needs a decision on the class list, which the chart fixed at four values for step 10.
