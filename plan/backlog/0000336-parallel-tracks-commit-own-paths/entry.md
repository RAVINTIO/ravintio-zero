---
title: "Backlog Entry: 0000336 - parallel tracks commit only their own paths"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000336 - parallel tracks commit only their own paths

**Source feature:** 0000320-quiet-session-start
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01
**Source retrospective:** `plan/retrospectives/0000320-quiet-session-start-2026-11-01.md`

---

## Problem

Parallel P2 tracks share one working tree and one git index. In step 8, a track's staged files went into another track's commit, and a later `git commit --amend` folded a test fix into an unrelated commit. The dispatch standard says to stage by explicit path, but a plain `git commit` still takes everything staged.

## Suggested Action

- In `ravintio-zero/standards/agent-dispatch-standards.md` (`## Fast batches`), tell each unit to commit with `git commit -m "{message}" -- {paths}` so the commit takes only those paths.
- Forbid `git commit --amend` in a batch.
- Add a test that checks the standard names both rules.

## Wanted outcome

Each parallel track's commit holds only the paths that track wrote. A test checks that `agent-dispatch-standards.md` states the `-- {paths}` form and the amend ban.

## Why Deferred

The run found it after the batch finished. The fix changes a standard, which is outside the scope of step 8.
