---
title: "Feature Brief - Test impact scan covers skill-wide grep pins"
summary: "The plan skill's test impact scan says to grep for suites that loop over every skill when a run adds a term to a SKILL.md."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test impact scan covers skill-wide grep pins

**Feature ID:** 0000571-scan-cause-skill-wide-grep-pins

Folded in from backlog entry 0000404.

## Business Goal

Feature 0000383 added the file name `run-tests.sh` to the plan skill. `test-0000151-req-008-quiet-test-output.sh` greps every `SKILL.md` for `bash ravintio-zero/tests/run-tests` and requires a quiet-mode command on that line. The full suite found the gap in P2 and cost one rework cycle. The scan must name this pin at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Skill-wide grep pin | As a plan author, I list the suites that grep every skill when I add a term to a `SKILL.md`, so that no skill-wide pin fails the full suite late. | must-have | 1 |

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
- One sentence in the `Skill-text budget` cause of `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
  - The sentence covers a run that adds a file name, command, or flag to a `SKILL.md`.
  - It says to grep `ravintio-zero/tests/` for suites that loop over every skill, and to list each match.
- One new test suite that checks the sentence.

### Out of Scope
- A script that finds skill-wide pins.
- A new cause line, because five suites cap the scan at 21 lines.

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
- The scan holds 21 lines and five suites cap it at 21, so the sentence joins an existing line.

### Assumptions
- The sentence passes the wording allowlist and every frozen-line suite for the reference file.

## Scenario Paths

**Happy path:** A plan author adds a command to a `SKILL.md`. The scan tells the author to grep the tests for suites that loop over every skill. The author lists each match in the execution plan.

> The scan names the step.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The sentence loses its wording.

> A test fails, because it pins the wording.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] The `Skill-text budget` cause says to grep the tests for suites that loop over every `SKILL.md` and match the added term. It names `test-0000151-req-008-quiet-test-output.sh` as the example.
- [ ] A test checks that the cause holds the sentence, in both trees.
- [ ] The scan stays at 21 lines or fewer, and every cap suite still passes.
