---
title: "Execution Plan - CI avoids extra runs on a plan-only push"
summary: "Requirements, test impact, and units for the concurrency block."
status: "active"
version: "0.139.0"
---
# Execution Plan - CI avoids extra runs on a plan-only push

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000558-plan-only-push-short-ci
**Version:** 0.139.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-cancel-superseded-run.md](requirements/req-001-cancel-superseded-run.md) | A newer push cancels the older pull request run. |
| [req-002-keep-every-suite.md](requirements/req-002-keep-every-suite.md) | No job gains a path filter. |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | The group key reads no user-controlled text. | 0 uses of head ref text or PR title in the group | Test greps the group expression |

## API Summary

No API change.

## Data Model Summary

No data model change.

## Component Interactions

No interaction change.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Workflow job or step edit | `test-0000327-req-002-ci-job.sh`, `test-0000409-req-002-workflow-shards.sh`, `test-0000355-req-003-workflow-marker.sh`, `test-0000394-req-002-pinned-actions.sh`, `test-0000319-req-002-ci-jobs.sh`, `test-0000397-req-003-ci-uses-source.sh` | U-1 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U-1 |
| New test file | `test-0000164-req-008` style tests, `run-tests.sh`, `run-tests.ps1` | U-1 |
| Backlog entry id | none found | U-1 |
| Pack content | none found | U-2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| .github/workflows/ravintio.yml | c269f565 | U-1 |
| ravintio-zero/tests/test-0000558-req-001-concurrency.sh | new | U-1 |
| src/ravintio-zero/tests/test-0000558-req-001-concurrency.sh | new | U-1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-1 | none | .github/workflows/ravintio.yml, ravintio-zero/tests/test-0000558-req-001-concurrency.sh, src/ravintio-zero/tests/test-0000558-req-001-concurrency.sh | 1 | The test and the workflow edit form one TDD cycle | none |
| U-2 | U-1 | docs/about.md, docs/adr/0349-cancel-superseded-pull-request-runs.md | 2 | The living docs describe the finished workflow | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | A new run cancels the older run of its group. | Older runs keep running. |

## Open Questions

None.
