---
title: "Feature Brief - titled coordinator PRs"
summary: "Every change reaches an initiative branch as a titled squashed PR, coordinator changes included, and ship records the PR number before the squash."
status: "approved"
version: "0.1.0"
---
# Feature Brief - titled coordinator PRs

**Feature ID:** 0000318-titled-coordinator-prs

> Built from backlog entry 0000274 by initiative 0000312 step 6.

## Business Goal

In initiative 0000238, 23 of the 38 first-parent commits on the initiative branch were direct commits with other titles. Initiative 0000195 had 39 of 55. The pack tells the coordinator to commit queued entries, scope edits, the activation, the archive, and the retrospective directly on the initiative branch. Direct commits skip CI, and one of them broke a content test and stopped a step. Every commit on an initiative branch should be one titled squash.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| No direct commits on the initiative branch | As a maintainer, I want the roadmap standards and the initiative skill to route every coordinator change through a titled PR, so that the first-parent history is one titled squash per change. | must-have | 1 |
| Coordinator PR bar and carve-out | As a maintainer, I want the merge carve-out to name coordinator PRs and the bar they meet, so that the agent may land them without widening `merge-guard`. | must-have | 1 |
| PR number before the squash | As a reviewer, I want ship to record the PR number before the squash, so that no follow-up commit lands after it. | must-have | 1 |
| Guard unchanged | As a security reviewer, I want a test that pins what `merge-guard` allows, so that the carve-out change widens no hook. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All four | The standards and skills name no direct commit on the initiative branch, ship records the PR number before the squash, and the `merge-guard` tests pass unchanged. |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, hooks, tests, CI template |

### Data Ownership

No data store.

### Integration Points

None. The step changes skill and standards text, and adds tests.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, Node.js (ES modules), Markdown |
| Runtime | Node.js, Bash |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash and PowerShell test scripts with `helpers/assert.sh` |
| IaC | none |
| Cloud | none |
| Compute | local |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `roadmap-standards.md`: a rule that nothing commits directly on `initiative/*`, a coordinator PR section (title form, local suite, green CI, squash by the agent), and an updated I-E Delivery.
- `ravintio-initiative/SKILL.md`: queued entries, scope edits, activation, and delivery reach the branch as titled PRs, raised only while the driver is stopped.
- `ravintio-ship/SKILL.md`: the PR number goes into the changelog before the squash.
- `merge-guard` tests that pin the current allow and block set.
- The chart format in `initiative.md` and `initiative.template.md`, if the rule changes it.
- Docs and tests for each change.

### Out of Scope
- Any change to `merge-guard.mjs` behaviour.
- The history script and CI check (step 7).
- Changing the human-only initiative PR to `main`.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Strictness | `merge-guard` allows exactly what it allows today | Existing and new guard tests pass |

## Constraints and Assumptions

### Constraints
- Code and docs land together.
- No guard widens.

### Assumptions
- A coordinator PR into `initiative/*` already passes `merge-guard`, because the hook checks the base only. The step documents that and pins it with a test.

## Scenario Paths

**Happy path:** The coordinator batches queued entries while the driver is stopped, raises `0000312-...: queue entries (#n)`, waits for green CI, and squashes it.

**First-run path:** An initiative with no queued work raises no coordinator PR until delivery.

**Error / sad path:** CI fails on a coordinator PR. The coordinator stops and reports it, as for a step PR.

**Cross-session continuity:** Queued work stays in `plan/.initiative-queue/` until a stopped driver lets the coordinator raise the PR.

## Acceptance Criteria

- [ ] The roadmap standards and the initiative skill name no direct commit on the initiative branch.
- [ ] The standards define the coordinator PR title, the local suite, green CI, and the agent squash.
- [ ] The ship skill records the PR number before the squash.
- [ ] `merge-guard` allows exactly what it allows today, pinned by a test.
