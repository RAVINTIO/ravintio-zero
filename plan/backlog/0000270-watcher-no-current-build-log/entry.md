---
title: "Backlog Entry: 0000270 - the watcher waits when no build log exists yet"
summary: "A retrospective finding, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000270 - the watcher waits when no build log exists yet

**Source feature:** none (initiative 0000238 retrospective)
**Source phase:** none (I-E Delivery)
**Deferral source:** retrospective `plan/retrospectives/0000238-backlog-clearance-two-initiative-2026-10-29.md`
**Date filed:** 2026-10-29

---

## Problem

When step 15 started, `plan/current/` did not exist yet. The watcher reported "stale: the build log has not changed for 90 minutes and a commit is 89 minutes newer than it". It read step 14's archived build log and the coordinator's own commits (task `b5pe1f7gx`, 2026-10-29 00:06 UTC).

After the step archived its run, the watcher reported "step 16" while step 15 still waited for CI.

## Suggested Action

- If `plan/current/build-log.md` is missing, report "waiting for the build log" and skip the stale check.
- Take the step number from the driver lock or the step log name, not from the position in `initiative.md`.

## Wanted outcome

The watcher raises no stale event before a step writes its build log, and names the step that runs. Tests check these conditions:

- With no `plan/current/build-log.md`, the watcher prints no stale line.
- After the step moves the position, the heartbeat still names the running step.

## Why Deferred

The initiative retrospective found it at I-E Delivery. No step remained to take it.
