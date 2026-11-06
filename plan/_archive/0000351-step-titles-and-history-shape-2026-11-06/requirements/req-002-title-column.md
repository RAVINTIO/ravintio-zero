---
title: "Requirement: REQ-002 - Title column"
summary: "The initiative template charts a Title column in the Steps table."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Title column

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I chart a `Title` column, so that P0, ship, and the check read one title.

## Functional Requirements
- `initiative.template.md` has the `## Steps` columns `Step | Feature id | Title | Backlog entries | Bump | Version | Status`.
- The template note says Chart writes the title in sentence case and that P0, ship, and the history check read it.

## Acceptance Criteria
- [ ] AC-1: template has the column
  - Given `initiative.template.md`
  - When a reader opens the `## Steps` table
  - Then the header row holds a `Title` column after `Feature id`

## Dependencies
- None.
