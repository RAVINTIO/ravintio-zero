---
title: "Requirement: REQ-001 - Duplicate id check"
summary: "backlog-index.mjs --check exits 1 and names the id when two entry folders share it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Duplicate id check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000552-duplicate-backlog-ids
**Version:** 0.139.0
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I want `backlog-index.mjs --check` to exit 1 when two entry folders share an id, so that CI fails on the next duplicate.

## Functional Requirements
- `--check` exits 1 when two or more entry folders under `plan/backlog/` share a seven-digit id.
- It prints one `check: duplicate backlog id {id}: {folder}, {folder}` line on stderr for each duplicated id.
- It runs the duplicate check before the index comparison, so a duplicate reports even when the index is current.
- The generate mode and `--review` ignore duplicates, because the merge queue runs the generate mode before it renumbers.

## Acceptance Criteria
- [ ] AC-1: --check fails on a duplicate id
  - Given two entry folders that share one id and a current index
  - When `backlog-index.mjs --check` runs
  - Then it exits 1 and stderr names the id and both folders
- [ ] AC-2: unique ids still pass
  - Given entry folders with unique ids and a current index
  - When `backlog-index.mjs --check` runs
  - Then it exits 0
- [ ] AC-3: the generate mode still writes the index
  - Given two entry folders that share one id
  - When `backlog-index.mjs` runs with no flag
  - Then it exits 0 and writes the index

## Dependencies
- None
