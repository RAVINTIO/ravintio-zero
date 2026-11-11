---
title: "Backlog Entry: 0000527 - Old-name guard fails in the full suite"
summary: "test-0000189-req-007 fails in some full-suite runs and passes alone, and the hit it prints is on an allowlisted file."
status: "open"
priority: "medium"
theme: "tests"
---
# Backlog Entry: 0000527 - Old-name guard fails in the full suite

**Source feature:** 0000491-driver-favours-critical-path
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-11

---

## Problem

`test-0000189-req-007-old-name-guard.sh` fails in a full clean-clone run of step 47. It prints `ravintio-zero/migrations/0005-initiative-rename.md:45`, a file on the test's allowlist. The same suite passes alone, locally and in a clean clone. The logs of steps 4 and 51 in `/tmp` show the same suite failing, each time with a different path.

## Suggested Action

Find the earlier suite that changes tracked files or the working folder before this guard runs. Make the guard read a stable copy of the tree.

## Wanted outcome

A full-suite run and a solo run give the same result for this suite. A test plants the earlier suite's change and expects the guard to pass.

## Why Deferred

Step 47 changes the driver start order and no old names. The failure does not reproduce alone.
