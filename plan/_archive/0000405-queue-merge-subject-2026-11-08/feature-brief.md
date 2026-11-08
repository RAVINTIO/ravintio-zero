---
title: "Feature Brief - short subject for the queue's base merge"
summary: "The merge queue writes its own short subject when it merges the initiative branch into a step PR, so the commit-msg hook accepts it."
status: "approved"
version: "0.1.0"
---
# Feature Brief - short subject for the queue's base merge

**Feature ID:** 0000405-queue-merge-subject

Source: a human request during I-C Run of initiative 0000360, on 2026-11-08. The queue stopped on step 6.

## Business Goal

The merge queue merges the initiative branch into each step PR before CI. It ran `git merge --no-edit`, so git wrote its default subject. For `feat/0000382-install-lifecycle` that subject is 106 characters. The blocking `commit-msg` hook allows 72, so the queue stopped. Every ready PR behind the initiative head hits the same stop. The queue now writes a short subject of its own.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Short base-merge subject | As the coordinator of an initiative, I see the queue merge the initiative branch into a ready PR with a subject the `commit-msg` hook accepts, so that steps merge with no manual repair. | must-have | 1 |

## Wanted outcome

- The base merge commit has the subject `{7-digit id}: Merge the initiative branch`.
- With a blocking `commit-msg` hook and a long step branch name, the queue merges and continues.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `merge-queue.mjs` and its tests |

### Data Ownership

No data store. The component owns the pack files.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js script, bash tests already in the pack |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- The `-m` subject on the base merge in `cmdRun`.
- One test with a blocking `commit-msg` hook and a long branch name.
- A changelog entry.

### Out of Scope
- The other driver gaps from the 2026-11-08 postmortem.
- Any change to the `commit-msg` hook or `commit-standards.md`.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Subject length | 72 characters or fewer for any step | The new test |

## Constraints and Assumptions

### Constraints
- Never bypass the hook with `--no-verify`.
- No new library or service.

### Assumptions
- Every `Feature id` starts with 7 digits. Impact if wrong: the subject has no id prefix.

## Scenario Paths

**Happy path:** a ready PR is behind the initiative head. The queue merges the base with the short subject, pushes, and waits for CI.

**Alternative path:** the PR is already up to date. Git makes no commit, and the queue carries on as before.

**Error / sad path:** the merge conflicts. The queue aborts it and stops, as before.

**Cross-session continuity:** a restarted driver runs the new script.

## Acceptance Criteria

- [ ] The base merge commit has the subject `{7-digit id}: Merge the initiative branch`.
- [ ] With a blocking `commit-msg` hook and a long branch name, the queue merges and continues.
- [ ] The existing queue suites still pass.
