---
title: "Backlog Entry: 0000431 - Refuse a step merge outside the queue"
summary: "Refuse a step merge outside the queue, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000431 - Refuse a step merge outside the queue

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Step 12 squash-merged its own PR #133 and bypassed the queue. The PR got no version, no tag, and a `pending` chart row. The carve-out lets a step squash its own PR, and the standard says the queue merges it. `merge-guard` checks only the PR base.

This change narrows `merge-guard`. It does not widen it. A step session with `RAVINTIO_INITIATIVE_QUEUE=1` would lose the squash. The queue merge must still pass, so a test must cover that.

Evidence row: 7. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Refuse `--squash` when `RAVINTIO_INITIATIVE_QUEUE=1`. Remove the overlap from the carve-out text. Test that the queue still merges.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
