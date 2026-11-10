---
title: "Requirement: REQ-006 - Applicable migrations only"
summary: "resume-detect.mjs prints a pending line only for a migration that applies."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-006 - Applicable migrations only

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Source:** US-006
**Priority:** must-have

## User Story

As a session, I see a pending line only for a migration that applies, so that findings stay quiet.

## Functional Requirements
- A migration with no ledger row and a `**Detect:**` line that matches nothing prints no `pending migration` line.
- A migration with no Detect line, or a true Detect, still prints.

## Acceptance Criteria
- [ ] AC-1: Non-matching Detect is quiet
  - Given a migration with no ledger row and a Detect line that matches nothing
  - When `resume-detect.mjs` runs
  - Then it prints no `pending migration` line
- [ ] AC-2: Matching Detect prints
  - Given a migration with no ledger row and a Detect line that matches
  - When `resume-detect.mjs` runs
  - Then it prints the `pending migration` line
- [ ] AC-3: No Detect line prints
  - Given a migration with no ledger row and no Detect line
  - When `resume-detect.mjs` runs
  - Then it prints the `pending migration` line

## Dependencies
- None
