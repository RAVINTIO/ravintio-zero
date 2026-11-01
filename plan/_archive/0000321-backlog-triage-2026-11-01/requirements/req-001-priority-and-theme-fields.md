---
title: "Requirement: REQ-001 - priority and theme fields"
summary: "Each backlog entry carries a priority and a theme."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - priority and theme fields

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I give each entry a priority and a theme, so that I can sort the backlog.

## Functional Requirements
- `ravintio-zero/templates/backlog-entry.template.md` adds `priority` (`high`, `medium`, or `low`) and `theme` (kebab-case) to its frontmatter, with a comment that names the allowed values.
- `ravintio-zero/skills/ravintio-file-backlog/SKILL.md` tells the filer to set both fields and to regenerate the index.
- A missing field reads as `medium` and `unsorted`.

## Acceptance Criteria
- [ ] AC-1: template names both fields
  - Given the backlog entry template
  - When a test reads its frontmatter
  - Then it holds `priority` and `theme` with the allowed values named
- [ ] AC-2: filing skill sets both fields
  - Given the filing skill
  - When a test reads it
  - Then it names `priority`, `theme`, and `backlog-index.mjs`

## Dependencies
none
