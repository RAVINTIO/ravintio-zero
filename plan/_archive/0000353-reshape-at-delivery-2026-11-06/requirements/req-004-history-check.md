---
title: "Requirement: REQ-004 - The reshaped branch passes the history check"
summary: "The script runs check-initiative-history.mjs on the new branch."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - The reshaped branch passes the history check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I know the reshaped branch matches the chart before I raise the PR.

## Functional Requirements
- After it writes the branch, the script runs `check-initiative-history.mjs` with `--head` set to the new branch and the same `--base` and `--chart`.
- If the check fails, the script prints its output and exits 1. The new branch stays in place for the coordinator to inspect.
- If the check passes, the script prints its summary line.

## Acceptance Criteria
- [ ] AC-1: check passes
  - Given the happy path fixture
  - When the script finishes
  - Then the check ran on the new branch and exited 0

## Dependencies
- REQ-001.
