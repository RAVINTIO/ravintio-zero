---
title: "Requirement: REQ-002 - Step records and carries on"
summary: "A step session never stops on a pending migration. It runs a migration that has a row and logs the rest."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Step records and carries on

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Source:** US-002
**Priority:** must-have

## User Story

As the human, I want a step session to record a pending migration and carry on, so that the driver never waits for me.

## Functional Requirements
- Check 1 of resume detection keeps its old line and adds a step-session rule.
- A step session with a `Migration:` row for the migration runs `ravintio-migrator` at once. The row's answer stands in for the human's reply.
- A step session with no row writes `Migration pending: {id}` in its build log and carries on.
- A step session never asks the human about a pending migration.
- `ravintio-migrator` uses a row's answer in place of the human's batch reply.
- The I-C Run rules in the roadmap standards state the same rule.

## Acceptance Criteria
- [ ] AC-1: Row runs the migration
  - Given a step session with a `Migration:` row for pending migration 0010
  - When resume detection reports `pending migration: 0010`
  - Then the step runs `ravintio-migrator` with the row's answer and asks no question
- [ ] AC-2: No row logs and continues
  - Given a step session with no row for a pending migration
  - When resume detection reports it
  - Then the step logs `Migration pending: {id}` in the build log and carries on

## Dependencies
- REQ-001 defines the row.
