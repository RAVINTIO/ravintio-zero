---
title: "Backlog Entry: 0000494 - Driver keeps starting steps after a Restart"
summary: "After a merged step changes the driver, the driver prints `Restart:` and starts no new step until every running step finishes."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000494 - Driver keeps starting steps after a Restart

**Source feature:** 0000493-driver-starts-after-restart
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

After a merged step changes the driver, the driver prints `Restart:` and starts no new step until every running step finishes. On 2026-11-10 step 25 merged at 20:01, and step 26 waited until 21:43 for steps 36, 38, and 39 to finish.

Evidence: driver output from 20:01 to 21:28 on 2026-11-10.

## Suggested Action

the driver hands off at once. It stops starting steps, lets the running sessions finish, and a new driver takes over new starts and the queue. Or the driver re-execs itself between steps without stopping running sessions.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
