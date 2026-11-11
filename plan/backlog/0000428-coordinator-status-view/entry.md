---
title: "Backlog Entry: 0000428 - One status view and event notices for the coordinator"
summary: "One status view and event notices for the coordinator, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000428 - One status view and event notices for the coordinator

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

The coordinator missed a ready line for 24 minutes and a driver exit for two hours, because no monitor ran. It also gave a wrong status twice. The driver prints a generic "Stopping" line and gives the queue failure reason only at exit. The watcher prints no event for a new `ready` file or a driver exit. No report format separates a human decision from a routine fix. The human called the run hard to oversee.

Evidence rows: 17, 23, and 26. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Added on 2026-11-10

- The watcher shows merged steps as `ready`, because it reads stale control files. It should read the chart status.
- The driver prints stop lines for stops the coordinator has already cleared, such as "queue stopped on step 26" after step 26 merged. The status view should show only live stops.

## Suggested Action

Print one status view with queue state, ready PRs, running steps, and open decisions. Make the watcher and driver print an event for a ready file, a queue failure, and an exit. Add a report format that lists decisions apart from routine fixes.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
