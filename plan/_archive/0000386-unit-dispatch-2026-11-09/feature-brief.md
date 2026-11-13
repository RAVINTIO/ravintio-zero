---
title: "Feature Brief - Unit dispatch"
summary: "Content units run the TDD loop inline, and every dispatched unit gets a class, a model tier, and an effort level from one table."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Unit dispatch

**Feature ID:** 0000386-unit-dispatch

Source: backlog entries 0000330 and 0000366, from the step 10 row of initiative 0000360.

## Business Goal

Small content units pay for three subagents each, and runs log a departure when they skip them. The orchestrator also picks one model tier for a whole phase, so a code-heavy unit and a prose rewrite run on the same tier. This feature adds an inline path for small units and a per-unit table for tier and effort. Rework by class and tier then shows where the table needs tuning.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Inline TDD path | As a pipeline maintainer, I run a small content unit inline with its RED marker before its GREEN marker, so that the build log shows no departure. | must-have | 1 |
| Unit classifier table | As a pipeline maintainer, I see a class, tier, and effort on every `Done:` line, so that dispatch follows one rule. | must-have | 1 |
| Rework by class and tier | As a pipeline maintainer, I read rework counts by class and tier, so that I can tune the table from evidence. | should-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the skills, standards, scripts, and tests |

### Data Ownership

No data store.

### Integration Points

None. The `Done:` line is read by `resume-detect.mjs`, `build-log-check.mjs`, and `workflow-metrics.mjs`.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js scripts, bash tests, Markdown skills and standards |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- An inline unit rule in `ravintio-implement`, and `RED:` and `GREEN:` markers.
- A `build-log-check.mjs` check that every `GREEN:` marker has an earlier `RED:` marker.
- A class, tier, and effort table in `agent-dispatch-standards.md`, and a `Done:` line that carries them.
- A rework-by-class-and-tier section in `workflow-metrics.mjs`.

### Out of Scope
- A separate classifier skill. The table in the dispatch standards is the classifier.
- A human override of a tier at the design gate.
- Langfuse evaluation (entry 0000254).

### Deferred
- Tuning the table. Later runs tune it from the metrics report.

## Constraints and Assumptions

### Constraints
- No new library or service.
- The rule that retries a unit on the primary tier after two cheaper-tier failures stays.

### Assumptions
- The Agent tool accepts an `effort` value. Impact if wrong: the table still records the effort and the dispatch omits it.

## Acceptance Criteria

- [ ] `ravintio-implement` names the inline unit rule: a unit that applies agreed text or changes one file.
- [ ] An inline unit logs `RED:` before `GREEN:`, and `build-log-check.mjs` accepts it with no departure line. A `GREEN:` marker with no earlier `RED:` marker is a finding.
- [ ] A unit that misses the rule still runs the test-writer, implementer, and refactor subagents.
- [ ] `agent-dispatch-standards.md` holds a table that maps class and signals to tier and effort. `Done:` lines carry `{class}, {tier}, {effort}`.
- [ ] `workflow-metrics.mjs` reports units and rework by class and tier.
