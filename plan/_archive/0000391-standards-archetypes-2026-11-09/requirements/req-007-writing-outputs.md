---
title: "Requirement: REQ-007 - Writing outputs from the pick"
summary: "The output style and AGENTS.md section follow the picked writing archetype."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-007 - Writing outputs from the pick

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Source:** US-007
**Priority:** should-have

## User Story

> One requirement doc = one user story.

As a pack user, I pick a writing archetype, so that the output style and `AGENTS.md` section follow it.

## Functional Requirements
- `ravintio-zero/scripts/writing-style.mjs` reads the writing standard through the resolver.
- After `alternative/us-writing`, the printed output style and the `AGENTS.md` section carry the US spelling rule.
- Without a writing pick, the output matches today's output.

## Acceptance Criteria
- [ ] AC-1: Output style follows the pick
  - Given the US writing archetype installed
  - When `writing-style.mjs` prints the output style
  - Then the text carries the US spelling rule
- [ ] AC-2: AGENTS.md section follows the pick
  - Given the US writing archetype installed
  - When `writing-style.mjs` prints the `AGENTS.md` section
  - Then the section carries the US spelling rule
- [ ] AC-3: No pick, no change
  - Given no writing archetype installed
  - When `writing-style.mjs` prints either output
  - Then the text matches the pack standard

## Dependencies
- REQ-001 resolver and REQ-005 US writing archetype.
