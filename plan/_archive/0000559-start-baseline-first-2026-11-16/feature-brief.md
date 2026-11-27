---
title: "Feature Brief - Start the baseline run before the P0 artifacts"
summary: "The P0 start actions begin the baseline suite run before they write any P0 artifact, so P3 no longer waits on it."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Start the baseline run before the P0 artifacts

**Feature ID:** 0000559-start-baseline-first

Folded in from backlog entry 0000478.

## Business Goal

The baseline suite run takes about 13 minutes in a clean clone. It starts as the fifteenth start action, after the design exists. Step 34 of an earlier initiative waited on it before P3 could compare results. The run must start first so it overlaps the rest of P0.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Baseline first | As a step session, I start the baseline run before I write any P0 artifact, so that P3 finds the result ready. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Orchestrator start actions and their tests |

### Data Ownership

None. The component owns no data.

## Stack

| Concern | Decision |
|---------|----------|
| Language | bash, markdown |
| Testing | bash suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Move the baseline action in `orchestrator-p0-start-actions.md` ahead of every action that writes a P0 artifact.
- Read the chart's Decisions rows before the baseline starts, because a row may change how it runs.
- Renumber the actions and fix every cross-reference to a number.
- One new suite that reads the action order.

### Out of Scope
- A change to `clean-clone-test.mjs` or `baseline-failures.mjs`.
- A change to when P3 compares results.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`.
- Tests pin rules by anchor. The renumbering must keep every anchor.

### Assumptions
- The clean-clone run reads committed files only, so earlier artifact writes do not change its result.

## Scenario Paths

**Happy path:** A step session reads the decision rows, starts the baseline in the background, then writes its P0 artifacts while the suite runs.

> As described.

**First-run path:** A fresh run outside an initiative runs the context reset and the pre-flight first, so the branch is final before the baseline starts.

> As described.

**Error / sad path:** If the suite cannot run, the baseline step writes `baseline-failures.md` with `None.` and notes the reason, as today.

> As described.

**Cross-session continuity:** The build log records the start time and the output path of the baseline run. A resumed session reads it.

> As described.

## Acceptance Criteria

- [ ] The baseline action comes before the sentinel, the build log, and `discovery.md` in the start actions.
- [ ] The decision rows action comes before the baseline action.
- [ ] A suite checks the order and the cross-references.
