---
title: "Feature Brief - Clean step stops and logs"
summary: "A routine question gets its own Question status, build log times come from the clock and every phase closes, and the test runner names failed suites."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Clean step stops and logs

**Feature ID:** 0000358-clean-step-stops-and-logs

## Business Goal

Agents write `Blocked:` for routine questions, which inflates the `Blocked:` counts that governance and resume detection read. Build logs also carry hand-typed future times and phase blocks with no end line, and a failed test run shows only totals. Pulled in from entries 0000273, 0000266, 0000335, and 0000269.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Question status | As a human on the loop, I see `Question:` on a routine question, so that `Blocked:` marks only an exception stop. | must-have | 1 |
| Build log times from the clock | As a maintainer, I find that every phase reads `date -u +%Y-%m-%dT%H:%M:%SZ` and `build-log-check.mjs` fails a time later than the commit that adds it, so that a guessed time never reaches ship. | must-have | 1 |
| Closed phase blocks | As a maintainer, I find `build-log-check.mjs` fails a closed phase block with no `Complete:` or `Skipped:` line, so that the watcher and resume read every phase end. | must-have | 1 |
| Failed suites by name | As a developer, I see each failed suite's file name under the totals, with or without `RAVINTIO_TEST_QUIET=1`, so that one run names every failure. | should-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero pack | component-pack | existing | Skills, hooks, scripts, templates, and tests |

### Data Ownership

None. No data store changes.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| Ship skill | `build-log-check.mjs` | command, exit code | Exit 0 is clean. Exit 1 lists findings. |
| Phase skills | system clock | `date -u +%Y-%m-%dT%H:%M:%SZ` | Every logged time comes from this command. |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Node (`.mjs`), PowerShell |
| Testing | Bash test suites in `ravintio-zero/tests/`, run by `run-tests.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Add `Question` to the status set in the orchestrator skill, `pipeline-reference.md`, the two boot templates, and the comment in `check-reply-prefix.mjs`.
- Reserve `Blocked:` for exception stops in the phase skills and orchestrator references. A question line, such as the product id check, uses `Question:`.
- Tell each phase skill to read the clock with `date -u +%Y-%m-%dT%H:%M:%SZ` and never type a time.
- `build-log-check.mjs` fails a time later than the commit that adds it, and a closed phase block with no `Complete:` or `Skipped:` line.
- `run-tests.sh` and `run-tests.ps1` print each failed suite's file name under the totals, even with `RAVINTIO_TEST_QUIET=1`.
- Point the validate skill at that list.

### Out of Scope
- Changes to resume detection and the governance counts. They keep reading `Blocked:` unchanged.
- Any fail-closed guard. The prefix hook only warns.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | Each new check gives the same result on every run | Fixture-based local tests |

## Constraints and Assumptions

### Constraints
- Chart decisions for step 7 apply. No schema or dependency change.
- Setup stop after this step, because it changes skills and the `CLAUDE.md` template.

### Assumptions
- A build log is committed with its times, so "the commit that adds it" is readable from git history. If git is unreadable, the time check skips.

## Scenario Paths

**Happy path:** A step logs times from the clock, closes each phase with `Complete:`, and asks a routine question with `Question:`. `build-log-check.mjs` passes.

> A phase block with a clock time and a `Complete:` line passes the check.

**First-run path:** A new install gets the `Question` status in `CLAUDE.md` from setup.

> The `CLAUDE.md` template carries the full status set.

**Error / sad path:** A log has a future time or an open phase block, or a suite fails.

> The check names the phase and exits 1. The runner lists the failed suite file names.

**Cross-session continuity:** Nothing is stateful.

> A resumed session reads the `Complete:` lines the check now guarantees.

## Acceptance Criteria

- [ ] The orchestrator status set names `Question`, and the skills reserve `Blocked:` for exception stops.
- [ ] `build-log-check.mjs` fails a fixture with a future time and one with an open phase block.
- [ ] With one failing suite, `run-tests.sh` names it after the totals, with and without `RAVINTIO_TEST_QUIET=1`.
