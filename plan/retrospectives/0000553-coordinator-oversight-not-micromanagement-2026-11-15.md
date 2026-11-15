---
title: "Retrospective: 2026-11-15 - Initiative skills do not micromanage"
summary: "A blameless review of a finished run or initiative, and the changes it files."
status: "closed"
---
# Retrospective: 2026-11-15 - Initiative skills do not micromanage

> Path: `plan/retrospectives/0000553-coordinator-oversight-not-micromanagement-2026-11-15.md`. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Mode:** run
**Subject:** 0000553-coordinator-oversight-not-micromanagement
**Date:** 2026-11-15

## Summary

The step changed one section of the initiative skill and one pinned suite. The work took 48 minutes, and the suites took most of it.

## What helped

- The plan's test impact table named the 0000240 pin before P2 started (`plan/_archive/0000553-coordinator-oversight-not-micromanagement-2026-11-15/execution-plan.md`).
- The skill line cap test gave a clear limit of 120 lines (`ravintio-zero/tests/test-0000314-req-002-driver-files-stay.sh`).

## What slowed the work

- Ship needed a postmortem for a planned pin update (build-log P2 `Rework:` line, `plan/postmortems/2026-11-15-planned-pin-update-logged-as-rework.md`).
- Three suite runs took about 20 minutes each (build-log P2 and P3 wall clocks).

## Keep

- List each pinned suite in `## Test impact` before P2 (`execution-plan.md`).

## Change

- Give a planned pin update its own marker, so ship asks for no postmortem (backlog 0000586).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Add a `Pin update:` marker to the build-log check | pipeline | `ravintio-zero/scripts/build-log-check.mjs` | A planned pin update with no postmortem passes the check | 0000586, from this retrospective |
