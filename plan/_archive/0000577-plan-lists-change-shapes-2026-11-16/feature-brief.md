---
title: "Feature Brief - Plan lists the change shapes a diff reader must handle"
summary: "The plan skill's test impact scan says to name a test world for add, rename, and delete when a unit reads a git diff."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Plan lists the change shapes a diff reader must handle

**Feature ID:** 0000577-plan-lists-change-shapes

Folded in from backlog entry 0000516.

## Business Goal

The id-collisions module first skipped a backlog entry that a PR had renamed. Git lists a rename apart from an addition. Every test world added its files as new, so no test caught the gap before the module ran on a real merge. The scan must prompt for each change shape at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Change shapes cause | As a plan author, I name a test world for add, rename, and delete when a unit reads a git diff, so that the suite fails before the unit runs on real data. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Plan skill text and its tests |

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
- A new `Diff reader` cause in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
  - It covers a unit that reads a git diff or a file list.
  - It says to name a test world for each of add, rename, and delete.
- The `New test file` and `Non-suite file` causes merge into one line, so the scan stays at 21 lines.
- One new test suite that checks the cause.

### Out of Scope
- A script that finds diff readers.
- A higher scan cap.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same file | `cmp` |
| Scan size | 21 lines or fewer | line count |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- Seven suites cap the scan at 21 lines, so the new cause needs a freed line.

### Assumptions
- The merged line keeps both cause names, so the suites that grep each name still pass.

## Scenario Paths

**Happy path:** A plan author writes a unit that reads a git diff. The scan tells the author to name a test world for add, rename, and delete. The author lists the three worlds in the execution plan.

> The scan names the step.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The cause loses its wording.

> A test fails, because it pins the wording.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] The `Diff reader` cause says a unit that reads a git diff or a file list needs a test world for add, rename, and delete.
- [ ] A test checks that the cause holds that wording, in both trees.
- [ ] The scan stays at 21 lines or fewer, and every cap suite still passes.
