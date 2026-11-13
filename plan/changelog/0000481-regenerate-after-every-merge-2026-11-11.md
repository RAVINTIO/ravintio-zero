# Changelog (0000481-regenerate-after-every-merge, 11 Nov 2026)

**Feature:** Regenerate shared files after every base merge
**Version:** set by the merge queue at merge
**PR:** #177

## What changed

- `regenerateSharedFiles` in `shared-files.mjs` rebuilds `plan/backlog/index.md` and raises each counter to the higher value of the two merge parents.
- `merge-queue.mjs` calls it after every base merge, clean or resolved. If a file changes, the queue commits it with the subject `{id}: Regenerate shared files` before the push and prints `regenerated: {path}`.
- Tests: `test-0000481-req-001-regenerate.sh`, `test-0000481-req-001-queue-regenerates.sh`, and `test-0000481-req-002-renumber-then-regenerate.sh`.
- ADR 0313 records the decision. `roadmap-standards.md` and `docs/architecture-overview.md` describe it.

## Why

On 2026-11-10 a clean base merge into PR #171 left `plan/backlog/index.md` stale. CI failed and the queue stopped (backlog entry 0000482).

## Deviations

The first edits went to the installed copy `ravintio-zero/`. I moved them to `src/ravintio-zero/` and refreshed the copy with `sync-installed.mjs`. The plan paths now name the source.

Step 44 merged first and added `renumberIds` at the same places. The merge kept both features. The queue renumbers first and regenerates after, because a renumber changes the backlog folders that the index lists. Step 44 also held an ADR 0310, so this step's ADR became 0313.

## Validation results

Full suite in a clean clone: 408 suites passed, 2 failed. Both failures come from the clean clone and pass in the worktree. Security rating: low. After the merge of the initiative branch, the full suite passed with 418 feature suites and 19 regression suites. PR checks passed.

## Skipped phases

None.
