---
title: "Requirement: REQ-005 - ruleset doc"
summary: "The ruleset doc."
status: "active"
version: "0.45.0"
---
# Requirement: REQ-005 - ruleset doc

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I find the repository ruleset in the setup docs, so that I can allow only the merge commit method on `main`.

## Functional Requirements

- A doc in the pack names the GitHub ruleset on `main` whose pull request rule allows only the merge commit method.
- The doc says squash stays allowed on `initiative/**` and that the human applies the ruleset.

## Acceptance Criteria

- [ ] AC-1: the doc names the setting
  - Given the pack docs
  - When a test searches them
  - Then one names the ruleset, the merge commit method, `main`, and `initiative/**`

## Dependencies

none
