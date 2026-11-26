# Changelog (0000581-delivery-cleans-up-driver-state, 26 Nov 2026)

**Feature:** Delivery cleans up driver state
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- `scripts/initiative-cleanup.mjs` cleans up the driver state after the human merges the initiative PR.
- The script refuses while `plan/.initiative-runner.lock` exists.
- It moves `plan/.initiative-logs/` and `plan/.initiative-control/` to `.git/ravintio-archive/{id}-{slug}/`. A numeric suffix keeps an existing target.
- It removes each worktree under `plan/.initiative-worktrees/`, runs `git worktree prune`, and prints a `Kept:` line for each item left in `plan/.initiative-queue/`.
- I-E Delivery has a new step 8 (`rm-delivery-cleanup`), and the initiative skill and final report name the cleanup.
- Two suites cover the script and the text. ADR 0353 records the decision.

## Why

I-E Delivery left the driver state in `plan/`. Initiative 0000360 left 17 control files and every step log. The status script then counted old steps for the next chart.

## Deviations

- The agent ran the units inline in one tree and dispatched no subagent, because each unit is small.
- Unit U-003 (docs) has no executable check. Backlog 0000410 tracks the rule.

## Validation results

Recorded in the build report.

## Skipped phases

None.
