---
title: "Backlog Entry: 0000609 - Build log check rejects batched, backdated, and early markers"
summary: "build-log-check.mjs fails a log whose RED and GREEN markers share one timestamp in a batch, whose RED predates its unit start, or whose Complete line comes before the phase work."
status: "open"
priority: "medium"
theme: "dispatch"
---
# Backlog Entry: 0000609 - Build log check rejects batched, backdated, and early markers

**Source feature:** 0000544-priority-backlog (initiative retrospective)

**Source phase:** I-E Delivery

**Deferral source:** `plan/retrospectives/0000544-priority-backlog-initiative-2026-11-27.md`

**Date filed:** 2026-11-27

---

## Problem

The TDD markers in a build log are the evidence that each unit failed before it passed. In initiative 0000544, several step logs had markers that `build-log-check.mjs` accepted but that do not show that order:

- Steps 35 and 36 wrote the `RED:` and `GREEN:` lines of several units in one batch, after the work.
- Step 37 wrote a `RED:` line with a time earlier than the commit that added it.
- Steps 28, 35, 37, and 38 wrote `Complete: P{n}` before the phase's work. Step 37 logged `Complete: P4` without the archive or the push.

The check reads which markers exist. It does not read their order or their times.

## Suggested Action

- `build-log-check.mjs` fails a log when three or more units carry `RED:` and `GREEN:` lines with the same timestamp.
- It fails a `RED:` line whose time is earlier than its unit's start line.
- It fails a `Complete: P{n}` line that comes before a required artefact of that phase, such as the archive path for P4.
- Each failure names the unit or phase and the line number.

## Tests

- A fixture log with a batch of three units at one timestamp fails the check.
- A fixture log with a `RED:` time before its unit start fails.
- A fixture log with `Complete: P4` and no archive line fails.
- A real archived log from a clean step still passes.

## Why Deferred

The initiative retrospective filed it on 2026-11-27. It changes a gate script, so it waits for a future initiative.
