---
title: "Requirement: REQ-001 - history script"
summary: "The history script and its title rule."
status: "active"
version: "0.45.0"
---
# Requirement: REQ-001 - history script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I run a script that lists the first-parent commits of an `initiative/*` branch and fails on an untitled one, so that a direct commit shows before the PR to `main`.

## Functional Requirements

- `ravintio-zero/scripts/check-initiative-history.mjs` takes `--root`, `--base`, and `--head`. The defaults are the current directory, `origin/main`, and `HEAD`.
- It lists `git log --first-parent` from the merge base of the base and head to the head.
- A subject passes if it matches `{7-digit id}-{slug}: {summary} (#{n})`. The slug is kebab-case.
- It exits 1 and prints the short hash and subject of each failing commit. It exits 0 otherwise.
- It exits 1 with a clear message if a ref is missing. It has no exception list.

## Acceptance Criteria

- [ ] AC-1: titled squashes pass
  - Given a branch whose first-parent commits all carry titled subjects
  - When the script runs
  - Then it exits 0
- [ ] AC-2: a direct commit fails and is named
  - Given a branch with one first-parent commit titled `fix stuff`
  - When the script runs
  - Then it exits 1 and prints that commit's short hash and subject
- [ ] AC-3: edge cases
  - Given a branch with no commits since its base, or a missing base ref
  - When the script runs
  - Then the empty branch exits 0 and the missing ref exits 1 with a message

## Dependencies

none
