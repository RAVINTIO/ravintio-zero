---
title: "Requirement: REQ-002 - Tags move without a force push"
summary: "The script moves each step tag to its new commit by delete and recreate."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Tags move without a force push

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I move each step tag to its new commit without a force push.

## Functional Requirements
- With `--tags` the script deletes each local step tag and creates a tag of the same name and message at the new step commit.
- With `--push` the script pushes the new branch, deletes each old tag on `origin` by the refspec `:refs/tags/{tag}`, and pushes each new tag by name. `--push` implies `--tags`.
- No command in the script uses `--force`, `-f`, or a `+` refspec.
- Without `--tags` or `--push` the script leaves every tag and remote unchanged.

## Acceptance Criteria
- [ ] AC-1: tags move
  - Given the fixture and `--tags`
  - When the script finishes
  - Then each `v{Version}` tag points at its new step commit and keeps its message
- [ ] AC-2: no force
  - Given the script source
  - When a test searches it for `--force`, ` -f`, and `+refs`
  - Then it finds none
- [ ] AC-3: push without force
  - Given the fixture with a bare `origin` and `--push`
  - When the script finishes
  - Then `origin` holds the new branch and the new tags, and the old tag objects are gone

## Dependencies
- REQ-001.
