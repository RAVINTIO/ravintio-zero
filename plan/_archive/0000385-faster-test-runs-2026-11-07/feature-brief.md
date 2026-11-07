---
title: "Feature Brief - Faster test runs"
summary: "P2 runs the tests a unit can affect, P0 records inherited failures, and P3 runs the suite in a clean clone."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Faster test runs

**Feature ID:** 0000385-faster-test-runs

## Business Goal

Six retrospectives record that suite runs took most of P2's wall clock. Runs also cannot tell an inherited failure from one they caused, and P3 can pass or fail on local state that CI never sees. This step cuts P2 suite time, separates old failures from new ones, and makes P3 match CI. Source backlog entries: 0000294, 0000295, 0000296.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Affected tests per cycle (0000294) | As a developer, I want each TDD cycle to run only the tests the unit can affect, so that P2 spends less time on suite runs. | must-have | 1 |
| Baseline failures (0000295) | As a developer, I want P0 to record the failures on the base commit, so that P3 stops only on failures my run caused. | must-have | 1 |
| Clean clone at P3 (0000296) | As a developer, I want P3 to run the suite in a clean clone of `HEAD`, so that its result matches CI. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack skills, standards, scripts, and tests |

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
- A rule in `ravintio-implement` and `ravintio-refactor`: each cycle runs the new test and the tests that cover the changed files. One full suite run happens before P2 completes, in the background while docs are written.
- A build-log `Tests run:` line for each cycle.
- A script that records and compares baseline failures, with P0 and P3 steps that use it, and a build report section for inherited failures.
- A script that clones `HEAD` into a temporary folder, runs the suite there, names any local and CI operating system gap, and removes the clone.
- P3 reruns only the suites that failed, then the full suite once before acceptance.
- Docs: `testing-standards.md`, the build-log template, `component.yml`, and the tests README.

### Out of Scope
- Any change to `run-tests.sh` suite selection. The pack suite stays a single runner.
- PowerShell ports of the new scripts.
- Anchors in the orchestrator `SKILL.md`, which has little byte headroom.

### Deferred
- Automatic mapping from a changed file to its covering tests for stacks other than this pack. The skill states the rule and the agent picks the tests.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Clean clone cost | The clone adds under 30 seconds to P3 for this repo | Time the script on this repo |

## Constraints and Assumptions

### Constraints
- Bash 3.2 on macOS, and no `timeout` command.
- The orchestrator `SKILL.md` stays under its byte cap, so the P0 step goes in a reference file.

### Assumptions
- `git clone` of a local path works in every runner. If it fails, the script prints the git error and exits non-zero.

## Scenario Paths

**Happy path:** A run's only failures match `baseline-failures.md`. P3 passes and the build report lists them as inherited.

**First-run path:** No `baseline-failures.md` exists. P3 treats the baseline as empty and stops on any failure.

**Error / sad path:** A suite needs an untracked file. The clean clone lacks it, so the suite fails and P3 stops.

**Cross-session continuity:** `baseline-failures.md` sits in `plan/current/`, so a resumed session reads the same baseline. The temporary clone holds no state and goes away when the run ends.

## Acceptance Criteria

- [ ] The implement skill names the affected-tests rule for each cycle and requires one full suite run before P2 completes.
- [ ] Each cycle appends a `Tests run:` line to the build log.
- [ ] P3 still requires a full green suite before acceptance, and it reruns only failed suites first.
- [ ] A run whose only failures match the baseline passes the comparison and lists them. A failure missing from the baseline stops it.
- [ ] The clean clone script runs the suite in a clone of `HEAD`. An untracked file the suite needs makes it fail.
- [ ] The script names the local and CI operating systems when they differ, and removes the clone on every exit.
