---
title: "Feature Brief - Build log marker helper"
summary: "A script writes RED, GREEN, and Done marker lines with a clock read."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Build log marker helper

**Feature ID:** 0000575-build-log-marker-helper

## Business Goal

Step 51 typed its RED and GREEN times by hand, so they were approximate. The rule says every time comes from a clock read. A script that reads the clock and appends the marker line removes the hand-typed time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Marker script | As a step session, I append a marker line with one command, so that its time comes from a clock read | must-have | 1 |
| Skill wiring | As the implement skill, I name the script for each RED, GREEN, and Done line, so that sessions use it | must-have | 1 |

## Scope Boundaries

### In Scope
- `ravintio-zero/scripts/build-log-mark.mjs` with a test.
- Implement skill and standards text that name the script.

### Out of Scope
- Other marker kinds, such as `In progress:` and `Tests run:`.
- Changes to `build-log-check.mjs`.

### Deferred
- none

## Acceptance Criteria

- [ ] The script takes a kind (`RED`, `GREEN`, or `Done`) and a unit, and appends the line with a clock-read UTC time.
- [ ] `Done` also takes the class, tier, and effort fields.
- [ ] The implement skill names the script for each of the three lines.
- [ ] A test covers each kind and the failure cases.
