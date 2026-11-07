---
title: "Backlog Entry: 0000400 - cover the merge queue rerun and version-mismatch branches"
summary: "Two branches of merge-queue.mjs run have no test, and ref names from gh reach git arguments unchecked."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000400 - cover the merge queue rerun and version-mismatch branches

**Source feature:** 0000378-merge-time-versioning
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

---

## Problem

`ravintio-zero/scripts/merge-queue.mjs` `run` has two branches that no test reaches:

- The rerun-safety branch skips the version and chart edits when the PR branch already holds them (`merge-queue.mjs:267-272`).
- The post-set version check (`merge-queue.mjs:279`) stops the run if the files differ. After `setVersions` writes every file, no real input makes them differ, so the fixture cannot reach it.

The script also passes the branch names that `gh pr view` returns to `git` without a check for a leading dash. Git rejects such a ref name, so the risk is Low.

Source retrospective: `plan/retrospectives/0000378-merge-time-versioning-2026-11-07.md`.

## Suggested Action

1. Add a fixture that runs `run` twice on one PR and checks the second run adds no commit and still merges.
2. Add a fixture that stubs `version-files.mjs set` to leave one file different, and checks that `run` exits 1 before the merge.
3. Reject a branch name that starts with a dash before it reaches `git`.

## Why Deferred

Found at P3 of step 2 of initiative 0000360. The step's scope was the queue and its checks.
