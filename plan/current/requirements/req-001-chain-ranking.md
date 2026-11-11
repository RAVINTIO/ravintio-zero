---
title: "Requirement: REQ-001 - Start the longest chain first"
summary: "readySteps returns the startable steps with the longest chain behind them first, and chart order breaks ties."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Start the longest chain first

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000491-driver-favours-critical-path
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want the driver to start the longest chain first, so that the initiative ends when its longest chain allows.

## Functional Requirements
- `readySteps(steps, states)` keeps its signature and its filter. It still lists only pending steps whose `After` steps have merged and whose lane is free, one step for each lane.
- The function orders that list by chain length, longest first. Chart order breaks ties.
- The chain length of a step is 1 plus the longest chain among its unmerged dependants. A dependant lists the step in `After`, or is the next unmerged step in the same lane.
- A cycle in the `After` lists ends the count at the step that repeats. The function still returns steps.
- The driver in `initiative-run.mjs` needs no change. It already takes the first free steps of the list.

## Acceptance Criteria
- [ ] AC-1: the longest chain starts first
  - Given steps 1, 2, and 3 can start, and step 3 has two dependants behind it
  - When `readySteps` runs
  - Then it lists step 3 before steps 1 and 2
- [ ] AC-2: ties keep chart order
  - Given two startable steps with equal chains
  - When `readySteps` runs
  - Then the lower step number comes first
- [ ] AC-3: lane order counts as a chain
  - Given a lane of steps 24 to 29 and a one-step lane that can also start
  - When `readySteps` runs
  - Then the lane step comes before the one-step lane
  - And a chart with no `After` or `Lane` data lists steps in chart order

## Dependencies
- None.
