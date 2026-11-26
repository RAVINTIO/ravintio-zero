# Changelog (0000583-step-temp-cleanup-after-merge, 18 Nov 2026)

**Feature:** Give each step session a private temp folder
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The driver gives each step session a private temp folder at `{worktree}/.t`. It sets `TMPDIR` and `GIT_CEILING_DIRECTORIES` to that folder and runs the session in the Claude Code sandbox.
- The driver stops at start if the folder path leaves no room for a Unix socket name.
- After a merge, the driver removes the step worktree and runs `git worktree prune`. It deletes nothing outside the repo.
- Five suites and the git-isolation helper exit on `TERM`, `INT`, and `HUP`, so their `EXIT` traps remove their temp folders. `run-tests.sh` gives every suite a private `TMPDIR`.
- The implement skill and the testing standards tell the agent to put scratch under `$TMPDIR`.
- Four suites cover the changes. ADR 0352 records the decision.

## Why

On 2026-11-14 leaked temp entries filled the disk and the driver stopped with `ENOSPC`.

## Deviations

- The human changed the scope on 2026-11-26. The first design deleted `step{n}*` paths by name in `/tmp`, and the driver suites removed another project's files. The agent removed that code and built the private temp folder instead.
- The sandbox allows writes to the worktree, the root git folder, and the control folder.
- The agent ran units U-001 to U-003 inline in one tree and dispatched no subagent, because each unit is small.
- Unit U-003 (docs) has no executable check. Backlog 0000410 tracks the rule.
- `0000029` had no `EXIT` trap, so the agent added one.

## Validation results

Recorded in the build report.

## Skipped phases

None.
