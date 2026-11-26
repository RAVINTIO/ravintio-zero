---
title: "Scope - Tests share a repo-root helper for both pack trees"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Tests share a repo-root helper for both pack trees

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000572-tests-share-a-repo-root-helper
**Version:** 0.147.0

## In Scope

- `repo_root`, `pack_tree_src`, and `pack_tree_installed` in `helpers/assert.sh`.
- A paragraph in `standards/testing-standards.md`.
- The step-clock and handoff-text suites call the helper.
- One new suite for the helpers.

## Out of Scope

- Moving every existing suite to the helper.
- A PowerShell twin of the helper.
- Removing the two-tree layout.

## Deferred

- Moving the remaining suites to the helper. It blocks nothing and can follow any step.
