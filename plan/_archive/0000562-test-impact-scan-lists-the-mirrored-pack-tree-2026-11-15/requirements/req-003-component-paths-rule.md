---
title: "Requirement: REQ-003 - Component Paths rule"
summary: "P0 lists the source tree in Component Paths for a pack file edit."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Component Paths rule

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Source:** US-003
**Priority:** must-have

## User Story

As a P0 author, I list `src/ravintio-zero/` in `## Component Paths` when the run edits a pack file, so that gate-write allows the mirrored edit.

## Functional Requirements
- `orchestrator-p0-gate.md` tells P0 to list `src/ravintio-zero/` and `ravintio-zero/` in `## Component Paths` when the run edits a pack file.

## Acceptance Criteria
- [ ] AC-1: rule present
  - Given the P0 gate reference
  - When P0 writes `design.md`
  - Then the reference names both trees for a pack file edit

## Dependencies
- None
