---
title: "Requirement: REQ-001 - List the Decisions rows for a step"
summary: "A module reads the chart and lists each Decisions row that names a step, with ranges expanded."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - List the Decisions rows for a step

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000487-steps-apply-decision-rows
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I list every Decisions row that names my step, including a range, so that I miss no pre-approved answer.

## Functional Requirements
- `decision-rows.mjs` exports `parseDecisions(text)`. It reads the `## Decisions` table by header name and returns `{ steps, fork, answer, bump }` for each row. `steps` is a sorted list of numbers.
- The Step cell takes a number, a range such as `25-41`, or a comma list such as `1, 3`. A cell the parser cannot read gives an empty list.
- `rowsForStep(text, n)` returns the rows whose list holds `n`. It skips a row whose Fork is `none`.
- `node decision-rows.mjs list --step {n} [--chart {path}]` prints one line for each row, as `{fork} => {answer}`. The default chart is `plan/current-initiative/initiative.md`. With no row, it prints `none`. A missing chart gives `none` and exit 0.
- The module treats chart text as data. It runs none of it and builds no path from it.

## Acceptance Criteria
- [ ] AC-1: a range row names every step in it
  - Given a table with a row `25-41`
  - When the module lists step 40
  - Then it prints that row
- [ ] AC-2: a step with no row gets none
  - Given a table whose rows name steps 1 to 41 and a `none` row for step 45
  - When the module lists step 45
  - Then it prints `none`
- [ ] AC-3: a comma list and a single number both match
  - Given rows `1, 3` and `3`
  - When the module lists step 3
  - Then it prints both rows

## Dependencies
- None.
