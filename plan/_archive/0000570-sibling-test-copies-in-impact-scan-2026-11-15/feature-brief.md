---
title: "Feature Brief - List sibling copies of a pinned test in the impact scan"
summary: "The plan skill's test impact scan says to list the regression copy of each test it names."
status: "approved"
version: "0.1.0"
---
# Feature Brief - List sibling copies of a pinned test in the impact scan

**Feature ID:** 0000570-sibling-test-copies-in-impact-scan

Folded in from backlog entry 0000407.

## Business Goal

The plan for 0000389 named `test-0000034-req-003-atomic-settings-writes.sh` but missed its copy under `ravintio-zero/tests/regression/`. The full suite found the gap in P2. The scan must list each sibling copy at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Sibling-copy line | As a plan author, I list the regression copy of each test I name, so that no pinned copy fails the full suite late. | must-have | 1 |

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
- One sentence in the `## Test impact scan` section of `skills/ravintio-plan/SKILL.md`, in both pack trees. It says to grep `tests/regression/` for a file with the same name as each test the scan lists.
- One new test suite that checks the sentence.

### Out of Scope
- A script that finds sibling copies.
- A new cause line in the reference file.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same file | `cmp` |
| Scan size | 21 lines or fewer | line count |
| Skill size | Within every cap that measures the plan skill | cap suites |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- The scan holds 21 lines and four suites cap it at 21, so the sentence joins an existing line.

### Assumptions
- The scan paragraph in `SKILL.md` can take one sentence without breaking a skill size cap. P1 measures the margin.

## Scenario Paths

**Happy path:** A plan author edits a test under `ravintio-zero/tests/`. The scan tells the author to grep `tests/regression/` for the same name. The author lists the copy in the execution plan.

> The scan names the step.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The sentence loses its wording.

> A test fails, because it pins the wording.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] The `## Test impact scan` section of the plan skill says to grep `tests/regression/` for each listed test's file name. It also says to list the match.
- [ ] A test checks that the section holds the sentence, in both trees.
- [ ] The scan stays at 21 lines or fewer, and every cap suite still passes.
