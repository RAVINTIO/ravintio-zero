---
title: "Requirement: REQ-002 - Refuse a live or unreadable lock"
summary: "The driver keeps its refusal when it cannot prove the lock dead."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Refuse a live or unreadable lock

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want the driver to refuse when the lock names a running process, so that two drivers never run at once.

## Functional Requirements
- If the lock names a process that runs, the driver stops with the existing `exists, another driver may be running` line.
- If the lock holds anything but a decimal pid, the driver stops with the same line.
- If the lock is a symlink, the driver stops with the same line.
- In each case the driver leaves the lock file as it found it.

## Acceptance Criteria
- [ ] AC-1: live pid, driver refuses
  - Given the lock holds the pid of a running process
  - When the driver starts
  - Then the driver stops with the existing refusal and leaves the lock unchanged
- [ ] AC-2: unreadable lock, driver refuses
  - Given the lock holds text that is not a pid, or is a symlink
  - When the driver starts
  - Then the driver stops with the existing refusal and leaves the lock unchanged

## Dependencies
- REQ-001 shares the same code path.
