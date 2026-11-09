---
title: "Requirement: REQ-001 - queue waits for GitHub"
summary: "The merge queue waits for the pushed head, CI, and mergeability before it merges, and retries a transient merge failure once."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - queue waits for GitHub

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000411-queue-waits
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator of an initiative, I see the queue merge a green, clean step PR without a "not mergeable" stop, so that steps merge with no manual retry.

## Functional Requirements
- After each push, `cmdRun` polls `gh pr view {pr} --json headRefOid,mergeable,mergeStateStatus` until `headRefOid` equals the pushed commit. Then it runs `gh pr checks {pr} --watch --fail-fast`.
- After the version commit, the queue waits for the head and CI the same way.
- Before `gh pr merge`, the queue polls until `mergeable` is `MERGEABLE` and `mergeStateStatus` is `CLEAN`, `HAS_HOOKS`, or `UNSTABLE`.
- If `gh pr merge` fails with "not mergeable" or "Base branch was modified", the queue waits for mergeability again and retries once.
- `RAVINTIO_QUEUE_POLL_MS` (default 5000) and `RAVINTIO_QUEUE_WAIT_MS` (default 1200000) set the poll interval and the limit. Past the limit, the queue stops with `timed out waiting for PR #{pr}: {what}`.

## Acceptance Criteria
- [ ] AC-1: a slow GitHub
  - Given a fake GitHub that reports the old head for two answers and `UNKNOWN` mergeability for two more
  - When the queue runs
  - Then it merges the PR and exits 0
- [ ] AC-2: no early merge
  - Given the same fake
  - When the queue runs
  - Then no `pr merge` call comes before a `MERGEABLE` answer, and a first merge failure of "not mergeable" gets one retry
- [ ] AC-3: the existing suites pass
  - Given the 0000378 and 0000405 queue suites with an updated fake `gh`
  - When they run
  - Then each one exits 0

## Dependencies
- none
