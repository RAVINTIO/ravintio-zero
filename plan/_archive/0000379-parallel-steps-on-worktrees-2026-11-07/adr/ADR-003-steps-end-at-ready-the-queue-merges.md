---
title: "ADR 003: A step ends at ready and the driver runs the merge queue"
summary: "A step ends at ready and the driver runs the merge queue"
status: "accepted"
version: "0.1.0"
---
# ADR-003 - A step ends at ready and the driver runs the merge queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Two steps that merge themselves would compute the same version and race on the chart. Step 2 built a serial merge queue that sets each version at merge.

## Decision

Under the concurrent driver a step raises its PR, waits for CI, writes the PR number to its control folder, and ends. The driver removes the step worktree and runs `merge-queue.mjs run` in a queue worktree, one PR at a time. Without the driver the step runs the queue itself. P4 sets no version.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| The step merges itself | Fewer moving parts | Races on version and chart | The queue exists to prevent it |
| The step session runs the queue under a lock | No driver change | A session holds a lock while it waits for CI | A crashed session strands the lock |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `ravintio-ship` skill text, roadmap standards, `merge-queue.mjs`, and the driver. |

## Consequences

**Positive:**
- Versions follow merge order with no race.

**Negative:**
- The step needs a worktree release before the queue can switch to its branch.

**Risks:**
- A queue stop leaves a ready PR that needs the coordinator.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
