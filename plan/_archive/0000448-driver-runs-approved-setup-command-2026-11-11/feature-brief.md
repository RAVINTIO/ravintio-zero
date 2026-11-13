---
title: "Feature Brief - Driver runs the approved setup command"
summary: "At a Setup: stop the driver runs the exact command from the Confirmation: row and continues."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver runs the approved setup command

**Feature ID:** 0000448-driver-runs-approved-setup-command

Source: backlog entry 0000427, from the initiative 0000360 retrospective (evidence row 18).

## Business Goal

Four steps that changed hooks, skills, or setup each stopped the driver with `Setup:` for the same approved command. Each stop needed a coordinator restart. The driver now runs the exact command from the `Confirmation:` row and continues. A missing or different command still stops the run.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Driver runs the approved setup command | As a coordinator, I let the driver rerun the approved setup command at a `Setup:` stop, so that the run continues with no restart. | must-have | 1 |

## Wanted outcome

- The driver reads the `Confirmation:` row for setup from `## Decisions` in the chart.
- If the row names exactly one valid command, the driver runs it and carries on.
- If the row is missing, differs from the allowed form, or the command fails, the driver stops as it does today.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver, the initiative skill, and the roadmap standards |

### Data Ownership

No data store.

## Scope Boundaries

### In Scope
- A `setup-command.mjs` helper that reads the row and checks the command.
- The driver calls it at a `Setup:` stop, in the serial and the concurrent path.
- Text in the roadmap standards and the initiative skill.

### Out of Scope
- A change to `setup.sh` or any hook.
- Any widening of a guard.

### Deferred
- The hook check in step 3 of the initiative skill stays with the coordinator.

## Acceptance Criteria

- [ ] A `Setup:` stop with a valid row runs the command and continues.
- [ ] A missing row, a different command, or a failed command still stops the driver.
- [ ] A `Restart:` hit still stops the driver.
