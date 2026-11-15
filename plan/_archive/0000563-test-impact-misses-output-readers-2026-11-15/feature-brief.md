---
title: "Feature Brief - Plan test impact misses suites that read driver output order"
summary: "The plan skill's Test impact scan gains an Output order cause for suites that read changed lines or the last line."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Plan test impact misses suites that read driver output order

**Feature ID:** 0000563-test-impact-misses-output-readers

Folded in from backlog entry 0000533.

## Business Goal

Step 57 of an earlier initiative added a summary block to the driver output. The plan said "none found" for the changed lines. Five suites read the last line of the driver output, and the full suite failed them after a 25-minute run. The scan must name these suites at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Output order cause | As a plan author, I see an `Output order` cause, so that I list suites that read changed lines or the last line. | must-have | 1 |

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
- An `Output order` cause in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
- One new test suite that checks the cause.

### Out of Scope
- Causes that steps 20 to 27 add.
- Changes to hooks or scripts.

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
- The plan skill needs no edit, because the reference file already has a Pack Index row.

## Scenario Paths

**Happy path:** A plan author changes printed driver lines and reads the scan. The author then lists each suite that matches the line text or reads the last line.

> The scan names the cause and the grep to run.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The cause is missing from the reference file.

> A test fails, because it checks the cause.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] `references/test-impact-causes.md` holds an `Output order` cause that tells the plan author to list suites that match a changed line or read the last line.
- [ ] The cause names the search of the tests folder.
- [ ] A test checks the cause in both trees.
