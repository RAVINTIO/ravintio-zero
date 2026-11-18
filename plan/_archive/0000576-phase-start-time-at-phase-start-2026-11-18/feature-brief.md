---
title: "Feature Brief - Record each phase start time when the phase begins"
summary: "A build-log check fails a phase block whose Start is later than the first commit of that phase's artifacts."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Record each phase start time when the phase begins

**Feature ID:** 0000576-phase-start-time-at-phase-start

## Business Goal

Step 4 of an earlier run wrote the P1 to P3 build-log blocks at phase end. Their wall clock read 0 minutes and the build report showed `not recorded` for three phases. A check that compares each `Start` with the phase's first artifact commit catches the late write at ship.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Start-time check | As the ship phase, I fail a phase block whose `Start` follows its first artifact commit, so that a late block write is caught | must-have | 1 |
| Reference wiring | As the orchestrator, I name the check in the Phase Invocation reference, so that sessions know to write the block first | must-have | 1 |

## Scope Boundaries

### In Scope
- A new check in `ravintio-zero/scripts/build-log-check.mjs` with a test.
- A line in the Phase Invocation reference that names the check.

### Out of Scope
- Changes to checks 1 to 9.
- A helper script that writes the phase block.

### Deferred
- none

## Acceptance Criteria

- [ ] A phase block whose `Start` is later than the first commit of that phase's artifacts fails the check and names the phase.
- [ ] A block whose `Start` is at or before that commit passes. A phase with no committed artifact, or a log outside git, passes.
- [ ] The Phase Invocation reference names the check.
- [ ] A test covers the failing, passing, and skipped cases.
