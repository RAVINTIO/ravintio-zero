---
title: "Backlog Entry: 0000423 - Add-step helper writes the full feature id"
summary: "Add-step helper writes the full feature id, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000423 - Add-step helper writes the full feature id

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

`ravintio-zero/scripts/initiative-add-step.mjs` writes the bare id as the `Feature id` cell. The driver requires `{7 digits}-{slug}`. On 2026-11-10 the driver stopped with "step 22 has an invalid feature id" until a person fixed the row by hand. The script and the driver each define the id shape and share no pattern.

Evidence row: 27. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Write `{id}-{slug}` in the cell. Add a test that runs a chart the script wrote through the driver pattern.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
