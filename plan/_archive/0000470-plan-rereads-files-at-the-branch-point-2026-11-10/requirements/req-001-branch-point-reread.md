---
title: "Requirement: REQ-001 - branch-point reread"
summary: "The plan skill rereads each file a unit edits at the branch point, records the commit, and repeats the reread if the target branch moves."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - branch-point reread

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000470-plan-rereads-files-at-the-branch-point
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I reread each file my plan edits at the branch point. I note the commit, so the plan never rests on stale text.

## Functional Requirements
- `ravintio-plan/SKILL.md` holds a `## Branch-point reread` section with the rule anchor `plan-branch-point-reread`. It runs after the Test impact scan and before the execution plan.
- The section tells the plan to run `git fetch origin`. It then reads each file a unit edits from the tip of the PR base branch, with `git show origin/{base}:{path}`.
- The section tells the plan to record each file and the last commit that changed it, from `git log -1 --format=%h origin/{base} -- {path}`. A new file records `new`.
- The section tells the plan to repeat the reread before the plan gate if `origin/{base}` has moved.
- `execution-plan.template.md` holds a `## Branch-point reads` table with the columns File, Commit read, and Unit.

## Acceptance Criteria
- [ ] AC-1: skill step
  - Given the plan skill
  - When the test reads its `Branch-point reread` section
  - Then the section names `git fetch`, `origin/`, the commit note, and the `plan-branch-point-reread` anchor
- [ ] AC-2: template table
  - Given the execution plan template
  - When the test reads its `Branch-point reads` section
  - Then the section holds the columns File, Commit read, and Unit
- [ ] AC-3: moved target
  - Given the plan skill
  - When the test reads the section
  - Then it tells the plan to repeat the reread if the target branch moves before the gate

## Dependencies
- none
