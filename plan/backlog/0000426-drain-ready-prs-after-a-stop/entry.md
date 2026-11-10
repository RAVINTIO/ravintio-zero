---
title: "Backlog Entry: 0000426 - Merge ready PRs after the driver stops"
summary: "Merge ready PRs after the driver stops, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000426 - Merge ready PRs after the driver stops

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

The queue runs only inside the driver. After a queue failure the driver holds back every ready PR, including independent ones. The roadmap standards define a manual `merge-queue.mjs run` for the non-concurrent route only. Ready, green PRs waited while the driver had stopped.

Evidence row: 16. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Let the driver merge independent ready PRs after a failure, or document and script the manual drain for the concurrent route.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
