---
title: "Requirement: REQ-002 - Document the drain"
summary: "The roadmap standards state the drain rule."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Document the drain

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000446-drain-ready-prs-after-a-stop
**Source:** US-002
**Priority:** must-have

## User Story

As a reader of the roadmap standards, I want the drain rule written down, so that the docs match the driver.

## Functional Requirements
- `roadmap-standards.md` says that a queue failure stops new starts but not the queue for other ready PRs.
- The text says that a failed step keeps its `ready` file and a new driver queues it again.

## Acceptance Criteria
- [ ] AC-1: The rule is in the standards
  - Given the roadmap standards
  - When a reader looks at the Concurrent steps section
  - Then it states that other ready PRs still merge after a queue failure

## Dependencies
- REQ-001.
