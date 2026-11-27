---
title: "Feature Brief - Log a non-TDD unit with a class"
summary: "A unit with no executable check logs a class on its Done line and its markers, and the metrics report counts it."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Log a non-TDD unit with a class

**Feature ID:** 0000580-log-non-tdd-units

## Business Goal

A living-docs unit has no test. It cannot log tier `inline`, so the build log has no valid form for it. Step 10 logged `U-004` in the older form, and the metrics report counts it as `unclassified`. The step gives such a unit one valid form and its own row in the report. It relaxes no check.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Docs class in the dispatch standards | As a pipeline agent, I log a unit with no executable check as class `docs`, so that its `Done:` line is valid. | must-have | 1 |
| Class on markers | As a pipeline agent, I append `RED:` and `GREEN:` lines that carry the class, so that the log shows why the unit has no failing test. | must-have | 1 |
| Check 7 accepts docs | As a reviewer, I run `build-log-check.mjs` on a log with a `docs` unit, so that it passes with both markers and fails without them. | must-have | 1 |
| Metrics row for docs | As a reviewer, I read the metrics report, so that I see `docs` units in their own row. | must-have | 1 |

## Waves

One wave. All four features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Standards, scripts, templates, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/current/build-log.md` format | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `build-log-mark.mjs` | `build-log-check.mjs`, `workflow-metrics.mjs` | build log text | `Done:`, `RED:`, and `GREEN:` lines |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js scripts, bash tests |
| Testing | `ravintio-zero/tests/` shell tests |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A fifth unit class, `docs`, in `agent-dispatch-standards.md`.
- A `--class` option on `build-log-mark.mjs` for `RED:` and `GREEN:` lines.
- A check 7 change in `build-log-check.mjs`: a `docs` `Done:` line needs both markers.
- A `docs` row in the `workflow-metrics.mjs` dispatch table.
- The pins in tests that name four classes.

### Out of Scope
- Any relaxation of a check in `build-log-check.mjs`.
- A new tier value.
- A rewrite of archived build logs.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Compatibility | An older `Done:` line still passes | Existing tests for 0000358 and 0000386 pass |

## Constraints and Assumptions

### Constraints
- Every unit still logs `RED:` and `GREEN:` (chart decision).
- Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`.

### Assumptions
- The tier table row for `docs` matches the row for `content`.

## Scenario Paths

**Happy path:** The agent finishes a docs unit. It runs `build-log-mark.mjs` for `RED`, `GREEN`, and `Done` with class `docs`. The check passes and the report shows a `docs` row.

> The agent logs both markers with the class, then a `Done:` line with class `docs`. `build-log-check.mjs` exits 0. The report lists the unit under `docs`.

**First-run path:** A log with no `docs` unit.

> The report shows no `docs` row and the check behaves as before.

**Error / sad path:** A `docs` `Done:` line with no marker.

> `build-log-check.mjs` reports the missing `RED:` or `GREEN:` line and exits 1.

**Cross-session continuity:** The session ends after `RED:`.

> Resume detection finds the `In progress:` line and reruns the unit. No state is new.

## Acceptance Criteria

- [ ] The dispatch standards name class `docs` with its tier row and its marker rule.
- [ ] `build-log-mark.mjs` writes `RED:` and `GREEN:` lines that carry a class when given `--class`.
- [ ] `build-log-check.mjs` passes a `docs` unit with both markers and fails one without them.
- [ ] `workflow-metrics.mjs` counts `docs` units in a row named `docs`.
