---
title: "Requirement: REQ-002 - Add-step helper"
summary: "One command adds a step and writes its row in every chart table."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-002 - Add-step helper

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Source:** US-002
**Priority:** must-have

## User Story

As the human, I add a step with one command, so that no chart table needs a hand edit.

## Functional Requirements
- `initiative-add-step.mjs` reserves the ids with `reserve-id.mjs`, files the backlog entry, and rebuilds the backlog index.
- It writes the step's row in every chart table of `initiative.md`. The tables are Schema changes, Dependencies, Decisions, Baselines, Criteria, P1 skips, and Steps.

## Acceptance Criteria
- [ ] AC-1: Ids and entry
  - Given a valid chart
  - When the human runs add-step with a title
  - Then the script reserves ids, files the entry, and rebuilds the index
- [ ] AC-2: Every table gains a row
  - Given a valid chart
  - When add-step finishes
  - Then each chart table holds a row for the new step
- [ ] AC-3: The chart still parses
  - Given the chart after add-step
  - When `initiative-chart.mjs` reads it
  - Then it parses with no error

## Dependencies
- `reserve-id.mjs` and `initiative-chart.mjs`
