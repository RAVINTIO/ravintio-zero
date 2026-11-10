# Changelog (0000456-regenerate-shared-files-at-merge, 10 Nov 2026)

**Feature:** Regenerate shared files at merge
**Version:** set by the merge queue at merge
**PR:** 164

## What changed

- New `shared-files.mjs` resolves conflicts on a fixed list of shared files after the queue merges the base.
- Both `.next-id` files keep the higher value. The queue regenerates `plan/backlog/index.md`. `docs/decisions-index.md` and `docs/architecture-overview.md` keep the step's `Last updated:` line and both sides' added table rows.
- A conflict in any other file aborts the merge and stops the queue as before.
- `coordinator-pr-check.mjs` gains `--base`. It prints `overlap: #n path` and exits 1 when an open step PR touches a changed file.
- ADR 0302 records the decision.

## Why

Every merge edits the same shared files, so every other open step PR conflicted. Initiative 0000360 lost about six rounds of about an hour each. Backlog entry 0000430 asked for the fix.

## Deviations

- P2 ran inline without subagents, because the units share one file set.

## Validation results

- The clean-clone run passed 389 feature suites and 19 regression suites. Two suites failed, and both fail on the base commit.
- The 3 new suites pass.

## Skipped phases

None.
