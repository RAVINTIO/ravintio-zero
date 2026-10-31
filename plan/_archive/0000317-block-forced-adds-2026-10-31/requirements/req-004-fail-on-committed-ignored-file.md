---
title: "Requirement: REQ-004 - fail on a committed ignored file"
summary: "Ship and CI fail when a committed file matches an ignore rule."
status: "active"
version: "0.43.0"
---
# Requirement: REQ-004 - fail on a committed ignored file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I want ship and CI to fail when a committed file matches an ignore rule, so that a forced add never reaches `main`.

## Functional Requirements

- The ship skill runs `git ls-files -ci --exclude-standard` and stops if it lists a file.
- The pack workflow `ravintio-zero/hooks/ravintio.yml` and the tracked `.github/workflows/ravintio.yml` run the same command on pull requests and fail if it lists a file.
- The error names each listed file.

## Acceptance Criteria

- [ ] AC-1: check fails on an ignored file
  - Given a branch with a committed file that `.gitignore` matches
  - When the check command runs
  - Then it exits non-zero and names the file
- [ ] AC-2: check passes on a clean branch
  - Given a branch with no such file
  - When the check command runs
  - Then it exits 0
- [ ] AC-3: both workflows and ship carry the check
  - Given the two workflow files and the ship skill
  - When a test searches them
  - Then each holds `ls-files -ci --exclude-standard`

## Dependencies

none
