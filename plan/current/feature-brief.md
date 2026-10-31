---
title: "Feature Brief - isolated test state"
summary: "The test runner clears RAVINTIO_ variables and checks the tree, and the req-007 test reads the file that holds the rules."
status: "approved"
version: "0.1.0"
---
# Feature Brief - isolated test state

**Feature ID:** 0000315-isolated-test-state

> Built from backlog entries 0000309 and 0000267 by initiative 0000312 step 3.

## Business Goal

Test results depend on the session. A step session sets `RAVINTIO_INITIATIVE_STEP=1`, a nested runner inherits `RAVINTIO_TEST_QUIET=1`, and a test once moved `plan/backlog/.next-id`. Separately, `test-0000164-req-007` fails on any machine with a generated `CLAUDE.md`, because the rules it checks moved to `hook-enforcement.md`. The suite should give the same result in any session and leave the repo as it found it.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Runner clears the environment | As a developer in any session, I run the suite with `RAVINTIO_*` variables set, so that the result matches a clean shell. | must-have | 1 |
| Runner checks the tree | As a developer, I want the runner to fail when a run changes tracked or untracked files, so that a test never leaves repo state behind. | must-have | 1 |
| req-007 checks the rule file | As a developer with a generated `CLAUDE.md`, I run the suite and `test-0000164-req-007` passes, and it fails when the rules leave `hook-enforcement.md`. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All three | The suite passes with `RAVINTIO_INITIATIVE_STEP=1` set and leaves `git status` unchanged. |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The test runners and the tests |

### Data Ownership

No data store.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, Markdown |
| Runtime | Bash |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash test scripts with `helpers/assert.sh` |
| IaC | none |
| Cloud | none |
| Compute | local |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `run-tests.sh` and `run-tests.ps1` clear every `RAVINTIO_*` variable before each suite, except the runner's own settings. A suite that needs a variable sets it.
- A test that writes repo state (`.next-id`, `plan/`, `.claude/`) works on a temporary copy.
- A final runner check fails when tracked and untracked files differ before and after the run. Ignored files are out of the check.
- `test-0000164-req-007` checks the file that holds the rules and fails when the phrases leave it.
- Tests for each change.

### Out of Scope
- Other flaky tests.
- Changes to hooks or skills.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | Same result with and without `RAVINTIO_INITIATIVE_STEP=1` | Bash test |
| Cleanliness | `git status` equal before and after a full run | Runner check |

## Constraints and Assumptions

### Constraints
- Code and docs land together.
- The change widens no guard.

### Assumptions
- Few suites need a `RAVINTIO_*` variable. P1 finds them by running the suite after the clear.

## Scenario Paths

**Happy path:** With `RAVINTIO_INITIATIVE_STEP=1` set, the runner clears it, the suite passes, and `git status` matches the status before the run.

> See above.

**First-run path:** With no `RAVINTIO_*` variable set, the runner changes nothing and the suite passes as before.

> See above.

**Error / sad path:** A suite that changes repo state fails the final check, and the runner names the path. `test-0000164-req-007` fails when the phrases leave `hook-enforcement.md`.

> See above.

**Cross-session continuity:** Later steps use the same runner, so each starts from a clean environment and leaves a clean tree.

> See above.

## Acceptance Criteria

- [ ] The suite passes with `RAVINTIO_INITIATIVE_STEP=1` set, as it does without it.
- [ ] `git status` (tracked and untracked files) matches before and after a full run.
- [ ] `test-0000164-req-007` passes with a freshly generated `CLAUDE.md` and fails when the phrases leave `hook-enforcement.md`.
