---
title: "Requirement: REQ-004 - merge-guard is pinned"
summary: "A test shows merge-guard allows exactly what it allows today."
status: "active"
version: "0.44.0"
---
# Requirement: REQ-004 - merge-guard is pinned

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Source:** US-004
**Priority:** must-have

## User Story

As a security reviewer, I want a test that pins `merge-guard`, so that the change widens no hook.

## Functional Requirements

- `merge-guard.mjs` is unchanged by this step.
- A test runs a coordinator PR squash into `initiative/*` and a set of blocked forms, and checks the current exit codes.

## Acceptance Criteria

- [ ] AC-1: a coordinator squash passes
  - Given a PR whose base is `initiative/x`
  - When the guard sees `gh pr merge 12 --squash --delete-branch`
  - Then it exits 0
- [ ] AC-2: the blocked forms stay blocked
  - Given the same guard
  - When it sees a squash into `main`, `--merge`, `--admin`, or a command substitution
  - Then it exits 2
- [ ] AC-3: the hook is unchanged
  - Given the git diff against the initiative branch
  - When a test lists changes under `hooks/enforcement/merge-guard.mjs`
  - Then the list is empty

## Dependencies

none
