---
title: "Requirement: REQ-004 - P3 docs edit pass"
summary: "A fresh subagent fixes writing problems in changed user-facing docs at P3."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - P3 docs edit pass

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I see a fresh-context subagent review changed user-facing docs at P3, so that the problems a script misses get fixed before ship.

## Functional Requirements
- The validate skill names a docs edit pass and its scope: `docs/`, READMEs, and the changelog. Plan records are out of scope.
- The pass dispatches a fresh-context subagent that reviews each changed doc against `writing-standards.md`.
- The pass is a loop under `ravintio-loop-runner` with the cap of 3. Its pass condition is `prose-check.mjs check` exiting 0 on the changed docs.
- The subagent fixes what it finds and the build log records what it changed.

## Acceptance Criteria
- [ ] AC-1: skill names the pass
  - Given the validate skill text
  - When a test reads it
  - Then it names the edit pass, the three scope paths, and the exclusion of plan records
- [ ] AC-2: linter is the pass condition
  - Given the validate skill text
  - When a test reads it
  - Then it says the pass ends only when `prose-check.mjs check` passes on the changed docs
- [ ] AC-3: size caps hold
  - Given the edited skill
  - When the cap tests run
  - Then every skill size and line cap passes

## Dependencies
- REQ-001 and the loop-runner skill.
