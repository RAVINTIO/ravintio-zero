---
title: "Backlog Entry: 0000593 - build-log-mark inserts markers after the divider"
summary: "The marker script writes its lines below the closing divider line, so a later insert that anchors on the divider misses."
status: "open"
priority: "low"
theme: "dispatch"
---
# Backlog Entry: 0000593 - build-log-mark inserts markers after the divider

**Source feature:** 0000558-plan-only-push-short-ci
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-16

---

## Problem

`build-log-mark.mjs` puts a `RED:`, `GREEN:`, or `Done:` line right before the `## Summary` heading. That is after the `---` divider and outside the phase block. A step that inserts a later block by the text `---` plus `## Summary` then finds no match and writes nothing without an error.

Source retrospective: `plan/retrospectives/0000558-plan-only-push-short-ci-2026-11-16.md`.

## Suggested Action

Place the marker lines inside the newest phase block, before the divider that precedes `## Summary`.

## Wanted outcome

- A test shows a marker line lands above the divider that precedes `## Summary`.

## Why Deferred

It changes a script that step 14 does not own.
