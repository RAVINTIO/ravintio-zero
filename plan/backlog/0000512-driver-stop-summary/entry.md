---
title: "Backlog Entry: 0000512 - Driver prints a stop summary"
summary: "At each driver stop, the human reads many lines to learn what happened and whether they must act."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000512 - Driver prints a stop summary

**Source feature:** 0000511-driver-stop-summary
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

At each driver stop, the human reads many lines to learn what happened and whether they must act. The driver prints one state line per step, and the coordinator gathers the rest by hand.

Evidence: driver output at 00:29 on 2026-11-11.

## Suggested Action

at each stop, the driver prints one summary block. The block lists the steps that merged, the fixes the driver made by itself, and the one action left for the human, or "none".

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
