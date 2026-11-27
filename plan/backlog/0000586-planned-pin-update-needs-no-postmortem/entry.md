---
title: "Backlog Entry: 0000586 - A planned pin update needs no postmortem"
summary: "A chart row tells a step to log a Rework line for a pin update, and ship then demands a postmortem for a planned change."
status: "open"
priority: "low"
theme: "pipeline"
---
# Backlog Entry: 0000586 - A planned pin update needs no postmortem

**Source feature:** 0000553-coordinator-oversight-not-micromanagement

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-15

---

## Problem

The chart decision "A test pins text that the step edits" tells a step to update the pin and log a `Rework:` line. `build-log-check.mjs` then fails ship until a `Postmortem:` line names the requirement. The plan already lists the pin in `## Test impact`, so the update follows the plan and no failure got through.

## Suggested Action

Give the planned pin update its own marker, such as `Pin update:`, that `build-log-check.mjs` accepts without a postmortem when the plan names the suite. Change the chart decision row text to match.

## Why Deferred

The fix changes a check and the chart decision wording. It needs its own design.
