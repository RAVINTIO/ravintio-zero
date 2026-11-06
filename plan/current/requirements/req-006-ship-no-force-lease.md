---
title: "Requirement: REQ-006 - Ship allows no force push with a lease"
summary: "The ship skill drops the chore force-with-lease and uses the replacement branch route for chore."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-006 - Ship allows no force push with a lease

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I read one route for a multi-commit `chore/*` PR, the replacement branch.

## Functional Requirements
- `## PRs into main` in the ship skill does not contain `--force-with-lease`.
- A `chore/*` or `hotfix/*` PR with more than one commit uses the replacement route: cut a new branch from `origin/main`, build one squashed commit, raise a replacement PR, close the old PR with a link, and delete the old branch.
- The section still says you never force-push `main`, `initiative/*`, `feat/*`, `hotfix/*`, or `chore/*`.
- The existing test that reads the lease rule changes to match.

## Acceptance Criteria
- [ ] AC-1: no lease
  - Given the section
  - When a test searches it for `--force-with-lease`
  - Then it finds none
- [ ] AC-2: route and bans
  - Given the section
  - When a test reads it
  - Then it names `chore/*` and `hotfix/*` in the replacement route and in the never-force-push line

## Dependencies
- None.
