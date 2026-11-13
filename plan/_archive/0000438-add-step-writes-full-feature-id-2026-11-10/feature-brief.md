---
title: "Feature Brief - Add-step writes the full feature id"
summary: "The add-step helper writes {id}-{slug} in the Feature id cell so the driver accepts the chart."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Add-step writes the full feature id

**Feature ID:** 0000438-add-step-writes-full-feature-id

## Business Goal

`initiative-add-step.mjs` writes a bare seven-digit id in the `Feature id` cell. The driver requires `{7 digits}-{slug}` and stopped with "step 22 has an invalid feature id" on 2026-11-10 until a person fixed the row. The helper must write a row the driver accepts, and a test must keep the two patterns in step.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Full feature id | As a coordinator, I add a step with the helper, so that the driver starts it with no manual fix | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Initiative scripts and their tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/current-initiative/initiative.md` chart | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `initiative-add-step.mjs` | `initiative-run.mjs` | chart file | `Feature id` cell matches the driver pattern |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js, plain ESM, no packages |
| Testing | Bash test scripts with `helpers/assert.sh` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Write `{featureId}-{slug}` in the `Feature id` cell of the Steps row.
- Share one feature id pattern between the helper and the driver.
- A test that runs a chart the helper wrote through the driver pattern.

### Out of Scope
- Other chart fields or tables.
- Backlog entry format.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Correctness | A chart the helper writes passes the driver feature id check | New test |

## Constraints and Assumptions

### Constraints
- Edit the source in `src/ravintio-zero/`, then sync the installed copy.
- No packages.

### Assumptions
- The slug the helper receives is the slug of the feature id, as the driver pattern requires kebab-case.

## Scenario Paths

**Happy path:** The helper reserves two ids, writes the row with `0000500-sample-step`, and the driver pattern accepts it.

> Draft accepted (initiative).

**First-run path:** A chart with no earlier helper rows. The first added step gets the full id too.

> Draft accepted (initiative).

**Error / sad path:** A slug that fails the kebab-case check exits 1 before the helper reserves any id. This behaviour stays.

> Draft accepted (initiative).

**Cross-session continuity:** A failed run reserves nothing and leaves the chart unchanged. This behaviour stays.

> Draft accepted (initiative).

## Acceptance Criteria

- [ ] The `Feature id` cell of a new Steps row reads `{7 digits}-{slug}`.
- [ ] A test feeds the helper's Steps row through the driver pattern and it matches.
- [ ] The helper and the driver share one pattern definition, or a test fails when they differ.
- [ ] The existing add-step test still passes.
