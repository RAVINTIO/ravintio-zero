---
title: "Requirement: REQ-004 - Allowed branch prefixes"
summary: "The standards and the ruleset doc name the three prefixes that may target main."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Allowed branch prefixes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I want only `initiative/*`, `chore/*`, and `hotfix/*` branches to target `main`, so that a feature never skips an initiative.

## Functional Requirements
- `ravintio-zero/standards/roadmap-standards.md` `## Merge carve-out` names the three prefixes and says every `feat/*` branch targets an initiative branch.
- `ravintio-zero/docs/main-ruleset.md` names the same prefixes and the CI job that enforces them.
- Both texts say the agent never merges a PR into `main`.

## Acceptance Criteria
- [ ] AC-1: prefixes named
  - Given the standards and the ruleset doc
  - When a test reads each
  - Then each names `initiative/*`, `chore/*`, and `hotfix/*` and says a `feat/*` branch never targets `main`
- [ ] AC-2: ruleset doc names the job
  - Given `docs/main-ruleset.md`
  - When a test reads it
  - Then it names `squash-before-main`

## Dependencies
REQ-002
