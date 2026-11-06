---
title: "Requirement: REQ-001 - Id reservation refuses on the initiative branch"
summary: "reserve-id.mjs --commit exits 1 on initiative/* and commits nothing."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Id reservation refuses on the initiative branch

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Source:** US-004
**Priority:** must-have

## User Story

As a coordinator, I run `reserve-id.mjs --commit` and it refuses on `initiative/*` and names the `feat/` route, so that no direct commit lands.

## Functional Requirements
- With `--commit`, the script reads the current branch with `git rev-parse --abbrev-ref HEAD` through `execFileSync` in the counter file's folder.
- If the branch name starts with `initiative/`, the script prints one line to stderr, exits 1, and changes neither the counter file nor the git history.
- The message names the `feat/` route: reserve the id on a `feat/` branch so the counter commit rides in a coordinator PR.
- The check runs before the reservation, so the refusal leaves no gap in the id sequence.
- A run without `--commit`, and a run with `--commit` on any other branch, behaves as before.

## Acceptance Criteria
- [ ] AC-1: refusal on `initiative/*`
  - Given a scratch repo on branch `initiative/0000999-demo` with a counter file
  - When `reserve-id.mjs --commit` runs
  - Then it exits non-zero, the counter file is unchanged, and the repo has no new commit
- [ ] AC-2: message names the route
  - Given the same repo
  - When the script refuses
  - Then stderr names `feat/`
- [ ] AC-3: other branches keep working
  - Given a scratch repo on branch `feat/demo`
  - When `reserve-id.mjs --commit` runs
  - Then it commits the counter file alone
  - And a run without `--commit` on `initiative/0000999-demo` still reserves an id

## Dependencies
- None.
