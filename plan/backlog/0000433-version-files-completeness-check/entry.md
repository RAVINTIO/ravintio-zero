---
title: "Backlog Entry: 0000433 - Check that the version list names every version file"
summary: "Check that the version list names every version file, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000433 - Check that the version list names every version file

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

The layout move in 0000397 changed where a version file lives and left `version-files.txt` stale. The queue bumped the installed copy only, and CI failed at `sync-installed.mjs --check`. Entry 0000420 fixed the missing entry. No check ties the list to the real version-carrying files, so the next move can repeat it.

Evidence row: 20. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Add a test that finds every file with a pack version and fails when the list omits one.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
