---
title: "Feature Brief - Test impact scan misses suites that scan live files"
summary: "The plan skill's Test impact scan gains a cause for moves of archived content into a live folder."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test impact scan misses suites that scan live files

**Feature ID:** 0000566-test-impact-for-history-moves

Folded in from backlog entry 0000405.

## Business Goal

Step 8 of feature 0000384 moved 270 ADRs from `plan/_archive/` to `docs/adr/`. Eleven suites scan live files and exclude `plan/_archive/` as history, so each flagged the moved text. The scan named none of them, and a fix pass followed. The scan must name these suites at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| History move cause | As a plan author, I see a `History move` cause, so that I list every suite with a `plan/_archive/` exclusion under `## Test impact`. | must-have | 1 |

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
- A `History move` cause in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
- One new test suite that checks the cause.

### Out of Scope
- Causes that steps 23 to 27 add.
- Hook and script changes.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same file | `cmp` |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.

### Assumptions
- The reference file already has a Pack Index row in the plan skill.

## Scenario Paths

**Happy path:** A plan author moves archived content into a live folder and reads the scan. The author greps the tests for `plan/_archive/` exclusion lists and lists each match.

> The scan names the cause and its grep.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The cause is missing from the reference file.

> A test fails, because it checks the cause.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] `references/test-impact-causes.md` holds a `History move` cause that fires when a run moves or copies archived content into a live folder.
- [ ] The cause names the grep of `ravintio-zero/tests/` for `plan/_archive/` exclusion lists and says to list each match.
- [ ] A test checks the cause in both trees.
