# Changelog (0000464-merge-queue-test-gaps, 10 Nov 2026)

**Feature:** Merge queue test gaps
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- `merge-queue.mjs run` refuses a `headRefName` or `baseRefName` that starts with a dash. It stops before the first `git` call that uses either name.
- `test-0000464-req-001-002-queue-branches.sh` covers the rerun path. A first run stops at the merge, and the second run adds no commit and merges.
- The same suite covers the post-set version check. A stub `version-files.mjs` leaves `product.yml` different, and `run` exits 1 before the merge.
- `test-0000464-req-003-dash-guard.sh` covers the dash check for the head and the base.

## Why

Backlog entry 0000400 found two branches of `run` that no test reached. It also found that ref names from `gh` reached `git` with no check.

## Deviations

- P2 ran inline without subagents, because each unit writes one file.
- The mismatch fixture uses a copy of the queue beside a stub `version-files.mjs`. No real input makes the files differ after the set.

## Validation results

- The dash suite failed 6 checks before the guard and passes after it.
- The queue suites that `## Test impact` lists all pass.

## Skipped phases

None.
