---
title: "Requirement: REQ-001 - Relay at events"
summary: "The initiative skill relays watcher lines only at phase events, blocks, and stops."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Relay at events

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000553-coordinator-oversight-not-micromanagement
**Version:** 0.119.0
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I relay watcher lines only at phase events, blocks, and stops, so that my context stays small.

## Functional Requirements
- The Reports section no longer tells the coordinator to relay each `I-C Run: activity:` line.
- The Reports section tells the coordinator to relay watcher lines only at phase events, blocks, and stops.
- The skill still tells the coordinator to relay each `I-C Run: event:` line.

## Acceptance Criteria
- [ ] AC-1: Activity lines stay unrelayed
  - Given the initiative skill text
  - When the test reads the Reports section
  - Then it holds no instruction to relay each activity line
  - And it names phase events, blocks, and stops as the only relay points
- [ ] AC-2: Event lines stay relayed
  - Given the initiative skill text
  - When the test reads it
  - Then it still holds `I-C Run: event:`

## Dependencies
- None
