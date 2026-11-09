---
title: "Requirement: req-004 - Codex section"
summary: "Codex section."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - Codex section

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Source:** US-004
**Priority:** must-have

## User Story

As a Codex user, I get a writing section in `AGENTS.md`, so that Codex follows the standard.

## Functional Requirements

- `ravintio-zero/scripts/writing-style.mjs codex` prints a section between `<!-- ravintio-writing:start -->` and `<!-- ravintio-writing:end -->` markers. It holds a heading, the `summary` region, and a pointer to `ravintio-zero/standards/writing-standards.md`.
- `setup.sh` and `setup.ps1` append the section to `AGENTS.md` after they regenerate the boot file.
- Setup writes no output style file and no `outputStyle` key for `codex`.

## Acceptance Criteria

- [ ] AC-1: Section present
  - Given a repo
  - When setup runs for `codex`
  - Then `AGENTS.md` holds one writing section that matches a fresh generation
- [ ] AC-2: Rerun keeps one section
  - Given an `AGENTS.md` with the section
  - When setup runs again
  - Then `AGENTS.md` holds exactly one writing section
