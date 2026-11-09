---
title: "Requirement: req-002 - Pinned actions and supply-chain workflows"
summary: "Every action is pinned by SHA, and dependency review and Scorecard workflows exist."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - Pinned actions and supply-chain workflows

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I have every action pinned by SHA plus dependency review and Scorecard workflows, so that a moved tag cannot change CI.

## Functional Requirements

- Every `uses:` line in `.github/workflows/` and `ravintio-zero/hooks/ravintio.yml` names a 40-character commit SHA, with the tag in a trailing comment.
- `.github/workflows/dependency-review.yml` runs `actions/dependency-review-action` on pull requests.
- `.github/workflows/scorecard.yml` runs `ossf/scorecard-action` on a schedule and on pushes to `main`.
- The repo's own workflows keep `permissions: contents: read` at the top level.

## Acceptance Criteria

- [ ] AC-1: No floating tag
  - Given the workflow files and the consumer template
  - When the suite lists each `uses:` line
  - Then every third-party reference ends in a 40-character SHA
- [ ] AC-2: New workflows exist
  - Given `.github/workflows/`
  - When the suite parses the two new files
  - Then each runs its named action and each job carries the guard or the exempt marker

## Dependencies

- None
