---
title: "Feature Brief - Delivery PR lists steps in version order"
summary: "I-E Delivery names the step table order, and reshape-initiative.mjs prints the table."
status: "approved"
version: "0.143.0"
---
# Feature Brief - Delivery PR lists steps in version order

**Feature ID:** 0000574-delivery-pr-lists-steps-in-version-order

## Business Goal

The first body of initiative PR #202 listed 61 steps in chart order. Concurrent steps merge in ready order, so the `Version` column ran out of order. The human reviews the branch history in version order, so the table must match it. Source: backlog entry 0000543.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Table order rule | As a coordinator, I read in I-E Delivery rule 6 that the step table lists steps in ascending `Version` order, so that the PR body matches the history. | must-have | 1 |
| Printed table | As a coordinator, I get the step table from `reshape-initiative.mjs` in replay order, so that I paste it without sorting by hand. | must-have | 1 |
| Order test | As a maintainer, I run a test with a chart whose versions are out of chart order, so that a regression in the printed order fails the suite. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the script, the standard, and the tests |

### Data Ownership

None.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node (script), bash (tests), markdown |
| Testing | bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Rule 6 of I-E Delivery states ascending `Version` order.
- `reshape-initiative.mjs` prints the step table with step, title, version, and tag.
- One test for the printed order. Edits land in `src/ravintio-zero/` and mirror to `ravintio-zero/`.

### Out of Scope
- Changing the replay order. The script already sorts by version (0000378).
- Writing the PR body or calling `gh`.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Correctness | The printed rows run in strictly ascending version for any chart | The new test |

## Constraints and Assumptions

### Constraints
- Both pack trees stay identical.

### Assumptions
- The coordinator copies the printed table into the PR body.

## Scenario Paths

**Happy path:** The coordinator runs the script. It prints the table in version order and the coordinator pastes it into the PR body.

> Run with a chart whose versions are out of chart order. The table rows ascend by version.

**First-run path:** Not applicable. The script keeps no state.

> Not applicable.

**Error / sad path:** A chart with no usable `Version` makes the script fail before it prints a table. That behaviour stays.

> The script exits 1 and prints no table.

**Cross-session continuity:** Not applicable. The script writes no state besides the new branch.

> Not applicable.

## Acceptance Criteria

- [ ] I-E Delivery rule 6 says the table lists steps in ascending `Version` order, which is merge order.
- [ ] `reshape-initiative.mjs` prints a table of step, title, version, and tag in replay order.
- [ ] A test with a chart whose versions are out of chart order checks that the printed rows ascend by version.
