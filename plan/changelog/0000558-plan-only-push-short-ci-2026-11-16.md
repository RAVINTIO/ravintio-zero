# Changelog (0000558-plan-only-push-short-ci, 16 Nov 2026)

**Feature:** CI avoids extra runs on a plan-only push
**Version:** set by the merge queue at merge
**PR:** 241

## What changed

The repo workflow `.github/workflows/ravintio.yml` has a top-level `concurrency` block. A newer push to a pull request cancels the older run of that pull request. A push run keys on its commit, so it is never cancelled. A `closed` event has a group of its own. A new suite checks the block and the absence of path filters.

## Why

The closing archive push of a step changes only `plan/` files, yet CI reran every suite while the older run kept using runners. Entry 0000476 asked for a short path. The chart row for step 14 cuts that back, so every push still runs every suite.

## Deviations

The chart criterion "A plan-only push runs fewer suites" holds only as fewer runs. The chart row wins. The backlog entry asked for a short path, and that stays deferred. The consumer copy `hooks/ravintio.yml` has no block, because it needs a consumer migration.

## Validation results

The full suite in a clean clone shows 477 passed and 3 failed. The base already fails those 3. The new suite passes 18 of 18 assertions. The security review finds nothing above low.

## Skipped phases

None
