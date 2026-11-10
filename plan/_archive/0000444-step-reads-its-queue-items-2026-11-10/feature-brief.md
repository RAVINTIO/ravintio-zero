---
title: "Feature Brief - Steps read their queue items"
summary: "The driver lists queue items that name a step, and ship fails when one has no commit or report."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Steps read their queue items

**Feature ID:** 0000444-step-reads-its-queue-items

## Business Goal

Steps missed queue items that named them in three steps of initiative 0000360. Each miss cost a rework round. The driver now names the items in the start prompt. Ship refuses to raise a PR while a named item has no commit or report.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Queue helper | As a step session, I list the items that name my step, so that I never miss one. | must-have | 1 |
| Start prompt | As the driver, I name each queue item in the step start prompt, so that the session sees them first. | must-have | 1 |
| Ship check | As a step session, I fail ship when a named item has no commit or report, so that a miss never reaches the PR. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Driver, helper script, orchestrator and ship skill text, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.initiative-queue/` | the initiative coordinator | step sessions, read only |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| driver | step session | start prompt | one extra sentence that lists item names |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js ES modules, Bash suites, Markdown skills |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A helper script that lists the queue items that name a step and checks each for a commit or report.
- The driver start prompt and continue prompt name those items.
- Orchestrator and ship skill text call the helper.
- Tests, an ADR, docs, and a changelog entry.

### Out of Scope
- Changing how the coordinator writes items.
- Moving, renaming, or deleting queue items. A step never does that.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Security | The helper reads item text as data and never runs it | A suite feeds hostile item text and checks that nothing runs |

## Constraints and Assumptions

### Constraints
- No new library or service. The change widens no guard.

### Assumptions
- Every item holds `**Step:** {n}` and `**Destination:** {path}` in `item.md`.

## Scenario Paths

**Happy path:** The driver lists the items. The step commits each destination. Ship passes the check.

**First-run path:** An empty or missing queue lists nothing and the check passes.

**Error / sad path:** An item with no commit or report fails the check and names the item.

**Cross-session continuity:** A resumed session reads the same list from the queue folder.

## Acceptance Criteria

- [ ] The start prompt for a step with a named item lists its folder name.
- [ ] `initiative-queue.mjs check` exits 1 and names an item that has no commit and no report.
- [ ] A step with no named item sees an unchanged prompt and a passing check.
