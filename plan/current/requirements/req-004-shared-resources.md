---
title: "Requirement: REQ-004 - Shared resources in the concurrency plan"
summary: "The concurrency plan names shared runtime resources, and check 8 treats them like write targets."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Shared resources in the concurrency plan

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Source:** US-004
**Priority:** must-have

## User Story

As a planner, I want the concurrency plan to name shared runtime resources, so that two units with one port or build folder never share a batch.

## Functional Requirements
- `execution-plan.template.md` adds a `Shared resources` column to the Concurrency plan table. It lists build output, ports, and lock files.
- Check 8 reads the column when it exists. A plan without the column still passes, so older plans stay valid.
- Two units in one batch that name the same shared resource produce a finding, as two units that write one path do.

## Acceptance Criteria
- [ ] AC-1: Shared resource conflict fails
  - Given two units in batch 1 that both list `port:4321` under Shared resources
  - When `consistency-check.mjs` runs
  - Then it exits 1 and names both units and the resource
- [ ] AC-2: Older plan still passes
  - Given a plan with no Shared resources column
  - When `consistency-check.mjs` runs
  - Then check 8 reports no finding for that reason

## Dependencies
- None
