---
title: "Requirement: REQ-003 - Ship skill rules"
summary: "The ship skill squashes before main, limits force-push, and waits for CI."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Ship skill rules

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I want the agent to squash a branch to one commit before it asks me to merge, so that `main` gains one titled commit per chore or hotfix.

## Functional Requirements
- `ravintio-zero/skills/ravintio-ship/SKILL.md` gains a section `## PRs into main`.
- Before the agent asks the human to merge a PR into `main` from any branch except `initiative/*`, the branch holds one commit on top of `origin/main`.
- The commit title follows `commit-standards.md` and names the PR number. The body lists the squashed commit titles.
- For a `chore/*` branch, the agent squashes in place and pushes with `git push --force-with-lease`.
- For a `hotfix/*` branch with more than one commit, the agent builds one squashed commit on a new branch cut from `origin/main`, raises a replacement PR, and closes the old PR with a link. It never force-pushes.
- The agent never force-pushes `main`, `initiative/*`, `feat/*`, or `hotfix/*`.
- The agent waits for CI to pass on the single-commit head before it asks the human to merge.
- Hard Limit 5 points to the section.

## Acceptance Criteria
- [ ] AC-1: force-push limit
  - Given the ship skill
  - When a test reads `## PRs into main`
  - Then `--force-with-lease` appears only with `chore/*` and the text names the replacement PR for `hotfix/*`
- [ ] AC-2: squash and wait
  - Given the ship skill
  - When a test reads the section
  - Then it names the single commit on `origin/main`, the title rule, and the wait for green CI before the merge request
- [ ] AC-3: size
  - Given all `SKILL.md` files
  - When a test counts lines
  - Then the total stays at or below 1720

## Dependencies
none
