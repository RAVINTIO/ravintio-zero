---
title: "Feature Brief - Initiative retrospective"
summary: "A retrospective of every stop and mistake in initiative 0000360, with one backlog entry for each cause that no fix covers."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Initiative retrospective

**Feature ID:** 0000421-initiative-retrospective

## Business Goal

Initiative 0000360 ran with many stops, and the human found it hard to oversee. This step finds the cause of each stop and names the ones that no fix covers. Each unaddressed cause becomes a backlog entry that the coordinator charts as a later step.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Retrospective record | As a human on the loop, I read one record of every stop and mistake, so that I know what caused each one and what remains open. | must-have | 1 |
| Backlog entries | As a coordinator, I get one backlog entry per unaddressed finding, so that I can chart the fixes as steps 23 onward. | must-have | 1 |

## Scope Boundaries

### In Scope
- Read the evidence file, the postmortems from 2026-10-31, the archived build logs of the charted steps, the step logs, and entries 0000412 to 0000414.
- Write a 5 whys chain for each of the 27 rows, group shared causes, and give each a verdict.
- File one backlog entry for each unaddressed finding, or cite an open entry that covers it.
- Mark each finding whose fix would widen a guard.
- Write `plan/retrospectives/0000360-backlog-sweep-retrospective.md` with the `ravintio-retrospective` skill.

### Out of Scope
- Fixing any finding. Each fix is a later step.
- Editing any hook, script, or skill.

### Deferred
- Fixes for the unaddressed findings. They wait for steps 23 onward.

## Acceptance Criteria

- [ ] Every row in the evidence file appears in the record with a verdict.
- [ ] Every unaddressed finding names one backlog entry id.
- [ ] The record lists the entries in a suggested step order, with `Lane` and `After` for each.
- [ ] Each finding names no person and no agent.
