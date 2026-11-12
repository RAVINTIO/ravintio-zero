---
title: "Feature Brief - Planned restart exits with its own code"
summary: "When a merged step changes the driver, the driver exits with code 75 after its Restart line. A real failure keeps code 1."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Planned restart exits with its own code

**Feature ID:** 0000503-planned-restart-exit-code

## Business Goal

At 00:29 on 2026-11-11 the driver printed `Restart:` after step 27 and exited 1. The host reported the background task as failed, although the driver planned the restart. A distinct exit code lets the host and the coordinator tell a planned restart from a failure.

Source: backlog entry 0000504, pulled in by initiative 0000360 step 53. Bump: minor.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Exit 75 on a restart | As the coordinator, I want the driver to exit 75 after a `Restart:` line, so that the host does not report a planned restart as a failure. | must-have | 1 |
| Keep exit 1 on a failure | As the coordinator, I want a real failure to keep exit 1, so that I still see a failed driver. | must-have | 1 |
| Docs state the code | As the coordinator, I want the standards and the initiative skill to name exit 75 as a planned stop, so that I treat it as one. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver `initiative-run.mjs`, `roadmap-standards.md`, and the initiative skill |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| The driver exit code | ravintio-zero (the driver) | The host and the initiative skill read it |

### Integration Points

None change.

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ES modules) |
| Testing | Bash test files with `helpers/assert.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- A `Restart` stop in `initiative-run.mjs` that carries a planned flag. `main()` exits 75 for it and 1 for every other stop.
- Every stop line that starts `I-D Advance: Restart:` counts, including `Restart: Setup:`.
- If a real failure also stops the run, the exit code stays 1.
- Tests, the driver header comment, `roadmap-standards.md`, the initiative skill, and one ADR.

### Out of Scope
- The `Setup:` stop without a restart. It keeps exit 1.
- The handoff, where the old driver exits 0.
- The watcher, which reads the lock and never sees the code.
- Any hook guard.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | A failure never exits 75 | A test with a restart hit and a later failure |

## Constraints and Assumptions

### Constraints
- The `Restart:` line text stays the same, so the skill and the watcher match it as before.
- The driver adds no dependency.

### Assumptions
- Code 75 (`EX_TEMPFAIL`) means no other driver exit today. Impact if wrong: the coordinator reads a second cause as a restart.

## Scenario Paths

**Happy path:** A merged step changes `initiative-run.mjs`. The driver prints the `Restart:` line and exits 75.

> The host shows a clean planned stop.

**First-run path:** No step changes a watched file. The driver exits 0 at the end, as before.

> No change.

**Error / sad path:** A step blocks or the queue fails, also after a restart hit. The driver exits 1.

> The coordinator sees a failure.

**Cross-session continuity:** The exit code carries no state. A new driver reads the position from the branch ref.

> No change.

## Acceptance Criteria

- [ ] The serial driver exits 75 after a `Restart:` line.
- [ ] The concurrent driver exits 75 after a `Restart:` line.
- [ ] A `Restart: Setup:` line exits 75 and a bare `Setup:` line exits 1.
- [ ] A `Blocked:` stop exits 1, also when a restart hit came first.
- [ ] The standards and the initiative skill name exit 75 as a planned stop.
