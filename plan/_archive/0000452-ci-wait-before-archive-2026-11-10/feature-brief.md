---
title: "Feature Brief - Ship waits for CI before it archives"
summary: "An initiative step archives its run only after its PR checks pass, so a CI failure stays fixable."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Ship waits for CI before it archives

**Feature ID:** 0000452-ci-wait-before-archive

## Business Goal

An initiative step must be able to fix its own failing CI. Today ship archives `plan/current/` before it raises the PR. After that `gate-write` rejects code edits, so the chart field `**Step CI fixes:** allowed` can never apply. Step 6 of initiative 0000360 blocked three times on PR #136 and held five ready PRs for about seven hours. Source: backlog entry 0000412.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Archive after green CI | As a step session, I archive my run after my PR checks pass, so that I can still push a CI fix | must-have | 1 |
| Ready only on green | As the merge queue, I receive `ready` only for a PR head whose checks all passed, so that I never merge an unchecked PR | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The `ravintio-ship` skill and the roadmap standards that describe the I-D Advance order |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Ship skill text, roadmap standards text | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Bash tests |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, unchanged |
| Build target | local |

## Scope Boundaries

### In Scope
- Reorder the initiative-step ship sequence: PR and CI first, then archive and sentinel clear as the last push, then `ready`.
- Require every check on the PR head to pass before the step writes `ready`.
- Tests that show both outcomes.

### Out of Scope
- A reopen route that restores an archived run. The chart rules it out.
- Any change to `gate-write`.
- The driver and the merge queue.
- A normal run outside an initiative. The human reviews that PR, so it keeps its order.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Guard strength | No guard passes a form it blocks today | `gate-write` and `merge-guard` files are unchanged in the diff |

## Constraints and Assumptions

### Constraints
- The squash must carry no sentinel files and no `plan/current/` files.
- The merge queue rejects a PR title that does not follow the title rule.

### Assumptions
- The squash carries the net diff of the branch, so a sentinel committed early and deleted in the last commit is absent from the merge.

## Scenario Paths

**Happy path:** The step raises the PR and waits for CI. Then it archives the run and clears the sentinels in one commit. It pushes, waits for the checks on the new head, and writes `ready`.

> The step reaches `ready` with `plan/current/` archived and every check green.

**First-run path:** Not applicable. The change alters an existing sequence.

> Not applicable.

**Error / sad path:** A check fails before the archive. The step still holds `plan/current/design.md`, so it pushes an in-scope fix when the chart allows it and watches again. When the chart says `stop`, it prints `Blocked:`. A check fails on the archive head. The step cannot edit code, so it prints `Blocked:`.

> The step never writes `ready` while a check is pending or failed.

**Cross-session continuity:** A session that ends after the PR and before the archive resumes with `plan/current/` intact. A session that ends after the archive push resumes at the CI wait on the new head.

> The step loses no state. The build log records the phase.

## Acceptance Criteria

- [ ] A test shows a step with a failing check pushing a fix before the archive, with no human route.
- [ ] A test shows a step refusing to write `ready` while a check is pending or failed.
- [ ] The archive commit is the last push before `ready` in an initiative step.
- [ ] A normal run keeps its ship order.
