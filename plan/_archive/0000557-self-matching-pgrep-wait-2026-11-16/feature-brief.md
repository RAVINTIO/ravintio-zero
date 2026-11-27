---
title: "Feature Brief - Step sessions wait on a suite without matching their own shell"
summary: "The P0 start actions and the P3 skill tell a session to wait on an end marker or a process id."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Step sessions wait on a suite without matching their own shell

**Feature ID:** 0000557-self-matching-pgrep-wait

## Business Goal

A `pgrep -f` wait loop matches its own shell, so it never sees the suite end. Steps 56 and 60 of an earlier initiative lost up to 10 minutes per loop. The P0 start actions and `ravintio-validate-and-accept` must name the safe wait. Source: backlog entry 0000532.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Safe suite wait | As a step session, I read to wait on an end marker or a returned process id, so that a wait loop ends with the suite | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the skills, the standards, and the tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | none | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| none | none | none | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown skill text, Bash tests |
| Testing | Bash suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- A wait rule in P0 start action 15 and in the fast batch of `ravintio-validate-and-accept`.
- A test that checks both rules and finds no `pgrep -f` wait in any skill or standard.

### Out of Scope
- Hooks or scripts that wait on a process.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Maintainability | Both pack trees match | the existing mirror check |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`.

### Assumptions
- Skill and standard text is the only place that tells a session how to wait.

## Scenario Paths

**Happy path:** A session reads the rule and waits on the end marker.

> The loop ends when the suite writes its marker.

**First-run path:** A session that never ran a suite reads the rule at P0 step 15.

> The rule sits beside the command that starts the suite.

**Error / sad path:** A skill gains a `pgrep -f` wait.

> The test fails and names the file.

**Cross-session continuity:** A resumed session reads the same text.

> No state carries the rule.

## Acceptance Criteria

- [ ] P0 start action 15 says to wait on the end marker or the returned process id.
- [ ] The fast batch of `ravintio-validate-and-accept` says the same.
- [ ] A test fails if any skill or standard tells a session to wait with `pgrep -f`.
