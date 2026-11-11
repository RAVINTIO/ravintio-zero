---
title: "Backlog Entry: 0000506 - Coordinator branches regenerate shared files"
summary: "On 2026-11-11 the coordinator merged the initiative branch into the branch for steps 42 to 50."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000506 - Coordinator branches regenerate shared files

**Source feature:** 0000505-coordinator-branch-regenerate
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

On 2026-11-11 the coordinator merged the initiative branch into the branch for steps 42 to 50. The merge conflicted in `plan/backlog/index.md`, the same generated-file conflict the queue meets. Coordinator branches have no command that resolves generated files after a merge.

Evidence: merge commit `e3abc90` on `feat/0000360-chart-steps-42-to-50`.

## Suggested Action

Add one command that brings the initiative branch into a coordinator branch. It regenerates `plan/backlog/index.md`, checks `plan/backlog/.next-id` and `docs/adr/.next-id`, and commits the result. It refuses when a conflict touches any other file.

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
