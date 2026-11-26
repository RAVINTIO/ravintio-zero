---
title: "Feature Brief - Plan lists every way a check can pass"
summary: "The plan skill asks the planner to list each way a checked component produces a pass signal."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Plan lists every way a check can pass

**Feature ID:** 0000578-plan-lists-pass-signals

## Business Goal

A check that judges another component by its exit code can pass for the wrong reason. The hook check treated exit 2 as a pass, and a missing guard also exits 2, so the check passed with no guard. The plan skill must make the planner list each path to the pass signal, so each path gets an acceptance criterion.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Pass signal paths step | As a plan author, I list every path that produces a pass signal for a checked component, including launcher failures, so that each path has an acceptance criterion and a failing launcher never passes a check. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The pack holds the plan skill and its tests. |

### Data Ownership

None.

## Stack

Markdown and bash. Tests in bash. CI on GitHub Actions. Build target ci-only.

## Scope Boundaries

### In Scope
- A new step in `src/ravintio-zero/skills/ravintio-plan/SKILL.md`, mirrored to `ravintio-zero/`.
- A suite that checks the step.

### Out of Scope
- A script that finds the pass paths.
- A change to the Test impact scan or its 21-line cap.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill size | Combined `SKILL.md` text at or under 1720 lines | Existing size-cap suites |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.

### Assumptions
- A new section of about 8 lines fits under the 1720-line cap.

## Scenario Paths

**Happy path:** A requirement judges another component by its exit code. The planner lists each path to the pass signal and writes one acceptance criterion for each.

**First-run path:** A plan with no such requirement skips the step with no output.

**Error / sad path:** A launcher cannot run the checked component and exits with the pass code. The step names that path, and a criterion requires the check to fail on it.

**Cross-session continuity:** The step writes into the plan artifacts on disk, so an interrupted session loses nothing.

## Acceptance Criteria

- [ ] The plan skill has a step that lists every path producing a pass signal, including launcher failures.
- [ ] A suite checks the step text.
- [ ] Both pack trees match.
