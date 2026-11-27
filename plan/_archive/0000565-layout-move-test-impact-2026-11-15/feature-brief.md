---
title: "Feature Brief - Test impact scan for layout moves"
summary: "The plan skill's Test impact scan gains a Path move cause that lists the greps for suites that depend on folder depth or path-keyed state."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test impact scan for layout moves

**Feature ID:** 0000565-layout-move-test-impact

Folded in from backlog entry 0000419.

## Business Goal

Feature 0000397 moved the pack source to `src/ravintio-zero/`. The first suite run from the new folder failed 43 suites, because tests found the repo root one folder above the pack. The prose baseline also keyed its counts by path, so 19 counts rose. The scan must name these greps at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Path move cause | As a plan author, I see a `Path move` cause, so that I grep the tests for depth-based root lookups and list path-keyed state files. | must-have | 1 |

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
- A `Path move` cause in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
- One new test suite that checks the cause.

### Out of Scope
- Causes that steps 22 to 27 add.
- A pack check that runs the suite from the new folder before P2.
- Changes to hooks or scripts.

### Deferred
- The pack check that runs the suite once from the new folder. The entry calls it optional.

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

**Happy path:** A plan author moves a folder and reads the scan. The author then greps the tests for the two depth lookups and lists the path-keyed state files.

> The scan names the cause and its greps.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The cause is missing from the reference file.

> A test fails, because it checks the cause.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] `references/test-impact-causes.md` holds a `Path move` cause that fires when a run renames or moves a folder.
- [ ] The cause names `$ZERO_DIR/..`, `SCRIPT_DIR/../..`, and path-keyed state files such as `plan/state/prose-baseline.json`.
- [ ] A test checks the cause in both trees.
