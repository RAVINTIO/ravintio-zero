---
title: "Requirement: REQ-004 - Report format and standards"
summary: "The initiative skill lists decisions apart from routine fixes, and the standards name the status command."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Report format and standards

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Source:** US-004
**Priority:** should-have

## User Story

As a human, I read decisions apart from routine fixes. I then oversee the run.

## Functional Requirements
- `ravintio-initiative/SKILL.md` tells the coordinator to run `initiative-status.mjs` before each status report.
- The skill defines a report with two parts. `Decisions for you` lists each open question or stop that needs the human. `Routine fixes made` lists the pre-approved fixes the coordinator applied.
- The skill tells the coordinator to relay the new watcher events.
- `roadmap-standards.md` describes the status command, the new watcher events, and the driver line.

## Acceptance Criteria
- [ ] AC-1: the skill names the status command
  - Given the skill text
  - When a test greps it
  - Then it names `initiative-status.mjs`
- [ ] AC-2: the skill defines the two report parts
  - Given the skill text
  - When a test greps it
  - Then it names `Decisions for you` and `Routine fixes made`
- [ ] AC-3: the standards describe the events
  - Given `roadmap-standards.md`
  - When a test greps it
  - Then it names the status command and `driver exited`

## Dependencies
- REQ-001 to REQ-003 set the final behaviour.
