---
title: "Requirement: REQ-002 - workflow shards"
summary: "CI runs 4 bash shards and 4 Windows PowerShell 5.1 shards behind summary jobs that keep the required check names, and drops the Windows pwsh job."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - workflow shards

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000409-ci-shards
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator of an initiative, I want CI on a step PR to finish in about 5 minutes, so that the queue merges steps sooner.

## Functional Requirements
- A `bash-suites-shard` job runs `run-tests.sh` on `ubuntu-latest` with `RAVINTIO_REQUIRE_PWSH: "1"`, as a matrix of shards 1 to 4.
- A `windows-powershell-shard` job runs `run-tests.ps1` under Windows PowerShell 5.1 on `windows-latest`, as a matrix of shards 1 to 4.
- Both shard jobs keep `fail-fast: false`, `contents: read`, the pinned checkout, and `persist-credentials: false`.
- A `bash-suites` job and a job named `windows-powershell (powershell)` each need their shard job. They run `if: always()` and fail unless every shard succeeded.
- No job runs the suites under pwsh on Windows.

## Acceptance Criteria
- [ ] AC-1: shard jobs
  - Given `.github/workflows/ravintio.yml`
  - When a test reads the shard jobs
  - Then the bash matrix has 4 shards and the Windows matrix has 4, each with read-only contents and a pinned checkout
- [ ] AC-2: summary jobs keep the names
  - Given the same workflow
  - When a test reads the summary jobs
  - Then their check names are `bash-suites` and `windows-powershell (powershell)`, and each fails unless its shards succeeded
- [ ] AC-3: CI time
  - Given this PR
  - When CI runs
  - Then the slowest required check finishes in 7 minutes or less

## Dependencies
- REQ-001
