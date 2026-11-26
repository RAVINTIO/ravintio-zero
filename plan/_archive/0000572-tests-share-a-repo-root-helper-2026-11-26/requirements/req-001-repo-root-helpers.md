---
title: "Requirement: REQ-001 - Repo-root helpers"
summary: "assert.sh offers repo_root, pack_tree_src, and pack_tree_installed, which work from both pack trees."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Repo-root helpers

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000572-tests-share-a-repo-root-helper
**Version:** 0.147.0
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As a test author, I call `repo_root` and the tree helpers and get the same paths from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/`.

## Functional Requirements
- `helpers/assert.sh` defines `repo_root [dir]`. It walks up from `dir` and prints the first folder that holds `product.yml`.
- Without an argument, `repo_root` starts at the folder of the calling script.
- If no folder holds `product.yml`, `repo_root` prints nothing and returns 1.
- `pack_tree_src [dir]` prints `{root}/src/ravintio-zero`. `pack_tree_installed [dir]` prints `{root}/ravintio-zero`.
- Sourcing `assert.sh` prints nothing new and changes no variable that a suite reads today.

## Acceptance Criteria
- [ ] AC-1: the root is the same from both trees
  - Given a start folder in `src/ravintio-zero/tests/` and one in `ravintio-zero/tests/`
  - When `repo_root` runs for each
  - Then both print the folder that holds `product.yml`
- [ ] AC-2: the tree helpers return both trees
  - Given the repo root
  - When `pack_tree_src` and `pack_tree_installed` run
  - Then they print `src/ravintio-zero` and `ravintio-zero` under the root
- [ ] AC-3: a missing root fails loudly
  - Given a scratch folder with no `product.yml` above it
  - When `repo_root` runs for it
  - Then it prints nothing and returns 1

## Dependencies
- None
