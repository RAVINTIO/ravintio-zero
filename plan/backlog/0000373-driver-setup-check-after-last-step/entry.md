---
title: "Backlog Entry: 0000373 - the driver checks for a Setup stop after the last step"
summary: "The driver ends on I-E Delivery Pending without a Setup line, so the installed skill copies stay out of date."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000373 - the driver checks for a Setup stop after the last step

**Source feature:** 0000349-clean-initiative-history
**Source phase:** I-E Delivery
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

---

## Problem

Step 8 of initiative 0000349 changed `ravintio-orchestrator/SKILL.md`, `ravintio-implement/SKILL.md`, and `agent-dispatch-standards.md`. After steps 5, 6, and 7, the driver printed `I-D Advance: Setup: step {n} changed {files}`. After step 8 it printed only "I-E Delivery: Pending: all 8 steps merged, initiative delivery runs from the initiative skill".

The first local suite run at delivery then failed `test-0000151-req-014-chart-clarity-and-dependency-stop.sh` with "installed skill copies match the source". A setup rerun fixed it.

Source retrospective: `plan/retrospectives/0000349-clean-initiative-history-initiative-2026-11-07.md`.

## Suggested Action

1. Run the setup change check after the last step too, and print the `Setup:` line before the `I-E Delivery: Pending:` line.
2. Add a driver test where the last step changes a pack file that setup installs.

## Why Deferred

Found at I-E Delivery, after the driver had exited.
