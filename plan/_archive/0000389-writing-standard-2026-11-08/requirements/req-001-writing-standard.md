---
title: "Requirement: req-001 - Writing standard"
summary: "Writing standard."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Writing standard

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Source:** US-001
**Priority:** must-have

## User Story

As a developer who installs Zero, I get `writing-standards.md`, so that my agent writes to one documented standard.

## Functional Requirements

- `ravintio-zero/standards/writing-standards.md` holds the British English variant of the Google developer documentation style.
- The file marks a `style-rules` region and a `summary` region. Generators read only those regions.
- The standard follows its own rules: no em dash, no semicolon, and sentences under 25 words.

## Acceptance Criteria

- [ ] AC-1: Standard exists with both regions
  - Given the pack source
  - When a test reads `standards/writing-standards.md`
  - Then the file holds a `style-rules` region and a `summary` region, each with text
- [ ] AC-2: Standard follows itself
  - Given `standards/writing-standards.md`
  - When a test scans it for U+2014 and for semicolons outside code spans
  - Then the scan finds none
