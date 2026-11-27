---
title: "ADR 347: The queue restores the files it wrote when a run fails"
summary: "A failed queue run restores the chart and the version files to HEAD before the commit lands, and touches no other path."
status: "accepted"
component: "ravintio-zero"
feature: "0000546-queue-failure-leaves-dirty-files"
version: "0.1.0"
---
# ADR-0347 - The queue restores the files it wrote when a run fails

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000546-queue-failure-leaves-dirty-files
**Component:** ravintio-zero
**File:** `docs/adr/0347-queue-restores-the-files-it-wrote.md`
**Date:** 2026-11-15

## Context

The queue writes the version files and the chart, then stages and commits them. If the commit fails, the written files stay changed in the queue worktree. The next run stops with `working tree is not clean`. ADR-0299 detaches HEAD after every run. It leaves the files alone.

## Decision

If a run fails after the write and before the commit lands, the queue restores the chart and the version files to HEAD. The restore covers the index and the working tree. It uses `git restore` on those named paths. It prints a `restored:` line when a path changed. The original failure stays the exit message. The queue never runs `git reset --hard` or `git clean`, and it never touches another path.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `git reset --hard` in the queue worktree | One command | Discards any tracked change, written or not | The chart row allows only the files the run wrote |
| `git clean` and a hard reset at the start of the next run | Covers every cause | Hides the failure and discards unknown files | Too wide for a worktree that others may inspect |
| Leave the cleanup to the coordinator | No code | Needs a person on each failure | It is the problem |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `merge-queue.mjs` restores its written files on a failure before the commit lands. |

## Consequences

**Positive:**
- A rerun after a rejected commit starts on a clean tree with no manual step.

**Negative:**
- The queue holds one more failure path to test.

**Risks:**
- A wrong path list would restore a file that the queue did not write. The test checks an untracked file.

## Related ADRs

- ADR-0299 - extends

## Supersedes

- None.

## Superseded By

- None.
