---
title: "Requirement: REQ-001 - Step title form"
summary: "Ship titles a step PR with the feature id and the Title column."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Step title form

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I read `{feature-id}: {Feature title} (#{n})` on each step commit, so that I match a commit to its feature at a glance.

## Functional Requirements
- The ship skill titles a step PR `{feature-id}: {Feature title}`, with the 7-digit feature id and the `Title` column text.
- `roadmap-standards.md` and `commit-standards.md` state the step form and the chore form `{initiative-id}: Initiative admin (#{n})`.
- The orchestrator tells P0 to use the `Title` column as the feature brief title in an initiative step.

## Acceptance Criteria
- [ ] AC-1: ship titles the step PR
  - Given an initiative step reaches I-D Advance
  - When ship raises the PR
  - Then the ship skill says to title it `{feature-id}: {Feature title}` from the `Title` column
- [ ] AC-2: standards state both forms
  - Given the two standards files
  - When a reader looks for the commit title forms
  - Then both files name the step form and the chore form

## Dependencies
- REQ-002 adds the `Title` column.
