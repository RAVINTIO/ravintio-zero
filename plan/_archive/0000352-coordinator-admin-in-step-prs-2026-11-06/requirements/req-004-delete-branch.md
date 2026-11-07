---
title: "Requirement: REQ-004 - Coordinator squash deletes the branch"
summary: "Every coordinator squash instruction in the pack names --delete-branch."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Coordinator squash deletes the branch

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I read `--delete-branch` in every coordinator squash instruction, so that no merged coordinator branch stays on `origin`.

## Functional Requirements
- `roadmap-standards.md` `## Coordinator PRs` CI bullet names `gh pr merge --squash --delete-branch {n}`.
- The initiative skill names the same command where it describes a coordinator squash.
- No line in `ravintio-zero/` that gives a squash command for an initiative PR omits `--delete-branch`.
- The merge guard stays unchanged.

## Acceptance Criteria
- [ ] AC-1: standards name the flag
  - Given the `## Coordinator PRs` section
  - When a reader looks for the squash command
  - Then it reads `gh pr merge --squash --delete-branch {n}`
- [ ] AC-2: no bare squash command
  - Given every `.md` file under `ravintio-zero/skills/` and `ravintio-zero/standards/`
  - When a test looks for a command line that starts `gh pr merge --squash`
  - Then each such line also holds `--delete-branch`

## Dependencies
- None.
