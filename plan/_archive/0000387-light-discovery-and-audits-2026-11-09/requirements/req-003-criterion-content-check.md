---
title: "Requirement: REQ-003 - Criterion content check"
summary: "Criterion content check"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Criterion content check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I want discovery to check that tested content exists before it confirms a criterion, so that no criterion tests nothing.

## Functional Requirements

- `orchestrator-p0-coaching.md` tells the agent to check that at least one instance exists before it confirms a criterion about existing content or data.
- If none exists, coaching offers a reworded criterion before the design gate.

## Acceptance Criteria

- [ ] AC-1: Check rule
  - Given the P0 coaching reference
  - When a reader looks for criteria rules
  - Then it requires the instance check before confirmation
- [ ] AC-2: Reworded offer
  - Given a fixture criterion that Mermaid diagrams render as SVG, in a repo with no diagram
  - When coaching applies the rule
  - Then it offers a reworded criterion

## Dependencies

- None.
