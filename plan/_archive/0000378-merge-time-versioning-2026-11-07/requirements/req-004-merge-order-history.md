---
title: "Requirement: REQ-004 - Merge-order history"
summary: "The reshape and the history check follow merge order read from the chart Version column."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Merge-order history

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Source:** US-004
**Priority:** must-have

## User Story

As a coordinator, I reshape and check a branch whose steps merged out of chart order, so that delivery passes.

## Functional Requirements

- Both scripts order the steps by `Version` in ascending semver order, which is merge order.
- A step with no `Version` keeps its chart position after the versioned steps.
- If every `Version` is already in chart order, the result equals today's result.

## Acceptance Criteria

- [ ] AC-1: history check accepts merge order
  - Given a branch whose steps merged 2 then 1 with versions 0.58.0 and 0.59.0
  - When `check-initiative-history.mjs` runs
  - Then it exits 0
- [ ] AC-2: reshape follows merge order
  - Given the same branch
  - When `reshape-initiative.mjs` runs
  - Then the new branch holds step 2 then step 1 and its tree equals the old head

## Dependencies

- None
