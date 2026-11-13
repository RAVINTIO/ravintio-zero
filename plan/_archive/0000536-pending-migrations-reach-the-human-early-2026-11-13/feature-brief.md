---
title: "Feature Brief - Pending migrations reach the human early"
summary: "A step session records a pending migration and carries on. The chart collects the human's answer before any step starts."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Pending migrations reach the human early

**Feature ID:** 0000536-pending-migrations-reach-the-human-early

## Business Goal

On 2026-11-12 at 02:26 step 55 stopped in P0 to ask about pending migration 0009. The driver exited and the run waited about 4.5 hours. The human must see each pending migration at chart time, and a step must never stop on one.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Chart-time migration answers | As the human, I answer every pending migration at I-A Chart, so that no step asks me later. | must-have | 1 |
| Step records and continues | As the human, I want a step session to log a pending migration and carry on, so that the driver never waits for me. | must-have | 1 |
| Coordinator raises recorded migrations | As the human, I want the coordinator to raise a recorded migration when I am next available, so that none stays unseen. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, and tests that define the pipeline |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/state/migrations.md` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown skills and standards, Bash tests |
| Testing | `ravintio-zero/tests/` shell tests |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- The `ravintio-initiative` skill: I-A Chart runs resume detection and lists each pending migration.
- The roadmap standards: a `Chart-time migrations` section, an I-C Run rule, and a coordinator rule.
- The orchestrator resume-detection check 1: a step session records and carries on.
- A `Migration:` row form in `## Decisions` that runs a migration at once.

### Out of Scope
- Any change to `resume-detect.mjs` output or to `ravintio-migrator` behaviour in a human session.
- Any hook change.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Step stops on a pending migration | 0 | A test reads the rule text |

## Constraints and Assumptions

### Constraints
- No guard widens. `ravintio-migrator` still runs only on a human's confirmation or a chart row.

### Assumptions
- The human approved each migration that has a `Migration:` row, at chart time.

## Scenario Paths

**Happy path:** Chart lists pending migration 0010. The human approves it. Chart writes a `Migration:` row. The first step runs the migration with no question.

**First-run path:** A chart with no pending migration lists none and writes no row.

**Error / sad path:** A migration appears mid-run with no row. The step logs `Migration pending: {id}` in its build log and carries on. The coordinator raises it.

**Cross-session continuity:** The build log line survives a session change. The coordinator reads it on its next report.

## Acceptance Criteria

- [ ] The initiative skill and roadmap standards require I-A Chart to list each pending migration and take the human's answer before any step starts.
- [ ] Each answer becomes a `## Decisions` row whose Fork starts with `Migration:`.
- [ ] A step session with a pending migration and no row logs `Migration pending: {id}` and carries on.
- [ ] A step session with a `Migration:` row runs `ravintio-migrator` for it with no question.
- [ ] The coordinator raises each `Migration pending:` line in its next report.
