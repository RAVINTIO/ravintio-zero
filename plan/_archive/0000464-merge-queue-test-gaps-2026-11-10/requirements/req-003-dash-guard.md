---
title: "Requirement: REQ-003 - dash guard"
summary: "run refuses a head or base name that starts with a dash before any git call uses it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - dash guard

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000464-merge-queue-test-gaps
**Source:** US-003
**Priority:** should-have

## User Story

As a maintainer, I want a branch name that starts with a dash refused, so that it never reaches `git` as an option.

## Functional Requirements
- `cmdRun` checks `headRefName` and `baseRefName` right after `gh pr view` returns them.
- A name that starts with `-` throws a `Stop` that names the field and the value.
- The check runs before the first `git` call that uses either name.

## Acceptance Criteria
- [ ] AC-1: dash head refused
  - Given a PR whose `headRefName` starts with a dash
  - When `run` runs
  - Then it exits 1 with a `merge-queue:` error that names the head, and no `git fetch` runs
- [ ] AC-2: dash base refused
  - Given a PR whose `baseRefName` starts with a dash
  - When `run` runs
  - Then it exits 1 with a `merge-queue:` error that names the base, and no `git fetch` runs
- [ ] AC-3: normal names pass
  - Given a PR with ordinary names
  - When `run` runs
  - Then the dash check adds no error

## Dependencies
- none
