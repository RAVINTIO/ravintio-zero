# Changelog (0000546-queue-failure-leaves-dirty-files, 15 Nov 2026)

**Feature:** A failed queue run can leave written files in the queue worktree
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- `merge-queue.mjs` restores the chart and the version files to HEAD when a run fails before the set-version commit lands. It prints a `restored:` line.
- The restore names its paths and never resets or cleans anything else.
- The suite `test-0000546-req-001` uses a pre-commit hook that rejects the commit. ADR 0347 records the decision.

## Why

A rejected commit left the written files in the queue worktree. The next run stopped with `working tree is not clean`.

## Deviations

- Unit U3 writes `docs/decisions-index.md` and not `docs/about.md`, because the queue sets the version.
- ADR 0347 has status `accepted` before ship, because the decisions index row needs it.
- Unit U3 has no executable check. The build log marks it per the chart row for 0000410.

## Validation results

- The new suite passes with 7 checks.
- The clean-clone suite shows 461 passed and 3 failed. All 3 also fail on the base commit.
- The regression suite shows 19 passed.
- Security risk is low. The verification report covers AC-1, AC-2, AC-3, and NFR-001.

## Skipped phases

None.
