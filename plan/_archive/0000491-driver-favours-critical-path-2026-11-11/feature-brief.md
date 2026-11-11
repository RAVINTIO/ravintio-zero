---
title: "Feature Brief - Driver favours the critical path"
summary: "When several steps can start, the driver starts first the step with the longest chain of steps waiting behind it."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver favours the critical path

**Feature ID:** 0000491-driver-favours-critical-path

Source: backlog entry 0000492-driver-favours-critical-path, filed on 2026-11-10 after the step 22 retrospective.

## Business Goal

On 2026-11-10 the driver filled free slots with any step that could start. The driver lane, steps 24 to 29 then 41, waited while steps in shorter lanes ran. The initiative took hours longer than the chain required. The driver now ranks the steps that can start by the length of the chain behind each one, and starts the longest chain first.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Chain ranking | As the coordinator, I want the driver to start the step with the longest chain behind it first, so that the initiative ends as soon as its longest chain allows. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The chart parser, the driver, and the roadmap standards |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `initiative.md` chart | ravintio-zero | none. The change reads the chart and writes nothing. |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM), Markdown, Bash |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions |

## Scope Boundaries

### In Scope
- A chain length for each pending step, computed from the `After` lists and the lane order.
- `readySteps` in `initiative-chart.mjs` returns the startable steps longest chain first, with chart order breaking ties.
- Text in `roadmap-standards.md` that states the order.
- Tests, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- Concurrency limits, lane assignment, and the merge queue order.
- Any change to the chart format.
- A weight for the time each step takes.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Cost | The ranking runs in well under 100 ms for a 60-step chart | A test times `readySteps` on a generated 60-step chart |

## Constraints and Assumptions

### Constraints
- No new library or service. The module keeps its no-package rule.
- The change widens no guard.

### Assumptions
- Every step takes about the same time. Impact if wrong: a long step in a short chain can still run late.

## Scenario Paths

**Happy path:** Three steps can start and two slots are free. The driver starts the two with the longest chains behind them.

**First-run path:** A chart with no `Lane` or `After` data gives every step a chain of 1. The driver keeps chart order, as it did before.

**Error / sad path:** A cycle in the `After` lists cannot give a chain length. The ranking stops at a step it has already visited and the driver still starts steps.

**Cross-session continuity:** The ranking is a pure function of the chart and the merged set. A restarted driver computes the same order.

## Acceptance Criteria

- [ ] When more steps can start than slots are free, the driver starts first the step with the longest chain of unmerged steps behind it.
- [ ] Steps with equal chains start in chart order.
- [ ] A step in a lane counts the later steps of its lane as part of its chain.
- [ ] A chart with no `After` or `Lane` data starts steps in chart order, as before.
- [ ] `roadmap-standards.md` states the order.
