---
title: "Requirement: REQ-003 - tracked ignores for driver paths"
summary: "The tracked gitignore lists the driver paths."
status: "active"
version: "0.43.0"
---
# Requirement: REQ-003 - tracked ignores for driver paths

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Source:** US-003
**Priority:** must-have

## User Story

As a developer with a fresh clone, I want the driver paths in the tracked `.gitignore`, so that git and CI treat them as ignored.

## Functional Requirements

- `.gitignore` lists `plan/.initiative-logs/`, `plan/.initiative-queue/`, and `plan/.initiative-runner.lock`.
- A fresh clone with no `.git/info/exclude` entries reports each path as ignored.

## Acceptance Criteria

- [ ] AC-1: driver paths ignored
  - Given a clone with an empty `.git/info/exclude`
  - When `git check-ignore` reads each driver path
  - Then each path is ignored by `.gitignore`

## Dependencies

none
