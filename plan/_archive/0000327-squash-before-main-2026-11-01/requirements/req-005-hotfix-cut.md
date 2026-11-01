---
title: "Requirement: REQ-005 - Hotfix cut"
summary: "A run outside an initiative cuts a hotfix branch."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Hotfix cut

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I want a run outside an initiative to cut a `hotfix/` branch, so that the branch name says it targets `main`.

## Functional Requirements
- Discovery Start Actions step 2 offers `git checkout -b hotfix/{feature-id}` in place of `feat/{feature-id}`.
- No pack file other than `CLAUDE.md` and `custom-001-local-git-only.md` tells a run outside an initiative to cut a `feat/` branch. Those two are human-owned and stay unchanged.

## Acceptance Criteria
- [ ] AC-1: hotfix cut
  - Given `orchestrator-p0-start-actions.md`
  - When a test reads step 2
  - Then it offers `hotfix/{feature-id}` and no `feat/{feature-id}`
- [ ] AC-2: no other pack text
  - Given the pack skills, standards, and templates
  - When a test searches for `checkout -b feat/`
  - Then it finds nothing

## Dependencies
none
