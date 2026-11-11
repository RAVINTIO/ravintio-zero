---
title: "Postmortem: 2026-11-11 - Typed marker times"
summary: "A blameless record of why P2 marker times were typed after the runs and not read from the clock, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-11 - Typed marker times

> Path: `plan/postmortems/2026-11-11-typed-marker-times.md`. Written by `ravintio-postmortem`.

**Trigger:** human request
**Feature:** 0000499-reply-times-match-clock
**Date:** 2026-11-11

## Summary

Step 51 enforces the rule that every time comes from a clock read. Its own P2 RED and GREEN markers carry times that the agent typed after the runs. The coordinator queued an instruction to record the departure.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-11T08:47:18Z | The suites ran RED. The marker lines took this time. | the P2 block of the build log |
| 2026-11-11T09:17:39Z | The GREEN markers were written with approximate times and a note | the build log note line |
| 2026-11-11T09:09:00Z | The coordinator queued an instruction to read the clock for every time | `plan/current/coordinator-instruction-real-times.md` |

First missed chance to catch it: the P2 marker step. No tool writes a marker with a clock read.

## 5 whys

1. The GREEN marker times were approximate.
2. The agent wrote the marker lines by hand after the runs.
3. The implement skill tells the agent to append a marker with a timestamp and names no tool for it.
4. A hand-typed line needs no clock read, so the agent estimated.
5. The pack has no script that writes a marker line from the clock.

**Gap:** The pack has no tool that writes build log markers from a clock read.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Record the departure in a Rework line and keep the approximate times | done | step 51 | `plan/current/build-log.md` | `build-log-check.mjs` | 6c6f7e2a |
| preventive | Add a script that writes RED, GREEN, and Done lines from the clock | filed | pack maintainer | `ravintio-zero/scripts/` | a P2 run that uses it | 0000524 |
| detective | none, because the build log check already fails a time later than its commit | none | none | none | none | none |
