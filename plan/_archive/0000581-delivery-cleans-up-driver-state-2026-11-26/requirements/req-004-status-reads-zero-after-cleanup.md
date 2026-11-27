---
title: "Requirement: REQ-004 - A cleaned root reads zero in the status script"
summary: "After the cleanup, initiative-status.mjs reports no merged, ready, or running steps for a new chart."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - A cleaned root reads zero in the status script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I run one script after the initiative PR merges, so that the driver state of the delivered initiative leaves `plan/`.

## Functional Requirements
- After the cleanup, `initiative-status.mjs` on a new pending chart prints `merged 0, ready 0, running 0`.

## Acceptance Criteria
- [ ] AC-1: The status reads zero
  - Given a root with `ready` and `running` files and logs from a delivered initiative
  - When the cleanup runs and a new chart of pending steps replaces the old one
  - Then `initiative-status.mjs` prints `merged 0, ready 0, running 0`

## Dependencies
- REQ-002.
