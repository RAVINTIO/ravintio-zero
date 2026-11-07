---
title: "Requirement: REQ-003 - Merge queue"
summary: "A serial queue merges one ready step PR at a time and sets its version at merge."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Merge queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Source:** US-003
**Priority:** must-have

## User Story

As a coordinator, I merge one ready step PR at a time with its version set at merge, so that versions follow merge order.

## Functional Requirements

- `merge-queue.mjs run --step {n} --pr {k}` takes one step PR through these actions in order: check the title, merge the initiative branch into the PR branch, wait for CI, set the version, check every version file, write the chart row, push, merge, and tag.
- The version is the initiative branch's current version with the step's `Bump` applied.
- The chart row gets the version and the status `merged`.
- The queue appends a row to a `## Merges` table in the chart with step, PR, merge commit, version, and time.
- The queue never force-pushes, and it stops on a red check, a title mismatch, or a version file that differs.
- Each `git` and `gh` call uses an argument array.

## Acceptance Criteria

- [ ] AC-1: reverse chart order gets consecutive versions
  - Given two fixture step PRs where step 2 is ready before step 1
  - When the queue runs step 2, then step 1
  - Then step 2 gets the next version, step 1 gets the one after, and each tag points at its merge commit
- [ ] AC-2: failure stops before the merge
  - Given a PR with a slug in its title, or a version file that differs after the bump
  - When the queue runs
  - Then it exits 1 and merges nothing
- [ ] AC-3: the queue records each merge
  - Given a merged step
  - When the queue ends
  - Then the chart row holds the version and `merged`, and `## Merges` holds one row for the step

## Dependencies

- REQ-001 and REQ-002
