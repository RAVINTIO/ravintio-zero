---
title: "ADR 001: The merge queue merges the initiative branch into the PR branch"
summary: "The queue updates a step PR by merging the initiative branch into it, because the step rules forbid force-pushes."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000378-merge-time-versioning"
---
# ADR-0260 - The merge queue merges the initiative branch into the PR branch

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Backlog entry 0000374 says the queue rebases each PR on the initiative branch. A rebase rewrites a pushed branch and needs a force-push. The repo rules forbid force-pushes. The squash merge drops the extra merge commit from history.

## Decision

Before each merge, the queue merges the initiative branch into the PR branch with `git merge` and pushes it without force. The queue then sets the version, writes the chart row, and squash-merges.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Rebase and force-push | Linear PR branch | Needs force-push | Repo rules forbid it |
| Merge, no update | Fewer steps | The chart row and version conflict at merge | A stale base breaks the version |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `merge-queue.mjs` uses `git merge` |

## Consequences

**Positive:**
- No force-push. The squash keeps history linear.

**Negative:**
- The PR branch holds a merge commit until the squash.

**Risks:**
- A merge conflict stops the queue and needs the step session to resolve it.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
