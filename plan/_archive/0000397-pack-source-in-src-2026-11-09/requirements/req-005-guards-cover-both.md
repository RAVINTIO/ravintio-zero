---
title: "Requirement: REQ-005 - Guards cover both paths"
summary: "Each guard of ravintio-zero/ also covers src/ravintio-zero/."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Guards cover both paths

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I rely on guards that cover both paths, with no new allowed form.

## Functional Requirements
- Each hook, script, and workflow check that names `ravintio-zero/` also covers `src/ravintio-zero/`.
- A test per guard proves it blocks the same action on both paths.
- No guard gains an allowed form.

## Acceptance Criteria
- [ ] AC-1: Same block
  - Given an action that a guard blocks in `ravintio-zero/`
  - When the same action targets `src/ravintio-zero/`
  - Then the guard blocks it with the same rule
- [ ] AC-2: No new allowance
  - Given the guard allowlists before and after
  - When you compare them
  - Then the only differences are the added `src/ravintio-zero/` forms of existing entries

## Dependencies
- REQ-001.
