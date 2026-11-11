# Changelog (0000483-mergeability-before-ci-wait, 11 Nov 2026)

**Feature:** Check mergeability before a CI wait
**Version:** set by the merge queue at merge
**PR:** 176

## What changed

- `merge-queue.mjs` reads `mergeable` while `gh pr checks` lists no check. It stops with a named error on `CONFLICTING`.
- The queue also stops with `no CI checks appeared` if no check appears within `MQ_NOCHECKS_MS` ms (default 600000).
- `roadmap-standards.md` tells a step to run `gh pr view {n} --json mergeable` before the first CI poll. The step merges the initiative branch into a conflicting PR.
- The ship skill names the same read.
- Two new suites, `test-0000483-req-001-queue-stops-on-conflict.sh` and `test-0000483-req-002-step-reads-mergeability.sh`.
- ADR 0311 records the decision.

## Why

PR #166 for step 36 conflicted with the initiative branch. GitHub starts no workflow for a conflicting PR, so no check registered. Step 36 waited about 69 minutes. Backlog entry 0000484 asked for the fix.

## Deviations

- P2 ran inline without subagents, because the work is two small units.

## Validation results

- The new queue suite failed 2 of 7 checks before the change and passed 7 of 7 after it. The standards suite failed 5 of 5 before and passed 5 of 5 after.
- Nine existing queue suites and four related suites pass.

## Skipped phases

None.
