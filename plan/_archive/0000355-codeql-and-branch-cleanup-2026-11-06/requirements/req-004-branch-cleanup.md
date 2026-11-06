---
title: "Requirement: REQ-004 - branch cleanup job"
summary: "CI deletes a merged PR's head branch."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - branch cleanup job

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Source:** US-004
**Priority:** must-have

## User Story

As a developer, I find a merged PR's head branch deleted by CI, so that I change no repo setting.

## Functional Requirements
- Both `ravintio.yml` files hold a `cleanup-branch` job. The workflow trigger lists `closed` in the pull request types.
- The job runs only when the PR is merged and its head repo equals the base repo.
- The job holds `contents: write`. The top-level permission and every other job except `release-tag` stay at read.
- The job reads the head ref from `env`, refuses `main` and `master`, and checks the name against an allowed character pattern.
- The job exits 0 if the branch is already gone.
- Every pull request job carries `github.event.action != 'closed'` in its `if`.

## Acceptance Criteria
- [ ] AC-1: scoped write
  - Given each workflow file
  - When a test reads the permissions
  - Then only `cleanup-branch` and `release-tag` hold `contents: write`
- [ ] AC-2: protected and fork heads skipped
  - Given the job text
  - When a test reads it
  - Then it checks the fork condition and refuses `main` and `master`
- [ ] AC-3: other jobs skip closed
  - Given each pull request job
  - When a test reads its `if`
  - Then it holds `github.event.action != 'closed'`

## Dependencies
- REQ-003 for the marker comment.
- After the step's PR merges, its head branch is gone from `origin` (CI-checked criterion).

## Input Validation

- [ ] Input source: the PR head ref, from the event payload
- [ ] Allowed character pattern: `[A-Za-z0-9._/-]`, anything else makes the job exit 0 with no delete
- [ ] maximum length: 200 characters, a longer name makes the job exit 0 with no delete
- [ ] Failure behaviour: log the reason and exit 0
- [ ] Logging policy: log the validated name only
