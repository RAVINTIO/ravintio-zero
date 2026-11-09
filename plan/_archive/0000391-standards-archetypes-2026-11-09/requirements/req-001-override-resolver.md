---
title: "Requirement: REQ-001 - Override resolver"
summary: "The resolver returns an override file before the pack copy."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-001 - Override resolver

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Source:** US-001
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a pack user, I put a standard or template in `ravintio-overrides/`, so that the pipeline reads my copy before the pack copy.

## Functional Requirements
- `ravintio-zero/scripts/resolve-override.mjs` takes a pack-relative path under `standards/` or `templates/`.
- It returns `ravintio-overrides/{standards,templates}/{file}` when that file exists, and the pack copy otherwise.
- It rejects a path outside the repo and a symlink with exit 1.
- It gives the same result on every run.

## Acceptance Criteria
- [ ] AC-1: Override wins
  - Given an override template in `ravintio-overrides/templates/`
  - When the resolver looks up that template
  - Then it returns the override path
- [ ] AC-2: Pack copy as fallback
  - Given no override for a standard
  - When the resolver looks up that standard
  - Then it returns the pack path
- [ ] AC-3: Unsafe path refused
  - Given a lookup path that leaves the repo or crosses a symlink
  - When the resolver runs
  - Then it exits 1 and returns no path

## Dependencies
- REQ-002 supplies the protected-rule list that the resolver consults.
- ADR-0292 records the resolver design.
