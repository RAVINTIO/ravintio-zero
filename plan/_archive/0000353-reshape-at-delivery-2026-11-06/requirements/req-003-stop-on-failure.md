---
title: "Requirement: REQ-003 - The script stops and changes nothing on failure"
summary: "A conflict, a missing tag, a bad name, or an existing branch exits 1 and writes nothing."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - The script stops and changes nothing on failure

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Source:** US-003
**Priority:** must-have

## User Story

As a coordinator, I get a stop that names the commit when a replay conflicts.

## Functional Requirements
- A three-way merge that conflicts exits 1, names the short hash and subject of the commit, and drops no hunk.
- A step with no tag `v{Version}`, or a tag that does not point at a commit on the branch, exits 1 and names the step.
- A target branch that already exists exits 1.
- A branch, a tag, or an assigned hash that fails its name pattern exits 1 before any git write.
- On every exit 1 the script writes no branch and moves no tag.

## Acceptance Criteria
- [ ] AC-1: conflict
  - Given a fixture where an assigned admin commit and a step change the same line
  - When the script runs
  - Then it exits 1, names the commit, and the `-reshaped` branch does not exist
- [ ] AC-2: missing tag
  - Given a fixture with one step tag deleted
  - When the script runs
  - Then it exits 1 and names the step
- [ ] AC-3: existing branch
  - Given a fixture where `{branch}-reshaped` exists
  - When the script runs
  - Then it exits 1 and leaves the branch as it was

## Dependencies
- REQ-001.
