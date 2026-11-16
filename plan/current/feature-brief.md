---
title: "Feature Brief - CI avoids extra runs on a plan-only push"
summary: "The workflow cancels a superseded run on the same pull request and runs every suite on every push."
status: "approved"
version: "0.139.0"
---
# Feature Brief - CI avoids extra runs on a plan-only push

**Feature ID:** 0000558-plan-only-push-short-ci

## Business Goal

An initiative step ends with a closing push that changes only `plan/` files and sentinels. CI reruns every suite for it. The step waits for that run before `ready`, and any older run for the same pull request keeps using runners. The chart cuts back backlog entry 0000476: every push still runs every suite, so no guard weakens.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Cancel a superseded run | As a step session, I want CI to cancel an older run on a newer push, so that only the newest head uses runners. | must-have | 1 |
| Keep every suite on every push | As a reviewer, I want a push that changes `plan/` to run every suite, so that every check still runs. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the workflow, its consumer copy, and the tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `.github/workflows/ravintio.yml` | ravintio-zero | none |

### Integration Points

GitHub Actions concurrency groups.

## Stack

Bash tests, YAML workflow, Node scripts. Build target: none.

## Scope Boundaries

### In Scope

- A `concurrency` block in `.github/workflows/ravintio.yml` and in its consumer copy `src/ravintio-zero/hooks/ravintio.yml`.
- Tests for the block.

### Out of Scope

- A change to the ship skill. The closing push is already one push.
- Skipping any suite or job on a plan-only push.
- Path filters on any job.

### Deferred

Nothing deferred.

## Non-Functional Requirements

A run for a superseded head ends within one push of the newer head.

## Constraints and Assumptions

### Constraints

- Every push runs every suite.
- Pushes to `main` and `master` never cancel each other, because each merge needs its release tag.
- A `closed` event never cancels a validation run.

### Assumptions

- GitHub Actions groups runs by the expression in `group`.

## Scenario Paths

1. Happy path: a step pushes twice in a row. CI cancels the first run and runs every suite on the second.
2. First-run path: the first push to a pull request starts a run with no run to cancel.
3. Error path: a cancelled run leaves no required check red, because the newer run reports the checks.
4. Cross-session continuity: the group key reads only the pull request number, so a resumed session joins the same group.

## Acceptance Criteria

- AC-1: The workflow holds a `concurrency` block that cancels in-progress runs for a `pull_request` event.
- AC-2: The block never cancels a run for a push to `main` or `master`.
- AC-3: A `closed` event uses a group of its own.
- AC-4: No job loses its `if` guard, and no job gains a path filter.
