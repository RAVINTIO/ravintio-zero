---
title: "Retrospective: 2026-11-12 - Driver removes merged step worktrees"
summary: "A blameless review of step 52, which made the driver sweep the worktrees of merged steps at start."
status: "open"
---
# Retrospective: 2026-11-12 - Driver removes merged step worktrees

> Path: `plan/retrospectives/0000501-remove-merged-worktrees-2026-11-12.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000501-remove-merged-worktrees
**Date:** 2026-11-12

## Summary

The driver now removes the safe worktree of each merged step at start and prints a `Kept:` line for the rest. The run took about 74 minutes with one self-correction.

## What helped

- The scheduler fixture and the keep-entries suite from step 50 gave a pattern for real worktrees and a stub queue (`src/ravintio-zero/tests/test-0000497-req-001-002-keep-entries.sh`).
- The fixture needed no new stub mode. The tests prepared each worktree before the driver started (`src/ravintio-zero/tests/test-0000501-req-001-004-sweep.sh`).

## What slowed the work

- The baseline run and the full suite took about 21 minutes each (build log, P2 and P0 notes).
- The new suite failed once in the full run. It read the ADR through a path that only works in `src/`, not in the installed copy (build log, P2).
- Pending migration 0009 had no human to confirm it, so the agent skipped it again (build log, P0 notes).

## Keep

- Test the keep cases by building the bad state first, then starting the real driver.
- Run the new suite in both `src/` and the installed copy before the full run.

## Change

- Record migration 0009 as done in the ledger so step sessions need no skip. Step 50 asked for the same change.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Ledger row for migration 0009 | pack maintainers | `plan/state/migrations.md` | resume detection reports no pending migration | none, because the coordinator can add the row directly |
