---
title: "Backlog Entry: 0000402 - record each phase start time when the phase begins"
summary: "Step 4 wrote the P1 to P3 build-log blocks at phase end, so their wall clock read 0 minutes."
status: "open"
priority: "low"
theme: "unsorted"
---
# Backlog Entry: 0000402 - record each phase start time when the phase begins

**Source feature:** 0000380-test-helpers-and-rule-anchors
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

Source retrospective: `plan/retrospectives/0000380-test-helpers-and-rule-anchors-2026-11-07.md`.

---

## Problem

The orchestrator says to write the phase block before phase work, but a run in autonomous mode can write it at phase end. Step 4 did so for P1 to P3. The `Start` and `End` times then differ by seconds, and the build report shows `not recorded` for three phases.

## Suggested Action

Make `build-log-check.mjs` flag a phase block whose `Start` is later than the first commit of that phase's artifacts. Name the check in the orchestrator's Phase Invocation reference.

## Wanted outcome

A phase block whose `Start` time follows the phase's first artifact commit fails the build-log check and names the phase.

## Why Deferred

The step's scope was test helpers. The fix changes a ship-time script.
