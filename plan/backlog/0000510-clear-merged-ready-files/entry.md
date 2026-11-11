---
title: "Backlog Entry: 0000510 - Driver clears ready files of merged steps"
summary: "Merged steps leave `ready` files in `plan/.initiative-control/`."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000510 - Driver clears ready files of merged steps

**Source feature:** 0000509-clear-merged-ready-files
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

Merged steps leave `ready` files in `plan/.initiative-control/`. On 2026-11-11 the coordinator removed 7 of them by hand, for steps 10, 11, 13, 16, 18, 20, and 34.

Evidence: `plan/.initiative-control/` at 00:30 on 2026-11-11.

## Suggested Action

when the chart shows a step as merged, the driver removes that step's `ready` file and reports it.

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
