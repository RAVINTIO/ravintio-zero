---
title: "Requirement: req-002 - Standards agree"
summary: "Standards agree."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - Standards agree

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see `formatting-standards.md` and `writing-standards.md` agree on dates and semicolons, so that the agent gets no conflicting rule.

## Functional Requirements

- `formatting-standards.md` section 1 requires `2026-08-18` or "August 18, 2026" in body text and keeps `YYYY-MM-DD` for filename prefixes.
- `formatting-standards.md` section 4 lists no semicolon as a replacement for the em dash.
- `em-dash-guard.mjs` suggests a comma, colon, full stop, or parentheses, and no semicolon.
- `formatting-standards.md` points to `writing-standards.md` as the prose standard.

## Acceptance Criteria

- [ ] AC-1: Dates agree
  - Given both standards
  - When a test reads the date rules
  - Then both name the ISO and long forms and neither requires `DD MMM YYYY`
- [ ] AC-2: Semicolon suggestion is gone
  - Given `formatting-standards.md` and `em-dash-guard.mjs`
  - When a test blocks a write that holds an em dash
  - Then the message and the standard offer no semicolon
