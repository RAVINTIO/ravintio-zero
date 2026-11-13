---
title: "Requirement: REQ-001 - exact-path skip"
summary: "The brand guard skips its two allowlist files by exact path, the allowlist holds no self-entry, and the hook and CI share the rule."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - exact-path skip

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000460-narrow-brand-guard-self-entry
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer of the pack, I want the guard to skip its allowlist files by exact path. Then no allowlist pattern can widen the guard.

## Functional Requirements
- `brand-guard.sh` defines `brand_guard_skips_path <path>`. It returns 0 only for `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt`. It compares the whole string and uses no pattern.
- `brand_guard_main` skips a path for which the function returns 0, before it checks the path name and the lines.
- `test-0000160-req-006-brand-guard.sh` drops the same paths from its scope by calling the function.
- The self-entry row and its comment leave `brand-guard-allowlist.txt`. The row for the guard's own test stays.
- `test-0000397-req-005-guards-cover-both.sh` compares the allowlist with the base entries minus the removed self-entry.

## Acceptance Criteria
- [ ] AC-1: exact paths only
  - Given a scratch repo whose two allowlist files and several look-alike files name the retired word
  - When the guard reads all of their paths
  - Then it reports each look-alike, and it reports neither allowlist path
  - And the look-alikes include `brand-guard-allowlist.txt.bak`, a copy in another folder, and a path with a prefix
- [ ] AC-2: no self-entry
  - Given the shipped allowlist
  - When the test reads its rows
  - Then no row has a path regex that matches an allowlist path, and the CI brand test passes
- [ ] AC-3: one rule
  - Given the guard script, the CI test, and `pre-push`
  - When the test reads their sources
  - Then the script, its main function, and the CI test all call `brand_guard_skips_path`

## Dependencies
- none
