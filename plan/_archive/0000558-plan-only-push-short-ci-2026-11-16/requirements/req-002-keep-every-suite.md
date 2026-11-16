---
title: "Requirement: REQ-002 - keep every suite"
summary: "A push that changes only plan files still runs every job."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - keep every suite

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000558-plan-only-push-short-ci
**Source:** US-002
**Priority:** must-have

## User Story

As a reviewer, I want a push that changes `plan/` to run every suite, so that every check still runs.

## Functional Requirements
- No job gains a `paths` or `paths-ignore` filter.
- No job gains a step condition on the changed files.
- The workflow `on:` block gains no `paths` key.

## Acceptance Criteria
- [ ] AC-1: No path filter
  - Given the workflow file
  - When a reader searches for `paths:` and `paths-ignore:`
  - Then the search finds no match
- [ ] AC-2: Shard jobs keep their guard
  - Given the shard jobs and their summary jobs
  - When a reader reads their `if` lines
  - Then each line names the `pull_request` event and holds no file condition

## Dependencies
- REQ-001.
