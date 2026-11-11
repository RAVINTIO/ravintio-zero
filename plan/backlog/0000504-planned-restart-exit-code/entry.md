---
title: "Backlog Entry: 0000504 - Planned restart exits with its own code"
summary: "When a merged step changes the driver, the driver prints `Restart:` and exits with code 1."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000504 - Planned restart exits with its own code

**Source feature:** 0000503-planned-restart-exit-code
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

When a merged step changes the driver, the driver prints `Restart:` and exits with code 1. The host then reports the background task as failed, although the restart is planned.

Evidence: driver exit at 00:29 on 2026-11-11, after step 27 merged.

## Suggested Action

a planned restart exits with a distinct code, such as 75, and a real failure keeps code 1. The skill and the watcher treat the distinct code as a planned stop.

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
