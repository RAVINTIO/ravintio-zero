---
title: "Feature Brief - Ship postmortems"
summary: "Ship fails when a stop or a self-correction has no postmortem, every postmortem holds all three CAPA types, and the merge queue waits for CI after its version push."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Ship postmortems

**Feature ID:** 0000392-ship-postmortems

## Business Goal

No run has written a postmortem unprompted. Initiative 0000238 logged `Blocked:`, `Resolved:`, and `Rework:` lines in 12 of 15 steps and wrote none. A check in ship closes that gap, and a stricter record format makes each postmortem file its actions. The merge queue also stopped two steps on avoidable errors, so the step fixes both. Source backlog entries: 0000285 and 0000403.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Ship check (0000285) | As a reviewer, I see ship fail when a stop or a rework has no `Postmortem:` line, so that every stop leaves a record. | must-have | 1 |
| CAPA record check (0000285) | As a maintainer, I see a postmortem fail when it lacks a corrective, preventive, or detective row, so that no record skips an action type. | must-have | 1 |
| Corrective work row (0000285) | As a maintainer, I record the fix made during the run as a done row with its commit or PR, so that the record shows what already closed. | should-have | 1 |
| Resolved line after an outside fix (0000285) | As a maintainer, I find a `Resolved:` line when someone clears a stop outside the step session, so that the log pairs every stop. | should-have | 1 |
| Queue waits for CI (0000403) | As a coordinator, I want the merge queue to wait for every check on the version commit it pushes, so that GitHub does not refuse the merge. | must-have | 1 |
| PR title form (0000403) | As a coordinator, I want P4 to raise a PR whose title passes `merge-queue.mjs title`, so that the queue does not stop on a title mismatch. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack scripts, skills, standards, templates, and tests |

### Data Ownership

None. The pack has no data store.

### Integration Points

The merge queue calls `gh` and `git` through argument arrays (existing).

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js and Bash (existing) |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions (existing) |
| Build target | local |

## Scope Boundaries

### In Scope
- `build-log-check.mjs` finds a `Resolved:` line or a rework requirement with no `Postmortem:` line, and checks each named record.
- `postmortem-check.mjs` checks a record for one row of each CAPA type, and accepts a "none, because" row.
- The postmortem template and skill gain the CAPA table and the done row.
- The orchestrator references name the postmortem for each rework requirement and the `Resolved:` line for an outside fix.
- `merge-queue.mjs` waits for every check after its version push, and stops with the failing check name.
- The ship skill points P4 at `merge-queue.mjs title` and the queue title form.
- Tests, `component.yml`, and docs describe the changes.

### Out of Scope
- Writing the postmortems for earlier initiatives.
- A hook that blocks a commit without a postmortem.
- Changes to the retrospective skill.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Queue wait | The queue polls every 10 seconds and stops after 30 minutes | A test with a stub `gh` and a short poll interval |

## Constraints and Assumptions

### Constraints
- Bash 3.2 on macOS and Git Bash on Windows.
- The queue builds every `git` and `gh` call from an argument array.

### Assumptions
- `gh pr checks --json name,bucket` exists in the installed `gh`. If it does not, the queue stops with the `gh` error.

## Scenario Paths

**Happy path:** A run has one stop and one rework. The orchestrator writes two postmortems before ship. Ship passes and the changelog lists them.

> A step logs `Blocked:` and `Resolved:`, runs the postmortem skill, and ship passes.

**First-run path:** A build log with no stop and no rework needs no postmortem.

> Ship passes with no `Postmortem:` line.

**Error / sad path:** A stop with no postmortem, or a record with no preventive row.

> Ship exits non-zero and names the missing line or row.

**Cross-session continuity:** A human clears a stop outside the step session.

> The next session writes the `Resolved:` line before it continues.

## Acceptance Criteria

- [ ] Ship fails on a build log with a `Resolved:` line and no `Postmortem:` line.
- [ ] The postmortem check fails on a record that lacks a corrective, preventive, or detective row.
- [ ] A "none, because" row passes the check.
- [ ] A stub `gh` test shows the queue waiting for pending checks after its push, then merging.
- [ ] A stub `gh` test shows the queue stopping with the check name when a check fails after its push.
- [ ] A test shows P4 raising a PR whose title passes `merge-queue.mjs title`.
