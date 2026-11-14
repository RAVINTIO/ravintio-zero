---
title: "Backlog Entry: 0000540 - Test impact scan lists the mirrored pack tree"
summary: "Step 61 edited pack files and learned from the full suite that src/ravintio-zero/ must match ravintio-zero/."
status: "open"
priority: "medium"
theme: "skills"
---
# Backlog Entry: 0000540 - Test impact scan lists the mirrored pack tree

**Source feature:** 0000536-pending-migrations-reach-the-human-early

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-13

---

## Problem

The plan skill's Test impact scan has no cause for the mirrored pack tree. Step 61 planned edits to `ravintio-zero/` only. The first full suite run failed `test-0000493-req-004-handoff-text.sh` because `src/ravintio-zero/` must match. The design's `## Component Paths` also lacked `src/ravintio-zero/`, so the gap surfaced late. Source retrospective: `plan/retrospectives/0000536-pending-migrations-reach-the-human-early-2026-11-13.md`.

## Suggested Action

Add a cause to the Test impact scan in `ravintio-zero/skills/ravintio-plan/SKILL.md`. It fires when the run edits a pack file and lists `test-0000493-req-004-handoff-text.sh`. The same edit tells P0 to list `src/ravintio-zero/` in `## Component Paths`.

## Wanted outcome

The plan scan has a `Pack file edit` cause that lists `test-0000493-req-004-handoff-text.sh`. P0 lists `src/ravintio-zero/` in `## Component Paths`. A test checks both.

The human approved this outcome at the chart of initiative 0000544 on 2026-11-14.

## Why Deferred

It changes the plan skill, which is outside the scope of step 61.
