---
title: "Requirement: REQ-001 - git identity isolation"
summary: "The runners hide the developer's git config from each suite, and a commit with no identity fails."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - git identity isolation

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000462-tests-without-git-identity
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer of the pack, I see a suite fail locally when it commits with no identity. Then CI does not find it first.

## Functional Requirements
- `helpers/git-isolation.sh` defines `isolate_git_env`. It writes a temporary global config that sets `user.useConfigOnly = true`. It exports `GIT_CONFIG_GLOBAL` for that file and `GIT_CONFIG_NOSYSTEM=1`. It unsets `GIT_AUTHOR_*`, `GIT_COMMITTER_*`, and `EMAIL`.
- `run-tests.sh` calls `isolate_git_env` before the first suite and removes the temporary file on exit.
- `run-tests.ps1` sets the same variables before the first suite and removes its temporary file on exit.
- Any suite that fails under this isolation sets its own identity in its own git call.
- `README.md` of the tests folder describes the isolation.

## Acceptance Criteria
- [ ] AC-1: no identity
  - Given a scratch repository and the environment that `isolate_git_env` sets
  - When a commit runs with no `-c user.email`
  - Then git refuses the commit
  - And a commit with `-c user.name` and `-c user.email` succeeds
- [ ] AC-2: both runners isolate
  - Given `run-tests.sh` and `run-tests.ps1`
  - When the test reads their sources
  - Then each one sets the isolation before it runs a suite
- [ ] AC-3: the PR #136 defect fails
  - Given a copy of `commit_workspace_pack` without its identity flags
  - When it runs under the isolated environment on a scratch folder
  - Then the commit fails, and the shipped function succeeds

## Dependencies
- none
