# Changelog (0000353-reshape-at-delivery, 06 Nov 2026)

**Feature:** Reshape at delivery
**Version:** 0.51.0
**PR:** #113

## What changed

- `ravintio-zero/scripts/reshape-initiative.mjs` rebuilds an initiative branch as one titled commit per step, then one chore commit whose tree equals the old head. It writes the branch `{branch}-reshaped` and leaves the old branch in place. It finds each step through its `v{Version}` tag, replays with `git merge-tree --write-tree` and `git commit-tree`, and folds in the admin commits that `--assign` names.
- With `--tags` the script moves each local step tag. With `--push` it also pushes the new branch, deletes each old tag on `origin` with a delete refspec, and pushes a new tag with the same name and message. No command in the script uses `--force`.
- A replay conflict, a missing tag, a bad name, or an existing target branch exits 1 and writes no branch. The script runs `check-initiative-history.mjs` on the new branch.
- `### I-E Delivery` in `roadmap-standards.md` and `## I-E Delivery` in the initiative skill state the reshape, the tag move, the PR from the reshaped branch, and the old branch cleanup.
- The ship skill's `## PRs into main` drops `--force-with-lease`. A multi-commit `chore/*` or `hotfix/*` PR uses the replacement branch route.
- Backlog entry 0000345 is pulled in and deleted. Rule 3 was its last open rule.

## Why

Initiative 0000312 needed a branch rewrite and ten tag moves by force before review. The human ruled that nothing force-pushes a branch or a tag. The reshape now builds the same history on a new branch.

## Deviations

None.

## Validation results

- The full suite passes: 266 feature suites and 19 regression suites, after one fix to the build log note that the old-name guard flagged. The consistency check is clean.
- 11 criteria verified by execution. 0 not-verifiable. Security review found no critical, high, or medium findings.

## Skipped phases

None.
