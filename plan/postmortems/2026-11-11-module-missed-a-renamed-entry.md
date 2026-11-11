---
title: "Postmortem: 2026-11-11 - module missed a renamed entry"
summary: "A blameless record of why the id-collisions module skipped a backlog entry that the PR renamed, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-11 - module missed a renamed entry

> Path: `plan/postmortems/2026-11-11-module-missed-a-renamed-entry.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000485-adr-number-collision
**Date:** 2026-11-11

## Summary

The first run of `id-collisions.mjs` on the real merge of the initiative branch renumbered an ADR but left the backlog entry 0000513 unchanged. Git read the entry as a rename, so the list of added files omitted it. Both entries would have kept id 0000513 on the initiative branch.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-11T01:53Z | The module and both suites passed. Every test world added its entries as new files | commit 6654e53e |
| 2026-11-11T02:07Z | P3 recorded the checks green on the branch before the initiative branch moved | commit a062fb99 |
| 2026-11-11T02:27Z | The module ran on the real merge. It reported the ADR change and no backlog change | build-log P3 Merge line |
| 2026-11-11T02:28Z | A test world with a renamed entry failed, then passed after `--no-renames` | commit 14b5bf58 |

First missed chance to catch it: P1, when the plan listed the test worlds. No world held a file that the PR moved from a path that the base already had.

## 5 whys

1. The module skipped entry 0000513 on the real merge.
2. `git diff --diff-filter=A` hides a file that git pairs with a deleted file as a rename.
3. The PR had moved `0000479-record-baseline-in-p0` to `0000513-record-baseline-in-p0` at P0.
4. Every test world created its entries as new files, so none exercised rename detection.
5. The plan has no prompt to list the ways a PR can change a file set. A module that reads a git diff needs add, rename, and delete cases.

**Gap:** The plan skill's test impact scan covers causes of test edits. It does not cover the shapes of change that a diff-reading module must handle.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Pass `--no-renames` to the three git diffs in the module | done | step 44 | `src/ravintio-zero/scripts/id-collisions.mjs` | the `moved` world in the module suite | 14b5bf58 |
| preventive | none, because a rule for diff-reading modules needs its own design and one case does not justify it | none | none | none | none | none |
| detective | Add a test world where the PR renames an entry onto a colliding id | done | step 44 | `src/ravintio-zero/tests/test-0000485-req-001-id-collisions.sh` | the module suite | 14b5bf58 |
