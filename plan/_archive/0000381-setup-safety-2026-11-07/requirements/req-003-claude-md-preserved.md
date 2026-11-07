---
title: "Requirement: req-003 - Keep a developer CLAUDE.md"
summary: "A first install moves a developer CLAUDE.md content to overrides."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Keep a developer CLAUDE.md

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Source:** US-003
**Priority:** must-have

## User Story

As a developer, I install the pack into a repo that has a `CLAUDE.md`, so that my content moves to `ravintio-overrides/instructions/`.

## Functional Requirements

- If the boot file exists and holds no pack marker line, setup copies its content to `ravintio-overrides/instructions/` before the write.
- Setup prints the path that now holds the content, and never overwrites an existing file there.
- A re-run keeps today's behaviour, because the pack marker is present.
- The regenerated boot file includes the moved content through the override block.

## Acceptance Criteria

- [ ] AC-1: Content moved
  - Given a custom `CLAUDE.md` with no pack marker
  - When setup runs for the first time
  - Then the content sits in `ravintio-overrides/instructions/` and setup names the file
- [ ] AC-2: Content included
  - Given the moved content
  - When setup finishes
  - Then the new `CLAUDE.md` contains it
- [ ] AC-3: Re-run moves nothing
  - Given a second setup run
  - When it ends
  - Then no new file appears in `ravintio-overrides/instructions/`

## Dependencies

- None
