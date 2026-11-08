---
title: "Requirement: REQ-002 - Component Paths in the design template"
summary: "The design template holds a Component Paths section that gate-write reads."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Component Paths in the design template

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Source:** US-002
**Priority:** must-have

## User Story

As an orchestrator, I want the design template to hold `## Component Paths`, so that `gate-write` passes a subagent's first write.

## Functional Requirements
- `ravintio-zero/templates/design.template.md` holds a `## Component Paths` section above `## Scope`.
- The orchestrator P0 text tells the orchestrator to list every folder the plan writes in that section.

## Acceptance Criteria
- [ ] AC-1: Section placed above Scope
  - Given the design template
  - When a test reads its headings
  - Then `## Component Paths` appears before `## Scope`
- [ ] AC-2: Listed path passes the gate
  - Given a design written from the template that lists `ravintio-zero/tests/`
  - When `gate-write` receives a write to `ravintio-zero/tests/x.sh`
  - Then it exits 0

## Dependencies
- None
