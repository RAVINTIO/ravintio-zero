---
title: "Requirement: REQ-002 - CI job"
summary: "CI runs the check on every PR into main in both workflow files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - CI job

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I want CI to fail a PR that breaks the rule, so that the rule holds when the agent forgets.

## Functional Requirements
- `.github/workflows/ravintio.yml` and `ravintio-zero/hooks/ravintio.yml` each hold a job `squash-before-main`.
- The job runs when `github.event_name == 'pull_request'` and `github.base_ref == 'main'`.
- The job checks out with `fetch-depth: 0`, sets `permissions: contents: read`, and passes `github.head_ref` through an environment variable.
- The job runs `check-pr-into-main.mjs` and adds no token scope.
- Setup does not overwrite the tracked workflow, so this step edits both files.

## Acceptance Criteria
- [ ] AC-1: both workflows hold the job
  - Given the tracked workflow and the pack copy
  - When a test reads each
  - Then each holds the job with the PR and `main` condition, a full checkout, read-only permission, and the script call
- [ ] AC-2: no inline branch name
  - Given each workflow
  - When a test reads the job
  - Then the head ref reaches the script only through `env` and `contents: write` still appears once

## Dependencies
REQ-001
