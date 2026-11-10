---
title: "ADR 298: The queue reverts a stale version commit and detaches after every run"
summary: "A rerun reverts an earlier set-version commit when the base version moved, and the queue detaches its worktree when a run ends."
status: "proposed"
component: "ravintio-zero"
feature: "0000454-queue-failure-recovery"
version: "0.1.0"
---
# ADR-0298 - The queue reverts a stale version commit and detaches after every run

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Component:** ravintio-zero
**File:** `docs/adr/0298-queue-reverts-stale-version-commit.md`
**Date:** 2026-11-10

## Context

A failed queue run can leave a set-version commit on the step branch. Another step then merges and moves the base version. The next merge of the base conflicts on the version rows. ADR-0260 forbids a rebase and a force-push, so the queue cannot drop the commit.

The queue also switches its worktree to the step branch and never leaves it. A restart cannot check out that branch while the queue worktree holds it. Coordinators fixed both cases by hand.

## Decision

Before the queue merges the base on a rerun, it reads the next version from the base. It selects the set-version commits for this step that the base lacks. If any holds another version, the queue reverts them in one commit and pushes it without force. The queue then merges the base as before.

The queue detaches its worktree when `run` ends, on success and on every failure.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Check out the version files from the base | One step | Drops any other edit the step made to those files | Loses step work |
| Reset the branch to before the commit and force-push | Clean history | Rewrites pushed history | ADR-0260 forbids it |
| Resolve the conflict by hand | No code | Needs a coordinator each time | It is the problem |
| Detach only at the start of the next queue run | Already in the driver | A restart before that run still fails | Leaves the gap |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `merge-queue.mjs` reverts a stale commit and detaches in a `finally` block |

## Consequences

**Positive:**
- A rerun merges with no hand fix.
- A restart can check out the step branch at once.
- History only grows, so ADR-0260 still holds.

**Negative:**
- A rerun after a base change adds one revert commit and one set-version commit to the PR branch. The squash hides both.

**Risks:**
- A revert can conflict with a later change to the same lines. The queue stops with the git error and leaves the branch as it was.

## Related ADRs

- ADR-0260 - extends

## Supersedes

- None

## Superseded By

- None
