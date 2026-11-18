# Changelog (0000583-step-temp-cleanup-after-merge, 18 Nov 2026)

**Feature:** Clean up step temp files after each merge
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The driver removes a merged step's `step{n}` temp paths and extra worktrees after the merge and at start, then runs `git worktree prune`. `step1` never matches `step10`.
- Five suites and the git-isolation helper exit on `TERM`, `INT`, and `HUP`, so their `EXIT` traps remove their temp folders. `run-tests.sh` does the same for its git config file.
- Two suites cover both changes. ADR 0352 records the decision.

## Why

On 2026-11-14 leaked temp entries filled the disk and the driver stopped with `ENOSPC`.

## Deviations

- The agent ran units U-001 to U-003 inline in one tree and dispatched no subagent, because each unit is small.
- Unit U-003 (docs) has no executable check. Backlog 0000410 tracks the rule.
- `0000029` had no `EXIT` trap, so the agent added one.

## Validation results

Recorded in the build report.

## Skipped phases

None.
