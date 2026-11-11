---
title: "Requirement: REQ-002 - Step reads mergeability before the CI poll"
summary: "The roadmap standards and the ship skill tell a step to read mergeable before it polls for checks."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Step reads mergeability before the CI poll

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000483-mergeability-before-ci-wait
**Source:** US-002
**Priority:** must-have

## User Story

As a step session, I merge the initiative branch into a conflicting PR before I wait for CI, so that checks register.

## Functional Requirements
- I-D Advance in `roadmap-standards.md` has a step before the first CI poll. The step runs `gh pr view {n} --json mergeable`. If the value is `CONFLICTING`, it merges `origin/initiative/{id}-{slug}` into the branch, resolves shared files with `shared-files.mjs`, pushes, and reads again.
- A conflict in any other file stops the step with `I-D Advance: Blocked: PR #{n} conflicts with the initiative branch.`
- The merge queue section lists the new stop.
- The ship skill names the same read in its initiative step paragraph.

## Acceptance Criteria
- [ ] AC-1: standards text
  - Given `roadmap-standards.md`
  - When a reader looks at I-D Advance
  - Then it names `gh pr view {n} --json mergeable` before the first `gh pr checks` poll
- [ ] AC-2: ship skill text
  - Given the ship skill
  - When a reader looks at its initiative step paragraph
  - Then it names the `mergeable` read before the CI wait

## Dependencies
- none
