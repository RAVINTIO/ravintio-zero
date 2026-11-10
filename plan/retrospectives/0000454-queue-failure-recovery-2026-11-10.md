---
title: "Retrospective: 2026-11-10 - Queue failure recovery"
summary: "A blameless review of step 31 of initiative 0000360, and the change it files."
status: "open"
---
# Retrospective: 2026-11-10 - Queue failure recovery

**Mode:** run
**Subject:** 0000454-queue-failure-recovery
**Date:** 2026-11-10

## Summary

The queue now reverts a stale set-version commit on a rerun and detaches its worktree after every run. The run had no rework and no stop.

## What helped

- The backlog entry named the evidence rows and the retrospective section, so P0 needed no question (`plan/_archive/0000454-queue-failure-recovery-2026-11-10/design.md`).
- A fake `gh` that fails only after the head holds a set-version commit let one suite reproduce the failure with real git (`src/ravintio-zero/tests/test-0000454-req-001-queue-failure-recovery.sh`).
- The suite failed 9 of 18 checks before the change, so the red phase proved the fix (build log P2, RED line).

## What slowed the work

- The clean-clone suite takes about 25 minutes. The baseline and the post-change runs overlapped, which cost the most wall clock (build log P2 block).
- The first plan commit had to be redone after the gate-write hook rejected a command that used `cd` into `plan/current/` (build log P1 block).
- The prose check rejected commits twice for passive voice and long sentences in plan files. It named the lines, and each fix took one commit.

## Keep

- Run the baseline suite in the background at P0 start (`discovery.md`, baseline step).

## Change

- Add a way to restore files that a failed queue run wrote and did not commit. Entry 0000477 holds it (`plan/backlog/0000477-queue-failure-leaves-dirty-files/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Restore files after a failed queue run | initiative 0000360 coordinator | `src/ravintio-zero/scripts/merge-queue.mjs` | A test with a commit that a hook rejects | Backlog entry 0000477, from this retrospective |
