---
title: "Backlog Entry: 0000496 - Driver clears a dead lock"
summary: "On 2026-11-10 at 19:05 the coordinator stopped a driver that had just started."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000496 - Driver clears a dead lock

**Source feature:** 0000495-driver-clears-dead-lock
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

On 2026-11-10 at 19:05 the coordinator stopped a driver that had just started. The driver left `plan/.initiative-runner.lock` with the id of a process that no longer ran. The next driver refuses to start while the lock exists, so the coordinator removed it by hand.

Evidence: the restart at 19:05 on 2026-11-10.

## Suggested Action

when the lock names a process that no longer runs, the driver reports it and takes the lock. It still refuses when the process runs.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
