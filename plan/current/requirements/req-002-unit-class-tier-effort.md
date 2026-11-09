---
title: "Requirement: REQ-002 - unit class, tier, and effort table"
summary: "One table in the dispatch standards maps a unit's class and signals to a model tier and an effort level, and the Done line records them."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - unit class, tier, and effort table

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000386-unit-dispatch
**Source:** US-002
**Priority:** must-have

## User Story

As a pipeline maintainer, I see a class, tier, and effort on every `Done:` line, so that dispatch follows one rule.

## Functional Requirements
- `agent-dispatch-standards.md` defines four classes: `content`, `code`, `test`, and `config`.
- It defines three signals that each add one point: the unit touches three or more files, a hook or standard constrains the output, and the unit follows a `Rework:` line or an open question.
- It holds a lookup table from class and score to tier (`cheaper` or `primary`) and effort (`low`, `medium`, or `high`).
- The table's tier replaces the skill's `recommended_model` for that dispatch. The rule that retries a unit on the primary tier after two cheaper-tier failures stays.
- The `Done:` line takes the form `- Done: {unit} ({class}, {tier}, {effort}, {ISO-8601 timestamp})`. An inline unit logs tier `inline` and effort `none`.
- `build-log.template.md` shows the form. `resume-detect.mjs` still matches a `Done:` line to its `In progress:` line and accepts the unit name `{REQ} inline`.

## Acceptance Criteria
- [ ] AC-1: the table is complete
  - Given `agent-dispatch-standards.md`
  - When a reader looks up a class and a score from 0 to 3
  - Then the table gives one tier and one effort for every pair
- [ ] AC-2: the Done line carries the fields
  - Given the standards, the build-log template, and the implement skill
  - When a reader looks for the `Done:` form
  - Then each shows `{class}, {tier}, {effort}`
- [ ] AC-3: resume detection still works
  - Given a build log with an `In progress:` line and a classified `Done:` line for one unit
  - When `resume-detect.mjs` runs
  - Then it reports no unit in progress

## Dependencies
- none
