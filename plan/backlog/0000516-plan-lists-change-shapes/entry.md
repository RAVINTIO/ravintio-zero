---
title: "Backlog Entry: 0000516 - plan lists the change shapes a diff reader must handle"
summary: "A module that reads a git diff needs test cases for add, rename, and delete, and the plan skill does not prompt for them."
status: "open"
priority: "low"
theme: "pipeline"
---
# Backlog Entry: 0000516 - plan lists the change shapes a diff reader must handle

**Source feature:** 0000485-adr-number-collision

**Source phase:** P3

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-11

---

## Problem

The id-collisions module first skipped a backlog entry that the PR had renamed, because git lists a rename apart from an addition. Every test world added its files as new, so no test caught it until the module ran on a real merge. The plan skill's test impact scan covers causes of test edits and not the shapes of change that a diff reader must handle.

Postmortem: `plan/postmortems/2026-11-11-module-missed-a-renamed-entry.md`.

## Suggested Action

Add a row to the plan skill's `## Test impact` scan. When a unit reads a git diff or a file list, the plan names a test world for each of add, rename, and delete.

## Wanted outcome

A plan for a unit that reads a git diff lists a test world for each change shape. The unit's suite then fails before the unit runs on real data.
