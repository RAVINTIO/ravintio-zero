---
title: "Backlog Entry: 0000596 - Plan lists the source-tree copy of each new test"
summary: "A new test file needs a copy under src/ravintio-zero/tests/, and the plan does not say so."
status: "open"
priority: "medium"
theme: "plan"
---
# Backlog Entry: 0000596 - Plan lists the source-tree copy of each new test

**Source feature:** 0000576-phase-start-time-at-phase-start

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-18

---

## Problem

The step added two tests to `ravintio-zero/tests/` only. The first CI run failed `node src/ravintio-zero/scripts/sync-installed.mjs --check` with `extra: tests/test-0000576-req-001-start-time-check.sh`. No plan or implement check names the copy under `src/ravintio-zero/tests/`. The retrospective at `plan/retrospectives/0000576-phase-start-time-at-phase-start-2026-11-18.md` records the miss.

## Suggested Action

Make the plan skill list the `src/ravintio-zero/tests/` copy of each new test as a deliverable. Add a test that checks the wording.

## Why Deferred

The fix edits the plan skill and needs its own test. It is outside the scope of the start-time check.
