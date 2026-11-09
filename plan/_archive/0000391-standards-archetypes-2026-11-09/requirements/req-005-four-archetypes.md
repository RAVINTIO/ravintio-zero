---
title: "Requirement: REQ-005 - Four starter archetypes"
summary: "The catalogue holds US writing, restricted stack, language standards, and strict testing."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-005 - Four starter archetypes

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Source:** US-005
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a team lead, I pick US writing, restricted stack, language standards, or strict testing, so that the pipeline follows my rules.

## Functional Requirements
- `ravintio-zero/archetypes/` holds a README and four archetypes, each with an `archetype.json` and a `files/` folder.
- `alternative/us-writing` swaps the British spelling rule for US spelling.
- `constraint/restricted-stack` allowlists the stack in `design.md`.
- `alternative/language-standards` swaps the language standards the pipeline reads.
- `constraint/strict-testing` adds a Pact contract gate and a mutation score gate.
- Each archetype passes the prose check and keeps every protected rule.

## Acceptance Criteria
- [ ] AC-1: Four manifests
  - Given the catalogue
  - When the user runs `archetype list`
  - Then it prints exactly four archetypes with a kind and summary each
- [ ] AC-2: US writing passes prose check
  - Given the US writing archetype installed
  - When the prose check runs over its files
  - Then it reports no breach
- [ ] AC-3: Protected rules survive
  - Given each archetype installed in turn
  - When the resolver looks up each protected file
  - Then it returns the pack copy for every `ignore` entry

## Dependencies
- REQ-001, REQ-002, REQ-003, and REQ-006.
- The strict-testing archetype names Pact, Stryker or PIT, and Playwright MCP. The pack installs none.
