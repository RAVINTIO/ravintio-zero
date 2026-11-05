---
title: "Requirement: REQ-003 - History shape check"
summary: "The history script matches each step title and enforces one commit per step plus at most one chore commit."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - History shape check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Source:** US-003
**Priority:** must-have

## User Story

As a reviewer, I run `check-initiative-history.mjs` and it fails any commit that is not a charted step in order or the one chore commit, so that stray commits fail CI.

## Functional Requirements
- The script reads the `## Steps` table of the chart: the `--chart` path, else `plan/current-initiative/initiative.md`, else the archived `plan/_archive/{id}-*-initiative-*/initiative.md`, where `{id}` is the 7 digits after `initiative/` in `--head`.
- The first-parent commits from the merge base, oldest first, must be the N step titles in chart order. Each title is `{7-digit feature id}: {Title} (#{n})`, compared exactly.
- After the steps, at most one commit is allowed. Its subject is `{initiative id}: Initiative admin (#{n})`.
- The script exits 1 and prints the short hash and subject of each failing commit, and names a missing `Title` column or chart.
- The script builds no regular expression from a title.

## Acceptance Criteria
- [ ] AC-1: a valid history passes
  - Given a fixture with N titled steps in order and one chore commit
  - When the script runs
  - Then it exits 0
- [ ] AC-2: a mistitled step fails
  - Given a fixture where one step subject differs from its `Title`
  - When the script runs
  - Then it exits 1 and prints that commit
- [ ] AC-3: an extra commit fails
  - Given a fixture with a commit between two steps
  - When the script runs
  - Then it exits 1 and prints that commit

## Dependencies
- REQ-002 defines the `Title` column.
