---
title: "Requirement: req-004 - Brand guard before push"
summary: "pre-push runs the brand guard with the allowlist that CI uses."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - Brand guard before push

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Source:** US-004
**Priority:** must-have

## User Story

As a pack contributor, I have `pre-push` run the brand guard with CI's allowlist, so that the old product name fails before CI.

## Functional Requirements

- The allowlist and the excluded prefixes live in `ravintio-zero/tests/brand-guard-allowlist.txt`.
- `ravintio-zero/scripts/brand-guard.sh` reads that file, checks the changed files, and prints `path:line` for each hit.
- `ravintio-zero/hooks/pre-push` runs the script on the files the push changes and exits 1 on a hit.
- The check runs only when `product.yml` declares the id `ravintio-zero`.
- `test-0000160-req-006-brand-guard.sh` reads the same file.

## Acceptance Criteria

- [ ] AC-1: Old name fails
  - Given a scratch repo whose branch adds a line with the old name
  - When `pre-push` runs
  - Then it exits 1 and prints the file and line
- [ ] AC-2: Clean push passes
  - Given a branch with no old name
  - When `pre-push` runs
  - Then it exits 0
- [ ] AC-3: One allowlist
  - Given the hook, the script, and the CI test
  - When the suite reads their sources
  - Then each names `brand-guard-allowlist.txt` and none holds an inline allowlist

## Dependencies

- None
