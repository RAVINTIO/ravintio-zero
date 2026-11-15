---
title: "Feature Brief - Scan for wording pins before a prose rewrite"
summary: "The test impact scan gets a Prose rewrite cause that greps the tests for each changed sentence."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Scan for wording pins before a prose rewrite

**Feature ID:** 0000568-wording-pin-scan

Folded in from backlog entry 0000418.

## Business Goal

Step 19 of an earlier initiative rewrote prose in about 370 files. Seven tests and two fixtures grepped the old wording, and the full suite found them only at P3. The scan must list those pins at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Prose rewrite cause | As a plan author, I grep the tests for each changed sentence, so that I list every wording pin under `## Test impact`. | must-have | 1 |

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
- One new `Prose rewrite` cause in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
- One new test suite that checks the cause.

### Out of Scope
- The optional script that prints matches for a slice list.
- Causes that steps 25 and 26 add.
- A change to the scan line cap.

### Deferred
- The slice-list script. The entry calls it optional.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same file | `cmp` |
| Scan size | 20 lines or fewer, as `test-0000383` NFR-001 sets | line count |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- The scan holds 19 lines, so the cause adds exactly one line.

### Assumptions
- The entry names `SKILL.md`. The causes live in the reference file that `SKILL.md` points to, so the cause goes there.

## Scenario Paths

**Happy path:** A plan author plans a prose rewrite and reads the scan. The author greps `ravintio-zero/tests/` for each changed sentence and lists the matches in the execution plan.

> The scan names each step.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The cause loses its wording.

> A test fails, because it pins the wording.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] The reference file has a `Prose rewrite` cause that says to grep `ravintio-zero/tests/` for each changed sentence and list the matches in the execution plan.
- [ ] A test checks that the plan skill's scan names the cause, in both trees.
- [ ] The scan stays at 20 lines or fewer.
