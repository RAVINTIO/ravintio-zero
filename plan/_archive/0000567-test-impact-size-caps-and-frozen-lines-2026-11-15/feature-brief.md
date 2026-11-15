---
title: "Feature Brief - Test impact scan covers size caps and frozen lines"
summary: "The Size cap and Reference file edit causes name every cap, the lowest cap, the frozen-line check, and the boot template cap."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test impact scan covers size caps and frozen lines

**Feature ID:** 0000567-test-impact-size-caps-and-frozen-lines

Folded in from backlog entries 0000406 and 0000526.

## Business Goal

Two earlier steps hit a size or frozen-line failure that the scan did not predict. A unit grew the orchestrator skill to 8710 bytes and broke a stricter cap in a second suite. A first edit changed a base line and the boot templates, and two checks failed. The scan must list every cap and every frozen-line check at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Every cap, lowest first | As a plan author, I list every cap test with its value, so that I plan against the lowest cap. | must-have | 1 |
| Frozen lines and boot cap | As a plan author, I see the frozen-line check and the boot template cap named, so that I list them under `## Test impact`. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Plan skill reference text and its tests |

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
- Edits to the `Size cap` and `Reference file edit` causes in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
- One new test suite that checks both causes.

### Out of Scope
- Causes that steps 24 to 27 add.
- Hook and script changes.
- A change to any size cap.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same file | `cmp` |
| Scan size | 20 lines or fewer, as `test-0000383` NFR-001 sets | line count |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- The edit adds no line to the scan, because the scan holds 20 lines or fewer.

### Assumptions
- Entry 0000526 names a 3800 byte boot cap. The suite now holds 4000. The cause names the suite and not the number.

## Scenario Paths

**Happy path:** A plan author edits a size-capped skill and reads the scan. The author lists every cap test with its value, plans against the lowest, and lists the frozen-line check.

> The scan names each step.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** A cause loses its wording.

> A test fails, because it pins the wording.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] The `Size cap` cause says to list every test that measures the skill with each cap value, and to plan growth against the lowest cap.
- [ ] The `Reference file edit` cause names `test-0000151-req-011-orchestrator-references-split.sh`, the frozen base lines, and the boot template cap.
- [ ] A test checks the wording in both trees.
