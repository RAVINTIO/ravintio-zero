---
title: "Requirement: REQ-004 - main merge check"
summary: "CI flags a squash of an initiative PR on main."
status: "active"
version: "0.45.0"
---
# Requirement: REQ-004 - main merge check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I see CI fail a push to `main` whose newest commit came from an initiative PR and has one parent, so that a squash is flagged at once.

## Functional Requirements

- `ravintio-zero/scripts/check-main-merge.mjs` reads the newest commit of `HEAD` (or `--ref`) and takes `--root`.
- It treats a commit as an initiative PR if its subject reads `Merge pull request #n from {owner}/initiative/...`, or it has one parent and its subject or a body bullet matches the titled form with a `(#n)`.
- It exits 1 with a message when such a commit has one parent. It exits 0 for a two-parent commit and for any other commit.
- Both workflow copies hold a `main-merge-check` job that runs on a push to `main`.

## Acceptance Criteria

- [ ] AC-1: a squash fails
  - Given a one-parent commit titled `0000312-guards-history-and-test-noise: deliver (#80)`
  - When the script runs
  - Then it exits 1
- [ ] AC-2: a merge commit passes
  - Given a two-parent commit whose subject names `initiative/`
  - When the script runs
  - Then it exits 0
- [ ] AC-3: the job
  - Given each workflow copy
  - When a test reads the `main-merge-check` job
  - Then it runs on a push to `main` and runs the script

## Dependencies

none
