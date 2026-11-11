# Changelog (0000481-regenerate-after-every-merge, 11 Nov 2026)

**Feature:** Regenerate shared files after every base merge
**Version:** set by the merge queue at merge
**PR:** #177

## What changed

- `regenerateSharedFiles` in `shared-files.mjs` rebuilds `plan/backlog/index.md` and raises each counter to the higher value of the two merge parents.
- `merge-queue.mjs` calls it after every base merge, clean or resolved. If a file changes, the queue commits it with the subject `{id}: Regenerate shared files` before the push and prints `regenerated: {path}`.
- Tests: `test-0000481-req-001-regenerate.sh` and `test-0000481-req-001-queue-regenerates.sh`.
- ADR 0310 records the decision. `roadmap-standards.md` and `docs/architecture-overview.md` describe it.

## Why

On 2026-11-10 a clean base merge into PR #171 left `plan/backlog/index.md` stale. CI failed and the queue stopped (backlog entry 0000482).

## Deviations

The first edits went to the installed copy `ravintio-zero/`. I moved them to `src/ravintio-zero/` and refreshed the copy with `sync-installed.mjs`. The plan paths now name the source.

## Validation results

Full suite in a clean clone: 408 suites passed, 2 failed. Both failures come from the clean clone and pass in the worktree. Security rating: low.

## Skipped phases

None.
