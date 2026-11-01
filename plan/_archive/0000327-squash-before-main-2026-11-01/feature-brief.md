---
title: "Feature Brief - Squash before main"
summary: "A PR into main from outside an initiative holds one commit, and CI fails a PR that does not."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Squash before main

**Feature ID:** 0000327-squash-before-main

## Business Goal

`main` accepts merge commits only. A chore branch with several commits then adds each commit to the history of `main`, as PR #73 did. This feature makes every PR into `main` from outside an initiative arrive as one titled commit, and names which branches may target `main`.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Squash rule in the ship skill | As a maintainer, I want the agent to squash a branch to one commit before it asks me to merge, so that `main` gains one titled commit per chore or hotfix. | must-have | 1 |
| Branch naming rule | As a maintainer, I want only `initiative/*`, `chore/*`, and `hotfix/*` branches to target `main`, so that a feature never skips an initiative. | must-have | 1 |
| CI check on PRs into main | As a maintainer, I want CI to fail a PR that breaks the rule, so that the rule holds when the agent forgets. | must-have | 1 |
| Hotfix cut | As a maintainer, I want a run outside an initiative to cut a `hotfix/` branch, so that the branch name says it targets `main`. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Ship skill, orchestrator text, standards, script, and CI workflow |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| CI | `check-pr-into-main.mjs` | command line | Exit 1 when the PR breaks the rule, exit 2 on a usage or git error |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js, built-in modules only |
| Testing | Bash suites |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A script that checks the head branch name and commit count of a PR into `main`.
- A CI job in the tracked workflow and the pack copy.
- The squash rule, the `--force-with-lease` limit, the replacement-PR rule, and the CI wait in the ship skill.
- The three allowed branch prefixes in the roadmap standards and `docs/main-ruleset.md`.
- Discovery Start Actions step 2 cuts `hotfix/{feature-id}` for a run outside an initiative.
- Tests and docs.

### Out of Scope
- Any change to a hook. No hook blocks a force-push today and none is added.
- Editing `CLAUDE.md` or `ravintio-overrides/instructions/custom-001-local-git-only.md`.
- Applying the GitHub ruleset. The human does that.

### Deferred
- none

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | The same refs give the same exit code | Test runs the script twice |
| Security | The job gains no token scope and passes the branch name as an environment variable, never inline | Test reads the workflow |

## Constraints and Assumptions

### Constraints
- Code and docs land together. No new library.
- The force-push permission covers `chore/*` only. Never `hotfix/*`, `feat/*`, `main`, or `initiative/*`.

### Assumptions
- A PR into `main` has its head commits reachable as `origin/{head ref}` after a full checkout.

## Scenario Paths

**Happy path:** A `chore/*` or `hotfix/*` PR into `main` holds one commit on top of `origin/main`. CI passes and the agent asks the human to merge.

**First-run path:** A `chore/*` PR holds several commits. The check fails, the agent squashes in place, pushes with `--force-with-lease`, and waits for green CI.

**Error path:** A `feat/*` PR targets `main`, or a `hotfix/*` PR holds two commits. The check fails. For the hotfix, the agent raises a replacement PR from a new branch cut from `origin/main` and closes the old one with a link.

**Cross-session continuity:** CI runs the check on every PR into `main`, so a later session or a PR raised by hand meets the same rule.
