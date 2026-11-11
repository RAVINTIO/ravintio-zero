---
title: "Requirement: REQ-001 - Coordinator shell section"
summary: "The roadmap standards hold a section on shell use for the coordinator, and the initiative skill points to it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Coordinator shell section

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000474-coordinator-shell-guidance
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I read one section on shell use, so that zsh and guard snags stop costing time.

## Functional Requirements
- `roadmap-standards.md` holds a section `### Coordinator shell tasks`.
- The section names bash as the shell for scripts and says to write a script with the Write tool, then run it with `bash {script}`.
- The section lists three snags.
  - zsh does not split `set -- $x`.
  - zsh reads `$b:r` as a modifier.
  - A JavaScript `replace` with `$'` in the replacement text duplicates text.
- The section names `initiative-queue.mjs drain`, `bulk-edit.mjs`, and `coordinator-pr-check.mjs --base` for the repeated tasks.
- The section says the guards `merge-guard` and `block-forced-add` stay strict, so a script replaces a variable, a compound command, or a quoted flag.
- The section carries a `<!-- rule: coord-shell-tasks -->` anchor.
- The initiative skill gains a pointer to the section in no more than four lines.

## Acceptance Criteria
- [ ] AC-1: The section exists
  - Given the roadmap standards
  - When a reader searches for `Coordinator shell tasks`
  - Then the section names bash, the Write tool, and the three snags
- [ ] AC-2: The skill points to it
  - Given the initiative skill
  - When a reader searches for `coord-shell-tasks`
  - Then the skill names the section and the total skill text stays within its line cap

## Dependencies
- None
