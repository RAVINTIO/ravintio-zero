---
title: "Requirement: REQ-003 - Docs state the summary"
summary: "The driver header, the standards, and an ADR state the summary block."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Docs state the summary

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As the human, I want the pack docs to describe the summary block, so I know what each line means.

## Functional Requirements
- The header comment of `initiative-run.mjs` names the three `I-C Run: Summary:` line kinds and the action rules.
- The "Concurrent steps" section of `roadmap-standards.md` states the rule.
- ADR-0341 records the decision, and `docs/decisions-index.md` lists it.

## Acceptance Criteria
- [ ] AC-1: the driver header names the summary
  - Given the driver script
  - When a reader opens its header comment
  - Then it names the `I-C Run: Summary:` lines
- [ ] AC-2: the standards name the summary
  - Given `roadmap-standards.md`
  - When a reader opens "Concurrent steps"
  - Then it names the `I-C Run: Summary:` lines
- [ ] AC-3: the ADR exists
  - Given `docs/adr/0341-driver-stop-summary.md`
  - When a reader opens it
  - Then it names the `I-C Run: Summary:` lines

## Dependencies
- REQ-001 and REQ-002.
