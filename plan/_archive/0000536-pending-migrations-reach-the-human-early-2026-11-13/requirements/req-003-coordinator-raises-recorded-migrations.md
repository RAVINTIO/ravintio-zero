---
title: "Requirement: REQ-003 - Coordinator raises recorded migrations"
summary: "The coordinator raises each Migration pending line with the human in its next report."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Coordinator raises recorded migrations

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Source:** US-003
**Priority:** must-have

## User Story

As the human, I want the coordinator to raise each recorded migration when I am next available, so that none stays unseen.

## Functional Requirements
- The initiative skill tells the coordinator to read `Migration pending:` lines in step build logs.
- The coordinator lists each one under `Decisions for the human` in its next report.
- The roadmap standards state the same rule in the coordinator section.

## Acceptance Criteria
- [ ] AC-1: Report lists the line
  - Given a step build log with a `Migration pending: 0010` line
  - When the coordinator writes its next report
  - Then `Decisions for the human` names migration 0010 with the options all and none

## Dependencies
- REQ-002 writes the line.
