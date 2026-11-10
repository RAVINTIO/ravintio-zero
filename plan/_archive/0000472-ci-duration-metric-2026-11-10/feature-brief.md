---
title: "Feature Brief - CI duration metric"
summary: "workflow-metrics.mjs reports the longest CI run of a feature against a target that a standard names."
status: "approved"
version: "0.1.0"
---
# Feature Brief - CI duration metric

**Feature ID:** 0000472-ci-duration-metric

Source: backlog entry 0000436, from the initiative 0000360 retrospective (evidence row 15).

## Business Goal

Each merge waited about 16 minutes for CI. Feature 0000409 cut it to 4m40s with shards. The 7-minute target was a one-off criterion. No metric or standing check shows CI growth, so it shows only when someone feels it. The run now records CI duration per run, and the governance report compares the longest run with a named target.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| CI duration metric | As a maintainer, I see the longest CI run of a feature in the governance report, so that CI growth shows before it hurts. | must-have | 1 |

## Wanted outcome

- The validate skill writes a `CI duration:` marker to the build log for each CI run it waits on.
- `workflow-metrics.mjs` reports the longest `CI duration:` value against the threshold `ci-duration-seconds`.
- `testing-standards.md` and the governance threshold table name the CI target.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the script, the standards, and the validate skill |

### Data Ownership

No data store.

### Integration Points

None. The marker holds a duration that the validate skill reads from the CI run.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js script and Markdown standards already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A `CI duration:` marker and a `ci-duration-seconds` metric in `workflow-metrics.mjs`.
- A threshold row in `workflow-governance-standards.md` and a CI target in `testing-standards.md`.
- A marker line in the validate-and-accept skill.
- A test, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- A hook or CI job that fails on a slow run.
- Reading run data from GitHub in the script.
- A history of runs across features.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Gate behaviour | The metric reports and never blocks | exit code stays 0 on a breach |
| Skill size | Skill text stays within the cap in `test-0000384-skill-text.sh` | that suite |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The change widens no guard.
- Node.js built-ins only in the script.

### Assumptions
- The validate skill can read a CI run's start and end with `gh`. Impact if wrong: the marker records `unknown` and the metric skips it.
- The target is 420 seconds, the 7-minute figure of 0000409. Impact if wrong: a later step edits one table cell.

## Scenario Paths

**Happy path:** CI finishes, the skill writes `CI duration: 280s ...`, and the report shows the longest value with `ok`.

**Alternative path:** a run has no `CI duration:` marker. The report shows `0` and `ok`.

**Error / sad path:** a CI run exceeds 420 seconds. The report shows `breach` and the exit code stays 0.

**Cross-session continuity:** not applicable.

## Acceptance Criteria

- [ ] `workflow-metrics.mjs` prints a CI duration row with the longest value and a result.
- [ ] A value above the threshold prints `breach` and the exit code stays 0.
- [ ] `workflow-governance-standards.md` holds the marker and the `ci-duration-seconds` threshold.
- [ ] `testing-standards.md` names the CI target.
- [ ] The validate skill writes the marker.
