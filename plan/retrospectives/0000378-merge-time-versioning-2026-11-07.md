---
title: "Retrospective: 2026-11-07 - Merge-time versioning"
summary: "A blameless review of step 2 of initiative 0000360, and the change it files."
status: "open"
---
# Retrospective: 2026-11-07 - Merge-time versioning

**Mode:** run
**Subject:** 0000378-merge-time-versioning
**Date:** 2026-11-07

## Summary

The step shipped the version file list, the step PR title check, the merge queue, merge-order history, and admin-commit folds. The full suite passes. Two branches of the queue have no test.

## What helped

- The concurrency plan let U1 and U3 run together, then U2 and U4, with disjoint write targets (`plan/current/execution-plan.md`, Concurrency plan table).
- Each unit brief named its test file, so each agent wrote the test first and reported the red count (build log, P2 block).
- The chart decisions settled the P4 bump question before P0 (`Decision applied (initiative chart)` lines in the build log).

## What slowed the work

- Shell commands over 4096 characters, or with the word "merge" or a variable in `git add`, hit the `merge-guard` and `block-forced-add` hooks. Three agents or commands rewrote their file with the Write tool (build log, P0 and P2 blocks).
- A `git add -A` for the docs commit staged a running agent's files, which needed an unstage (build log, P2 notes).
- A fixture cannot reach the version-mismatch branch of `run`, because `set` makes the files agree (`acceptance-evidence.md`).

## Keep

- Briefs that name the test file, the commit rule, and the files the unit must not touch (build log, P2 block).

## Change

- Add tests for the rerun-safety and post-set check branches of the merge queue, and reject a leading-dash ref name (`security-report.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Cover the two untested branches and check ref names | pack maintainers | `ravintio-zero/scripts/merge-queue.mjs`, `ravintio-zero/tests/` | new suite cases | 0000400 |
