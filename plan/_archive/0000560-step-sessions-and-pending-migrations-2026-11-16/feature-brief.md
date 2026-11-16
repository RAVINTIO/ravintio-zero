---
title: "Feature Brief - Step sessions meet pending migrations"
summary: "Pins the migration ledger rules that keep a step session from stopping on a migration."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Step sessions meet pending migrations

**Feature ID:** 0000560-step-sessions-and-pending-migrations

## Business Goal

A step session has no human to answer a migrator prompt. 0000536 and 0000399 already stop a step from asking and skip done rows. One gap remains. No test pins the `not applicable` ledger rule that the chart keeps.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Pin ledger rules | As a pack maintainer, I run a test that plants each ledger row kind beside a Detect match. A change to the skip rules then fails the suite. | must-have | 1 |

## Scope Boundaries

### In Scope
- One new suite for `resume-detect.mjs` ledger rows with a true Detect line.
- Closing backlog entry 0000403.

### Out of Scope
- Any change to `resume-detect.mjs`. The chart keeps the `not applicable` rule.
- Any change to the orchestrator resume check or `icrun-migration`. 0000536 covers them.

### Deferred
- none

## Acceptance Criteria

- [ ] A `done` row with a true Detect prints no pending line.
- [ ] A `not applicable` row at the current pack version with a true Detect prints a pending line.
- [ ] A `not applicable` row at an older pack version with a true Detect prints a pending line.
- [ ] A `not applicable` row at the current pack version with a false Detect prints no pending line.
- [ ] Backlog entry 0000403 is gone. The index lists 25 entries.
