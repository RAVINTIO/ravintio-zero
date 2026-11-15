---
title: "Feature Brief - Initiative skills do not micromanage"
summary: "The initiative skill relays watcher activity only at phase events, blocks, and stops, and reads step test output only after a stop."
status: "approved"
version: "0.119.0"
---
# Feature Brief - Initiative skills do not micromanage

**Feature ID:** 0000553-coordinator-oversight-not-micromanagement

## Business Goal

The coordinator session tracked each step tool call and read step test output that the step already checks. Its context grew while step 55 ran. The coordinator gives oversight and leaves step detail to the steps and the driver.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Phase-event relay | As the coordinator, I relay watcher lines only at phase events, blocks, and stops, so that my context stays small. | must-have | 1 |
| Test output after a stop | As the coordinator, I read step test output only after a stop, so that I skip checks the step already runs. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the initiative skill and its tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `skills/ravintio-initiative/SKILL.md` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown skill text, bash tests |
| Testing | bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Edit the Reports section of the initiative skill. Relay watcher lines only at phase events, blocks, and stops.
- Add a rule that the coordinator reads step test output only after a stop.
- Update the 0000240 pin on the relay text. Add a test for the new text.

### Out of Scope
- The OpenTelemetry baseline. That data lives outside the repo.
- Changes to `initiative-watch.mjs`. The watcher keeps printing `activity:` lines.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

None.

## Constraints and Assumptions

### Constraints
- Pack edits go in `src/ravintio-zero/` and mirror to `ravintio-zero/` and `.claude/`.

### Assumptions
- The coordinator can ignore `activity:` lines without losing a stop signal, because stops print their own `Blocked:` and `Stopping:` lines.

## Scenario Paths

**Happy path:** A step runs. The watcher prints activity lines. The coordinator relays nothing until a phase event, block, or stop.

> A step reaches a phase `Complete:` line and the coordinator relays it.

**First-run path:** No step has run. The skill text holds the rules, so there is no state to seed.

> None.

**Error / sad path:** A step stops. The coordinator reports the stop, then reads the step test output to explain it.

> The coordinator reads the test output only after the stop.

**Cross-session continuity:** The rules live in the skill file, so a new coordinator session reads them at start.

> None at risk.

## Acceptance Criteria

- [ ] The skill tells the coordinator to relay watcher lines only at phase events, blocks, and stops.
- [ ] The skill tells the coordinator to read step test output only after a stop.
- [ ] A test checks the skill text.
