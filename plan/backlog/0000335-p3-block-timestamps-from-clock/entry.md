---
title: "Backlog Entry: 0000335 - P3 block timestamps from the clock"
summary: "The P3 and P4 build-log blocks take their times from the clock, so the build-log check no longer fails at ship."
status: "open"
---
# Backlog Entry: 0000335 - P3 block timestamps from the clock

**Source feature:** 0000319-initiative-history-checks
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

The P3 block closed with an end time that came from an estimate, not the clock. `build-log-check.mjs` then reported `P4: End is before Start` at ship, and the step rewrote the times. Source retrospective: `plan/retrospectives/0000319-initiative-history-checks-2026-11-01.md`.

## Suggested Action

In `ravintio-validate-and-accept` and `ravintio-ship`, tell the phase to read `date -u +%FT%TZ` for each `Start` and `End` value. Add a check that `build-log-check.mjs` runs after the P3 block closes.

## Why Deferred

The fix edits two skills and needs its own design and tests.
