---
title: "Requirement: REQ-002 - Protected rules"
summary: "A list of hook-enforced rules that an override never relaxes."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-002 - Protected rules

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Source:** US-002
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a maintainer, I list the rules that a hook enforces, so that an override never relaxes one.

## Functional Requirements
- `ravintio-zero/archetypes/protected.json` maps a pack-relative path to mode `ignore` or mode `require`.
- Mode `ignore` makes the resolver return the pack copy whatever the override holds.
- Mode `require` lists pinned lines. The resolver returns the pack copy when the override drops one.
- A test plants a relaxing override and expects the pack copy.

## Acceptance Criteria
- [ ] AC-1: Ignored file
  - Given an override of a file that has mode `ignore`
  - When the resolver looks up that file
  - Then it returns the pack copy
- [ ] AC-2: Pinned line dropped
  - Given an override that omits a pinned line of a `require` entry
  - When the resolver looks up that file
  - Then it returns the pack copy
- [ ] AC-3: Pinned lines kept
  - Given an override that keeps every pinned line
  - When the resolver looks up that file
  - Then it returns the override

## Dependencies
- REQ-001 resolver.
- ADR-0293 records the list format.
