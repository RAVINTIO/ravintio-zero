---
title: "Feature Brief - CodeQL and branch cleanup in CI"
summary: "CodeQL scans PRs into initiative branches, CI deletes merged head branches, and the P3 review names incomplete escaping."
status: "approved"
version: "0.1.0"
---
# Feature Brief - CodeQL and branch cleanup in CI

**Feature ID:** 0000355-codeql-and-branch-cleanup

## Business Goal

A PR into `initiative/**` gets a CodeQL scan, so an alert such as `js/incomplete-sanitization` surfaces on the step PR and not only on the initiative PR. CI deletes a merged PR's head branch, so the pack needs no repo setting from each developer. Pulled in from entries 0000346, 0000338, and 0000356.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| CodeQL workflow | As a maintainer, I get a CodeQL scan on each PR into `main` or `initiative/**`, so that a finding appears on the step PR. | must-have | 1 |
| Incomplete escaping in P3 | As a reviewer, I see incomplete escaping named in the P3 security checklist, so that a missed backslash is a finding. | must-have | 1 |
| Workflow job marker | As a pack maintainer, I add a CI job with a marker comment and need no edit to `test-0000169-req-006`, so that a new job does not fail the suite. The plan skill's test impact scan also names the workflow cause. | must-have | 1 |
| Branch cleanup job | As a developer, I find a merged PR's head branch deleted by CI, so that I change no repo setting. | must-have | 1 |
| Entry 0000323 update | As a maintainer, I read entry 0000323 as true, so that it drops the branch deletion item and says CodeQL runs from the workflow. | should-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero pack | component-pack | existing | Workflows, skills, setup, and tests |

### Data Ownership

None. No data store changes.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| GitHub Actions | GitHub API | workflow token | `contents: write` on the cleanup job only |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Node (`.mjs`), PowerShell, YAML |
| Testing | Bash test suites in `ravintio-zero/tests/`, run by `run-tests.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- `.github/workflows/codeql.yml` for JavaScript and GitHub Actions, on PRs into `main` and `initiative/**`.
- A `cleanup-branch` job in `ravintio-zero/hooks/ravintio.yml` and `.github/workflows/ravintio.yml` on `pull_request` `closed`.
- A marker comment on each job that the workflow-shape test reads, replacing its fixed name list.
- The workflow cause in the plan skill's test impact scan.
- Incomplete escaping in the P3 security checklist.
- The edit to entry 0000323.

### Out of Scope
- Turning off CodeQL default setup in repo settings. A human does it.
- The other items in entry 0000323.
- Hook changes.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Security | The cleanup job holds `contents: write` and no other job gains write | Workflow-shape test |
| Safety | The job never deletes `main`, `master`, or a fork head | Workflow-shape test |

## Constraints and Assumptions

### Constraints
- Every existing job in `ravintio.yml` skips the `closed` event.
- If the guard can't hold for a job, the cleanup moves to a separate workflow file that setup installs, in `setup.sh` and `setup.ps1`.

### Assumptions
- Repo default setup for CodeQL is turned off by a human before the step merges. If it is not, the step stops for the human.

## Scenario Paths

**Happy path:** A step PR into `initiative/**` runs CodeQL and the head branch disappears from `origin` after the squash.

> A PR opens, CodeQL scans it, CI passes, the squash merges, and the cleanup job deletes the head branch.

**First-run path:**

> A repo with no CodeQL workflow gets it from this change. A consumer repo gets the cleanup job from setup.

**Error / sad path:**

> If the branch is already gone, the job exits 0. If the PR closes unmerged, the job does nothing.

**Cross-session continuity:**

> Nothing is stateful. Each workflow run is independent.

## Acceptance Criteria

- [ ] `.github/workflows/codeql.yml` names `main` and `initiative/**` and both languages.
- [ ] The P3 checklist names incomplete escaping.
- [ ] A job with the marker comment needs no edit to `test-0000169-req-006`.
- [ ] The cleanup job holds `contents: write`, skips forks, and never targets `main` or `master`.
- [ ] Entry 0000323 drops the branch deletion item and says CodeQL runs from the workflow.
