---
title: "Feature Brief - Queue failure recovery"
summary: "The merge queue recovers cleanly after a failed run."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Queue failure recovery

**Feature ID:** 0000454-queue-failure-recovery

> Built from backlog entry 0000429 by initiative 0000360, step 31.

## Business Goal

A failed queue run leaves two kinds of state behind. Coordinators fix both by hand. The queue should leave neither behind and should recover on a rerun with no manual step.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Take base version rows on rerun | As an initiative coordinator, I rerun a failed queue run, so that the version rows no longer conflict with the base branch. | must-have | 1 |
| Detach the queue worktree after every run | As an initiative coordinator, I restart a step after a failed queue run, so that the step branch is free to check out. | must-have | 1 |
| Restart test | As a maintainer, I run the restart path in a test, so that a regression in either fix fails CI. | must-have | 1 |

## Waves

One wave. All three features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Owns `merge-queue.mjs` and its tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Step branch version commits | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `merge-queue.mjs` | `git`, `gh` | CLI | Argument arrays only. Never rewrite pushed history (ADR-0260). |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js scripts and bash test suites |
| Testing | bash suites under `src/ravintio-zero/tests/` with a fake `gh` shim |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- The queue takes the base version rows back before it merges the base on a rerun. This applies when an earlier run left a set-version commit on the branch.
- The queue detaches its worktree after every run, including a failed run.
- A restart test that covers both fixes.

### Out of Scope
- The rerun-safety branch test and the version-mismatch test. Entry 0000400, step 36, covers them.
- The driver's detach at the start of a queue run.
- Any rewrite of pushed history.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The queue never force-pushes or rewrites pushed history | Test asserts the remote branch only gains commits |

## Constraints and Assumptions

### Constraints
- ADR-0260: the queue merges the base into the PR branch and never rebases.
- The commit-msg hook limits subjects to 72 characters and bans affirmatory language.
- Source lives in `src/ravintio-zero/`. The installed copy `ravintio-zero/` must match after `sync-installed.mjs`.

### Assumptions
- The queue worktree belongs to the queue. Detaching it loses no work.

## Scenario Paths

**Happy path:** A queue run succeeds as today. The worktree ends detached.

**First-run path:** A PR branch with no earlier set-version commit takes the existing path with no revert.

**Error / sad path:** CI fails after the version push. Another step then merges and moves the base version. The rerun reverts the stale set-version commit, merges the base cleanly, sets the new version, and merges the PR. A failed run leaves the queue worktree detached.

**Cross-session continuity:** The driver restarts after a failed run. It checks out the step branch in a new worktree because the queue worktree no longer holds it.

## Acceptance Criteria

- [ ] AC-1: After a failed run and a base version change, a rerun merges with no conflict and sets the new version.
- [ ] AC-2: A rerun with an unchanged base version adds no commit.
- [ ] AC-3: After a failed run, the queue worktree sits on a detached HEAD and another worktree can check out the step branch.
- [ ] AC-4: After a successful run, the queue worktree sits on a detached HEAD.
- [ ] AC-5: No run force-pushes. The remote step branch only gains commits.
