---
title: "Requirement: REQ-002 - Standard and adoption"
summary: "The testing standards name the helper and the both-trees rule, and two suites call the helper."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Standard and adoption

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000572-tests-share-a-repo-root-helper
**Version:** 0.147.0
**Source:** US-003
**Priority:** must-have

## User Story

As a test author, I read in the testing standards that a new suite calls `repo_root`. It also runs from both trees before it counts as green.

## Functional Requirements
- `standards/testing-standards.md` names `repo_root`, `pack_tree_src`, and `pack_tree_installed`.
- The standard says a new suite runs from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/` before it counts as green.
- `test-0000534-req-001-003-step-clock.sh` and `test-0000493-req-004-handoff-text.sh` call `repo_root` in place of their own root path.

## Acceptance Criteria
- [ ] AC-1: the standard names the helpers and the rule
  - Given the testing standards
  - When a test reads them
  - Then they name the three functions and say a new suite runs from both trees before it counts as green
- [ ] AC-2: the two suites use the helper
  - Given the two suites named above
  - When a test reads them
  - Then each calls `repo_root` and builds no root from `../..`
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When `sync-installed.mjs --check` runs
  - Then it exits 0

## Dependencies
- REQ-001
