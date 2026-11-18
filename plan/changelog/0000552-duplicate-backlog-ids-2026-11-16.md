# Changelog (0000552-duplicate-backlog-ids, 16 Nov 2026)

**Feature:** Two open entries share one backlog id
**Version:** set by the merge queue at merge
**PR:** 242

## What changed

`backlog-index.mjs --check` exits 1 when two backlog entry folders share an id. It prints one `check: duplicate backlog id {id}: {folders}` line for each duplicate. CI and the pre-push hook already run `--check`, so each catches the next duplicate. A new suite covers a duplicate, unique ids, the generate mode, and `--review`.

## Why

Entries 0000476-ack-write-mid-suite-fails-run and 0000476-plan-only-push-short-ci shared one id for three days, because no check reported it.

## Deviations

The backlog entry also asked to renumber one entry. The base holds no duplicate now, so nothing needs a renumber. The entry also implied a failure in every mode. The check runs in `--check` only, because the merge queue runs the generate mode before `id-collisions.mjs` renumbers a duplicate (ADR-0350).

## Validation results

The full suite passes apart from the three inherited suites. The clean-clone run, the CLI checks, and the prose check pass. This step folds in backlog entry 0000542.

## Skipped phases

None
