---
title: "Backlog Entry: 0000419 - test impact scan for layout moves"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "pipeline-process"
---
# Backlog Entry: 0000419 - test impact scan for layout moves

**Source feature:** 0000397-pack-source-in-src
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-09

---

## Problem

The plan skill's test impact scan has no cause for a folder move. Step 20 moved the pack source to `src/ravintio-zero/`. The first suite run from the new folder failed 43 suites, because tests found the repo root as one folder above the pack. The prose baseline also keyed its counts by path, so 19 counts rose. The scan in `src/ravintio-zero/skills/ravintio-plan/SKILL.md` lists nine causes and none covers a path move.

## Suggested Action

Add a cause named `Path move` to the scan. When the run renames a folder, the scan greps the tests for `$ZERO_DIR/..` and `SCRIPT_DIR/../..`. It also lists each state file that keys data by path, such as `plan/state/prose-baseline.json`. A pack check could also run the suite once from the new folder before P2 starts.

## Wanted outcome

The plan scan has a `Path move` cause covering `$ZERO_DIR/..`, `SCRIPT_DIR/../..`, and path-keyed state files. A test checks for the cause.

The human approved this outcome at the chart of initiative 0000544 on 2026-11-14.

## Why Deferred

The fix edits the plan skill and its size cap tests. Step 20 only moves the pack source and edits no skill.
