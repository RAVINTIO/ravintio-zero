---
title: "Requirement: REQ-001 - Queue stops on a conflict or absent checks"
summary: "The merge queue stops with a named error when the PR conflicts or no check appears in time."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Queue stops on a conflict or absent checks

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000483-mergeability-before-ci-wait
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I see the queue stop on a conflicting PR, so that a run never waits for absent checks.

## Functional Requirements
- While `gh pr checks` lists no check, `waitForChecks` reads `mergeable` with `gh pr view --json mergeable`. If the value is `CONFLICTING`, the queue stops with `PR #{k} conflicts with its base branch, so GitHub runs no checks. Merge the base into the PR branch and rerun.`
- If no check appears within `MQ_NOCHECKS_MS` ms (default 600000), the queue stops with `no CI checks appeared on PR #{k} within {n}s`.
- The queue keeps polling on `UNKNOWN` or a missing value. A `MERGEABLE` PR with passing checks passes as before.

## Acceptance Criteria
- [ ] AC-1: conflicting PR
  - Given a PR that reports `CONFLICTING` and lists no checks
  - When the queue waits for CI
  - Then it exits 1 and names the conflict in its error
- [ ] AC-2: no checks appear
  - Given a `MERGEABLE` PR that lists no checks and `MQ_NOCHECKS_MS` set to 300
  - When the queue waits for CI
  - Then it exits 1 and the error contains `no CI checks appeared`
- [ ] AC-3: normal wait
  - Given a `MERGEABLE` PR whose checks pass after two polls
  - When the queue waits for CI
  - Then it merges and exits 0

## Dependencies
- none
