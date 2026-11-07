# Changelog (0000378-merge-time-versioning, 07 Nov 2026)

**Feature:** Merge-time versioning
**Version:** 0.58.0
**PR:** 127

## What changed

- `ravintio-zero/version-files.txt` lists the version files once. `scripts/version-files.mjs` has `check` and `set`, and ship Step 6 runs both.
- `scripts/merge-queue.mjs` adds `title`, `versions`, and `run`. `run` checks the PR title, merges the initiative branch into the PR branch, waits for CI, sets the version from the step's `Bump`, checks every version file, records the merge in the chart, squash-merges, and tags the merge commit.
- I-D Advance runs `merge-queue.mjs title` before the squash.
- `reshape-initiative.mjs` and `check-initiative-history.mjs` sort steps by the chart `Version` column, which is merge order.
- On a replay conflict, the reshape folds earlier admin commits into the next step and prints each fold. It keeps a fold only if the final tree equals the old head and the history check passes.
- The initiative template gains a `## Merges` table. The roadmap standards gain a merge queue section.
- Four new suites cover the changes. Backlog entries 0000374, 0000376, 0000372, and 0000368 are pulled in and deleted.

## Why

Steps that run at once cannot each compute a version in P4. The queue sets versions in merge order. A PR title with the slug and a missed version file also reached CI or delivery before anything caught them.

## Deviations

- The queue merges the initiative branch into the PR branch rather than rebasing it (ADR-001), because the repo rules forbid force-pushes.
- The driver does not call the queue yet and P4 still sets the version, as the chart decision for steps 1 and 2 says. Step 3 wires the driver and removes the P4 version edits.
- Existing test `test-0000353-req-001-004-reshape-script.sh` now passes `--assign` in its req-003 AC-1 fixture, because the new fold clears the conflict that the old fixture relied on.
- No test reaches the version-file mismatch branch or the rerun-safety branch of `run`. The `versions` command is tested on a differing file directly.

## Validation results

- The full suite passes: 293 feature suites and 19 regression suites.

## Skipped phases

None
