---
title: "Backlog Entry: 0000344 - the chart says whether a step may fix its own CI failure"
summary: "A coordinator-observed gap, filed for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "initiative-chart"
---
# Backlog Entry: 0000344 - the chart says whether a step may fix its own CI failure

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

The initiative 0000312 chart lists "CI fails on a step PR" as a stop condition. Step 3 (feature 0000315) pushed `cc98715` to PR #84 to fix a Windows PowerShell 5.1 failure in `run-tests.ps1`, and did not stop. The fix was correct and stayed in scope. The chart template gives no way to say whether a step may do this.

Source retrospective: `plan/retrospectives/0000312-guards-history-and-test-noise-initiative-2026-11-01.md`.

## Suggested Action

Add a row to `ravintio-zero/templates/initiative.template.md` that says whether a step may fix its own CI failure inside its scope. Have the orchestrator read it at P4.

## Why Deferred

The chart format change needs its own step, with tests for the new row.
