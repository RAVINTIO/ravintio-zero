---
title: "Feature Brief - Check mergeability before a CI wait"
summary: "The step and the merge queue read PR mergeability before and during a CI wait, so a conflicting PR never waits for checks that cannot arrive."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Check mergeability before a CI wait

**Feature ID:** 0000483-mergeability-before-ci-wait

Source: backlog entry 0000484, from the initiative 0000360 retrospective (evidence row 28).

## Business Goal

PR #166 for step 36 conflicted with the initiative branch after other steps merged. GitHub runs no pull request workflows on a conflicting PR, so no check registered. Step 36 waited about 69 minutes for checks that could not arrive. The merge queue can wait the same way. The step and the queue now read `mergeable` before and during a CI wait and stop with a named error.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Mergeability check in the merge queue | As a coordinator, I see the queue stop at once on a conflicting PR, so that a run never waits 30 minutes for absent checks. | must-have | 1 |
| Mergeability check in the step | As a step session, I merge the initiative branch into a conflicting PR before I wait for CI, so that checks register. | must-have | 1 |

## Wanted outcome

- Before the CI poll, the step reads `gh pr view --json mergeable`. If the PR is `CONFLICTING`, it merges the initiative branch, pushes, and reads again.
- While the queue waits for checks, it reads `mergeable`. If the PR is `CONFLICTING`, it stops with a named error.
- A wait that sees no checks after a set time stops with a named error.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the merge queue script, the roadmap standards, and the ship skill |

### Data Ownership

No data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| merge-queue.mjs | GitHub | `gh pr view --json mergeable` | Returns `MERGEABLE`, `CONFLICTING`, or `UNKNOWN` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js script and Markdown standards already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` with a stub `gh` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- `waitForChecks` in `merge-queue.mjs` reads `mergeable` and stops on `CONFLICTING`.
- A no-checks timeout in `waitForChecks` with a named error.
- The I-D Advance wait in `roadmap-standards.md` and the ship skill reads `mergeable` first.
- A test, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- Resolving conflicts that are not on shared files.
- A change to the driver or the watcher.
- A change to any guard or hook.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Stop latency | A conflicting PR stops the queue within one poll | the new suite, with `MQ_POLL_MS` set low |
| No-checks timeout | Default 10 minutes, set with `MQ_NOCHECKS_MS` | the new suite |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The change widens no guard.
- Node.js built-ins only in the script.

### Assumptions
- GitHub reports `mergeable: CONFLICTING` for a PR that conflicts with its base. Impact if wrong: the no-checks timeout still stops the wait.
- `UNKNOWN` is transient, so the queue keeps polling on it. Impact if wrong: the no-checks timeout stops it.

## Scenario Paths

**Happy path:** the PR is `MERGEABLE`, checks register, and the wait ends when they pass.

**First-run path:** not applicable.

**Error / sad path:** the PR is `CONFLICTING` and no check registers. The queue stops with `PR #k conflicts with {base}` and the step merges the base first. If no check appears for 10 minutes on a `MERGEABLE` PR, the queue stops with `no CI checks appeared`.

**Cross-session continuity:** a stopped queue run restarts with `run`, which merges the base first.

## Acceptance Criteria

- [ ] `merge-queue.mjs` stops with a named error when the PR is `CONFLICTING` and no checks have appeared.
- [ ] `merge-queue.mjs` stops with a named error when no checks appear after `MQ_NOCHECKS_MS`.
- [ ] A `MERGEABLE` PR with passing checks still passes.
- [ ] `roadmap-standards.md` and the ship skill tell the step to read `mergeable` before the CI poll.
