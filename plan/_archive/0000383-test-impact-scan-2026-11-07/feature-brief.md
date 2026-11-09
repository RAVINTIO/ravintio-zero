---
title: "Feature Brief - Test impact scan"
summary: "The plan phase lists the tests an edit will break, including reference files, test style rules, the runner allowlist, fixture pins, and a repo's own tests."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test impact scan

**Feature ID:** 0000383-test-impact-scan

## Business Goal

Four retrospectives found tests that the plan phase never listed. Each miss cost a rework cycle and a full suite run of about 5 minutes. The scan also ignores a developer's own tests. Source backlog entries: 0000361, 0000362, 0000363, 0000369, 0000297.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Reference files (0000361) | As a pack maintainer, I get the frozen-line tests listed when a run edits a skill's `references/` file, so that P2 finds them before the full suite. | must-have | 1 |
| Test style rules (0000362) | As a test author, I get the repo-wide style tests listed when a run adds a test file, so that I read them first. | must-have | 1 |
| Runner allowlist (0000363) | As a test author, I get `run-tests.sh` and `run-tests.ps1` listed when a run adds a non-suite file under `ravintio-zero/tests/`, so that the runner does not stop on an undiscovered file. | must-have | 1 |
| Fixture pins (0000369) | As a pack maintainer, I get fixture-pinned lines listed when a run edits an existing pack line, so that P2 runs the named suites before the full suite. | must-have | 1 |
| Repo tests (0000297) | As a developer using Zero, I get my own test folders scanned, so that a changed string lists the repo test that asserts it. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack skills, standards, templates, and tests |

### Data Ownership

None. The pack has no data store.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Node.js (existing) |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions (existing) |
| Build target | local |

## Scope Boundaries

### In Scope
- Four new causes in the `## Test impact scan` of `ravintio-plan`: reference file edit, new test file, non-suite file under the tests folder, and fixture-pinned line.
- The scan covers the repo's own test folders, taken from the stack declaration or from common names.
- `ravintio-implement` runs the suites the plan names before the full suite.
- `ravintio-test-writer`, `ravintio-refactor`, and `ravintio-validate-and-accept` name the repo's test folders where they name `ravintio-zero/tests/`.
- Tests check that the plan skill names each cause.

### Out of Scope
- New scripts. The scan stays a skill instruction.
- Changes to `run-tests.sh` itself.

### Deferred
Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text | At most 1720 lines in all `SKILL.md` files | `test-0000031-req-003-five-phases.sh` |
| Scan size | At most 15 non-blank lines | `test-0000246-req-001-test-impact-scan.sh` |

## Constraints and Assumptions

### Constraints
- The scan section stays within its line cap.

### Assumptions
- A developer repo declares its test folders in the stack, or uses `tests/`, `test/`, or `__tests__/`.

## Scenario Paths

**Happy path:** The plan phase runs the scan, finds a cause, greps the pack and repo test folders, and lists each match under `## Test impact`.

> A run edits a reference file. The scan names the file, finds the frozen-line test, and lists it in the unit that edits the file.

**First-run path:** A repo with no tests folder.

> Every grep matches nothing and the row says `none found`.

**Error / sad path:** A cause applies but no test matches.

> The row says `none found`. The scan never blocks the plan.

**Cross-session continuity:** The scan result lives in the execution plan.

> An interrupted run resumes from `plan/current/execution-plan.md`.

## Acceptance Criteria

- [ ] The plan skill names each new cause in its scan.
- [ ] The scan finds a developer's own tests.
- [ ] The scan section holds 15 non-blank lines or fewer.
