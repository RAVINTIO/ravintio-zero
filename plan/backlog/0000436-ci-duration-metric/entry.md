---
title: "Backlog Entry: 0000436 - Track CI duration"
summary: "Track CI duration, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000436 - Track CI duration

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Each merge waited about 16 minutes for CI. Feature 0000409 cut it to 4m40s with shards. The 7-minute target was a one-off criterion. No metric or standing check shows CI growth, so it shows only when someone feels it.

Evidence row: 15. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Record CI duration per run in `workflow-metrics.mjs` and name a target in the CI standard.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
