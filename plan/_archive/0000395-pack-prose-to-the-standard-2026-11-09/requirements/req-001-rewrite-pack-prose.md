---
title: "Requirement: REQ-001 - Rewrite the pack's prose"
summary: "Each Markdown file in the pack and docs/ scope passes the prose linter."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-001 - Rewrite the pack's prose

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000395-pack-prose-to-the-standard
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I run the prose linter over the pack and see no breach, so that consumer repos copy a clean style.

## Functional Requirements
- Each Markdown file under `ravintio-zero/`, `docs/`, `ravintio-overrides/`, and the repository root has no sentence-length, passive, em-dash, semicolon, or blocklist breach.
- Each rewrite keeps the file's meaning, headings, tables, and rule anchors.
- Text in code font, code blocks, tables, and front matter stays as it was.

## Acceptance Criteria
- [ ] AC-1: No breach remains
  - Given the rewrite is complete
  - When I run `node ravintio-zero/scripts/prose-check.mjs check --baseline` with an empty baseline for these files
  - Then the command exits 0
- [ ] AC-2: Rule anchors survive
  - Given a file holds a rule anchor comment
  - When the rewrite finishes
  - Then the same anchor ids appear in the same files

## Dependencies
- The linter from step 14 and the anchors from step 4.
