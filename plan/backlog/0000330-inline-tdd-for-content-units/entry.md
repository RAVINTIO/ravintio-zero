---
title: "Backlog Entry: 0000330 - Inline TDD path for content units"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000330 - Inline TDD path for content units

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Copied from the `ravintio-docs` repo, entry 0000012, found in its run 0000009 during P4.

`ravintio-zero/skills/ravintio-implement/SKILL.md` requires three subagents per requirement for the TDD loop. Runs 0000005 and 0000009 in `ravintio-docs` both ran content units inline and logged a departure each time. Zero's own runs 0000207 and 0000241 also ran the loop inline. The source is `plan/retrospectives/0000009-bug-fixes-2026-10-31.md` in the `ravintio-docs` repo.

## Suggested Action

Define an inline TDD path for small units that apply agreed text or make single-file changes. Keep the RED-before-change rule and the build-log markers.

## Wanted outcome

A content unit can run the TDD loop inline without a departure. Tests check these conditions:

- `ravintio-implement` names the rule for an inline unit: one that applies agreed text or changes one file.
- An inline unit logs its `RED:` marker before its `GREEN:` marker, and `build-log-check.mjs` accepts it with no departure line.
- A unit that misses the rule still runs the test-writer, implementer, and refactor subagents.

## Why Deferred

The human asked to move it from the `ravintio-docs` backlog, where a pack change is out of scope.
