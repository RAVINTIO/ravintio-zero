---
title: "Requirement: REQ-002 - CI history job and push trigger"
summary: "CI runs the script and the push trigger."
status: "active"
version: "0.45.0"
---
# Requirement: REQ-002 - CI history job and push trigger

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Source:** US-002
**Priority:** must-have

## User Story

As a reviewer, I see CI run the script on each PR from `initiative/*` to `main`, and I see CI run on each push to `initiative/**`, so that a bad history fails the PR and a direct push runs the suite.

## Functional Requirements

- Both workflow copies add `'initiative/**'` to the `push` trigger.
- Both copies hold an `initiative-history` job that runs only on a pull request whose base is `main` and whose head starts with `initiative/`. It runs the script.
- `release-tag` runs only on a push to `main` or `master`.
- The jobs keep `permissions: contents: read`, except `release-tag`.

## Acceptance Criteria

- [ ] AC-1: the push trigger
  - Given each workflow copy
  - When a test parses it
  - Then the push branches are `main`, `master`, and `initiative/**`
- [ ] AC-2: release-tag stays on the default branches
  - Given each workflow copy
  - When a test reads the `release-tag` job
  - Then its `if` names a push and the ref `main` or `master`
- [ ] AC-3: the history job
  - Given each workflow copy
  - When a test reads the `initiative-history` job
  - Then it runs on a pull request into `main` from `initiative/` and runs the script

## Dependencies

REQ-001
