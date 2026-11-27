---
title: "Requirement: REQ-005 - The delivery text names the cleanup"
summary: "I-E Delivery, the final report, and the initiative skill name the cleanup script."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - The delivery text names the cleanup

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I read the cleanup in I-E Delivery and the final report, so that I run it every time.

## Functional Requirements
- `roadmap-standards.md` holds a rule-anchored I-E Delivery step that names `initiative-cleanup.mjs`, the lock refusal, the archive folder, the worktree removal, and the queue report.
- The step runs after the human merges the initiative PR.
- The final report in `ravintio-initiative/SKILL.md` names the cleanup, and the skill stays under 120 lines.

## Acceptance Criteria
- [ ] AC-1: The standard names the cleanup
  - Given the I-E Delivery section
  - When a test reads the rule anchors
  - Then the cleanup step names the script, the lock, `.git/ravintio-archive/`, and the queue
- [ ] AC-2: The skill names the cleanup
  - Given the initiative skill
  - When a test reads it
  - Then the final report names the cleanup and the line count is under 120

## Dependencies
- REQ-001 to REQ-003.
