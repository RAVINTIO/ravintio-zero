---
title: "Postmortem: 2026-11-11 - PR conflicted with initiative branch"
summary: "A blameless record of why PR 177 stopped twice on conflicts with the initiative branch, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-11 - PR conflicted with initiative branch

> Path: `plan/postmortems/2026-11-11-pr-conflicted-with-initiative-branch.md`. Written by `ravintio-postmortem`.

**Trigger:** Blocked stop
**Feature:** 0000481-regenerate-after-every-merge
**Date:** 2026-11-11

## Summary

PR 177 conflicted with the initiative branch, so GitHub started no CI and the step stopped with a Blocked line. The coordinator cleared the block. Step 44 then merged and the PR conflicted again in six files, including this step's own change to `merge-queue.mjs`.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-11T01:55Z | The step finished P4 and opened PR 177 | build-log P4 block |
| 2026-11-11 | CI did not start. The step stopped with a Blocked line that blamed the CI triggers | queue item `rebase-step-42`, `instruction.md` |
| 2026-11-11 | Step 44 merged and added `renumberIds` to `merge-queue.mjs` at the places this step edits | queue item `rebase-step-42`, `instruction.md` |
| 2026-11-11T03:47Z | The base merge showed six conflicts. Both features now sit in both copies of the script | commit 73859eaa |
| 2026-11-11T03:47Z | The base ADR-0310 matched this step's ADR-0310, so the module renumbered ours to ADR-0313 | docs/adr/0313-regenerate-in-a-separate-commit.md |

First missed chance to catch it: P4, when the step opened the PR. Nothing compared the PR against the moving initiative branch.

## 5 whys

1. The PR stopped and then conflicted a second time.
2. GitHub starts no workflow for a conflicting PR, so the step saw no checks and read that as a CI fault.
3. The step read `mergeable` only after it hit the missing checks, not before the CI poll.
4. Parallel steps edit the same shared files and the same script, and the initiative branch moved while the PR waited.
5. No test covered a base merge that both renumbers an id and regenerates a file, so the two features had never met in one merge.

**Gap:** The ship skill had no `mergeable` check before the CI poll. The merge queue also had no test for two merge-time features on one base merge.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Merge the initiative branch, keep both features, and renumber the colliding ADR | done | step 42 | `src/ravintio-zero/scripts/merge-queue.mjs` | full suite and green CI on PR 177 | 73859eaa |
| preventive | Read `mergeable` before the CI poll and stop on `CONFLICTING` | done | 0000483 | `docs/adr/0311-stop-ci-waits-on-a-conflicting-pr.md` | the merge queue suite | 0000483 ADR-0311 |
| detective | Test a base merge that renumbers an id and regenerates the index | done | step 42 | `src/ravintio-zero/tests/test-0000481-req-002-renumber-then-regenerate.sh` | the feature suite | b2085ce2 |
