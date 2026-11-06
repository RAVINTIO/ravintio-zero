---
title: "Requirement: REQ-004 - One-commit PR subject"
summary: "A one-commit coordinator PR uses the titled form for its commit subject."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - One-commit PR subject

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Source:** US-004
**Priority:** should-have

## User Story

As a coordinator, I write a one-commit PR subject in the titled form, so that the squash keeps the title.

## Functional Requirements
- `## Coordinator PRs` in `roadmap-standards.md` says that in a one-commit PR the commit subject uses the same `{id}-{slug}: {summary}` form, because GitHub takes the squash title from the commit.

## Acceptance Criteria
- [ ] AC-1: the standard says so
  - Given `roadmap-standards.md`
  - When a reader opens `## Coordinator PRs`
  - Then it states the one-commit subject rule

## Dependencies
- None.
