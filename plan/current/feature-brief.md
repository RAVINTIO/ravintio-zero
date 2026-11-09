---
title: "Feature Brief - the merge queue waits for GitHub before it merges"
summary: "The merge queue waits until GitHub has checked the pushed head and reports the PR mergeable, and retries once, so it no longer stops with 'not mergeable'."
status: "approved"
version: "0.1.0"
---
# Feature Brief - the merge queue waits for GitHub before it merges

**Feature ID:** 0000411-queue-waits

Source: a human request during I-C Run of initiative 0000360, on 2026-11-09. The human answered "Yes go ahead" to the coordinator's proposed fix.

## Business Goal

The merge queue pushes a version commit to the step PR and calls `gh pr merge` straight away. GitHub has not yet checked the new head, so it answers "Pull Request is not mergeable". The same happens after the base merge push, because `gh pr checks --watch` can read the checks of the previous head and return at once. The queue stopped this way on steps 8, 9, 10, 11, 13, and 16, and each stop needed a manual retry. The queue now waits for GitHub before it merges.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Queue waits for GitHub | As the coordinator of an initiative, I see the queue merge a green, clean step PR without a "not mergeable" stop, so that steps merge with no manual retry. | must-have | 1 |

## Wanted outcome

- After each push, the queue waits until the PR head on GitHub is the pushed commit, then waits for CI on it.
- Before it merges, the queue waits until GitHub reports the PR `MERGEABLE` with a clean merge state.
- If the merge still fails with "not mergeable" or "Base branch was modified", the queue waits again and retries once.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `merge-queue.mjs` and its tests |

### Data Ownership

No data store.

### Integration Points

The GitHub CLI `gh`, through `pr view`, `pr checks`, and `pr merge`.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js script, bash tests already in the pack |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A wait for the pushed head, CI, and mergeability in `cmdRun`.
- One retry of `gh pr merge` on the two transient errors.
- The fake `gh` in tests 0000378 and 0000405 answers the new query.
- A new test where GitHub first reports the head stale and the PR `UNKNOWN`.

### Out of Scope
- Regenerating shared files on a conflict. That stays in the next initiative.
- Any change to `merge-guard` or branch protection.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Wait bound | The queue stops with a named error after 20 minutes of waiting | The new test, with a short limit |

## Constraints and Assumptions

### Constraints
- Never bypass a check or merge a PR whose checks failed.
- No new library or service.

### Assumptions
- `gh pr view --json headRefOid,mergeable,mergeStateStatus` reports the state GitHub uses to decide a merge. Impact if wrong: the queue can still hit the race, and the retry covers it.

## Scenario Paths

**Happy path:** the queue pushes, waits for the head, CI, and mergeability, then merges.

**Alternative path:** nothing to push. The queue still waits for mergeability, then merges.

**Error / sad path:** CI fails, or the wait passes its limit. The queue stops with a named error, as before.

**Cross-session continuity:** a restarted driver runs the new script.

## Acceptance Criteria

- [ ] With GitHub reporting a stale head and `UNKNOWN` at first, the queue waits and merges.
- [ ] The queue never calls `gh pr merge` before GitHub reports the PR mergeable.
- [ ] The existing queue suites still pass.
