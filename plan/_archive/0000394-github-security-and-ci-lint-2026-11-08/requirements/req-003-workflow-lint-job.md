---
title: "Requirement: req-003 - Workflow lint job"
summary: "CI runs actionlint and zizmor on the workflows and fails on any finding."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Workflow lint job

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I have CI run `actionlint` and `zizmor` on the workflows, so that a risky workflow change fails the PR.

## Functional Requirements

- `.github/workflows/ravintio.yml` holds a `workflow-lint` job with the pull request guard.
- The job runs `actionlint` and then `zizmor` over `.github/workflows/`, and fails on any finding.
- Each tool is pinned to a version.
- Every existing finding is fixed, or recorded with an inline ignore and a reason, so the job starts green.

## Acceptance Criteria

- [ ] AC-1: Job runs both tools
  - Given `.github/workflows/ravintio.yml`
  - When the suite parses the `workflow-lint` job
  - Then it runs `actionlint` and `zizmor` against `.github/workflows/`
- [ ] AC-2: Workflows pass the linters
  - Given `actionlint` and `zizmor` on the PATH
  - When the suite runs both on `.github/workflows/`
  - Then both exit 0

## Dependencies

- req-002 (the pins remove the `zizmor` unpinned-uses findings)
