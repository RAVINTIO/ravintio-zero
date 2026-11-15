---
title: "Feature Brief - Baseline record checks its input and its file"
summary: "baseline-failures.mjs record refuses unfinished runner output, and check refuses a missing baseline file."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Baseline record checks its input and its file

**Feature ID:** 0000549-baseline-record-checks

## Business Goal

A baseline that records no failures when the input ends early makes P3 flag inherited failures as new. A missing baseline file does the same. The script must refuse both cases, so P3 never compares against a false empty baseline.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Record checks its input | As a step agent, I run `record` on runner output, so that unfinished output exits 2 and writes no file. | must-have | 1 |
| Check checks its file | As a step agent, I run `check`, so that a missing baseline file exits 1 with a clear message. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `baseline-failures.mjs` and its tests. |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/current/baseline-failures.md` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM) and bash tests |
| Testing | bash suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- `record` exits 2 with one stderr line when the input has no `Feature suites:` totals line.
- `check` exits 1 with `no baseline recorded` when the baseline file is missing.
- Tests for a partial output file and a missing baseline file.
- Update the pin in `test-0000385-req-002-baseline-failures.sh` that says a missing file is an empty baseline.

### Out of Scope
- Making `clean-clone-test.mjs` or P0 run `record` itself.
- Changing how `check` reads its runner output.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Exit codes | `record` 2 on bad input, `check` 1 on a missing file | Test suite |

## Constraints and Assumptions

### Constraints
- Pack edits go in `src/ravintio-zero/` and mirror to `ravintio-zero/`.

### Assumptions
- Every finished `run-tests.sh` run prints a `Feature suites:` line, as the existing test fixtures do.

## Scenario Paths

**Happy path:** A finished run prints `Feature suites:`. `record` writes the file. `check` reads it and lists inherited and new suites.

**First-run path:** No baseline file exists. `check` exits 1 with `no baseline recorded`.

**Error / sad path:** The runner output stops before the totals line. `record` exits 2 and writes no file.

**Cross-session continuity:** The baseline file is a committed artifact in `plan/current/`. A resumed session reads it, or `check` reports it missing.

## Acceptance Criteria

- [ ] `record` exits 2 with one line on stderr when the input has no `Feature suites:` line, and writes no file.
- [ ] `check` exits 1 and prints `no baseline recorded` on stderr when the baseline file is missing.
- [ ] A green run with `Feature suites:` and no failures still records `None.` and exits 0.
