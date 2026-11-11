---
title: "Requirement: REQ-001 - Actor names in the reply conventions"
summary: "The reply conventions name each actor by role and bar I and you."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Actor names in the reply conventions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000521-replies-name-actors-by-role
**Source:** US-001
**Priority:** must-have

## User Story

As the human, I read replies that name each actor by role, so that I know who acts in every sentence.

## Functional Requirements
- `standard-boot.md` and `codex-boot.md` hold an `Actor names` paragraph in `## Reply Conventions`. It tells a reply to name each actor by role and never use "I" or "you".
- The orchestrator skill states the same rule beside the reporting rule.
- The roadmap standards state the rule under `#### Reply prefixes`.
- The orchestrator `SKILL.md` stays at or under 9000 bytes.

## Acceptance Criteria
- [ ] AC-1: the boot templates hold the rule
  - Given `standard-boot.md` and `codex-boot.md`
  - When a test reads the Reply Conventions section
  - Then each names actors by role and bars "I" and "you"
- [ ] AC-2: the skill and the standards hold the rule
  - Given the orchestrator skill and the roadmap standards
  - When a test reads them
  - Then each states the rule
- [ ] AC-3: the orchestrator skill stays under its cap
  - Given the edited orchestrator skill
  - When a test measures it
  - Then it holds 9000 bytes or fewer

## Dependencies
- None.
