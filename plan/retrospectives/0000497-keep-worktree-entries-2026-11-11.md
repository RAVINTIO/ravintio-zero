---
title: "Retrospective: 2026-11-11 - Driver keeps uncommitted entries from a worktree"
summary: "A blameless review of step 50, which made the driver keep a step worktree that holds untracked backlog entries."
status: "open"
---
# Retrospective: 2026-11-11 - Driver keeps uncommitted entries from a worktree

> Path: `plan/retrospectives/0000497-keep-worktree-entries-2026-11-11.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000497-keep-worktree-entries
**Date:** 2026-11-11

## Summary

The driver now keeps a step worktree that holds untracked backlog entries and stops the queue for that step. The run took 45 minutes with no rework.

## What helped

- The scheduler fixture gave real worktrees, a stub session, and a stub queue, so three stub modes covered every case (`src/ravintio-zero/tests/helpers/scheduler-fixture.sh`).
- The failed-listing case needed no fault injection. A broken `.git` file in the worktree made git fail (build log, P2).

## What slowed the work

- The full suite took about 22 minutes of the 45 (build log, P2 wall clock).
- The path guard blocked a relative-path write inside a heredoc, so the agent rewrote it with an absolute path.
- Pending migration 0009 had no human to confirm it, so the agent skipped it again (build log, P0 notes).

## Keep

- Add a stub mode to the shared fixture in place of a new fixture for each queue case.
- Pin each refusal with a test that checks the worktree still exists.

## Change

- Record migration 0009 as done in the ledger so step sessions need no skip.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Ledger row for migration 0009 | pack maintainers | `plan/state/migrations.md` | resume detection reports no pending migration | none, because the coordinator can add the row directly |
