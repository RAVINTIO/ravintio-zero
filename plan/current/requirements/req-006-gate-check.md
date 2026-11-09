---
title: "Requirement: REQ-006 - Gate check"
summary: "P3 fails when a gate from an installed archetype breaks."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-006 - Gate check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Source:** US-006
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a team lead, I add a constraint, so that P3 fails when a gate breaks.

## Functional Requirements
- `ravintio-zero/scripts/archetype-gates.mjs` reads gates from the installed archetypes in `ravintio-overrides/archetypes.json`.
- Gate type `file-per-component` fails when a component API has no Pact contract file.
- Gate type `min-value` fails when the mutation score in a report falls below the minimum.
- Gate type `allowlist` fails when the stack in `design.md` holds an entry outside the list.
- The script exits 1 on a failed gate and prints each failure.
- The validate-and-accept skill reads the output.

## Acceptance Criteria
- [ ] AC-1: Missing Pact contract
  - Given the strict-testing archetype and a component API with no Pact contract
  - When the gate check runs
  - Then it exits 1 and names the component
- [ ] AC-2: Low mutation score
  - Given a mutation report with a score below the minimum
  - When the gate check runs
  - Then it exits 1 and prints the score and the minimum
- [ ] AC-3: Stack off the allowlist
  - Given the restricted-stack archetype and a stack entry outside its list
  - When the gate check runs
  - Then it exits 1 and names the entry

## Dependencies
- REQ-003 records the installed archetypes.
- ADR-0295 records the gate design.
