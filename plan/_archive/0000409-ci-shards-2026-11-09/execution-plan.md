# Execution Plan - sharded CI suites

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000409-ci-shards
**Version:** 0.69.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-runner-shards.md](requirements/req-001-runner-shards.md) | `run-tests.sh` and `run-tests.ps1` run shard i of n from `RAVINTIO_SHARD` |
| [req-002-workflow-shards.md](requirements/req-002-workflow-shards.md) | CI runs the suites in parallel shards behind summary jobs that keep the required check names |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Performance | The slowest required check on a step PR | 7 minutes or less | `gh run view` on this PR |
| NFR-002 | Reliability | Every suite runs in exactly one shard per job | 100% of suites | `test-0000409-req-001-runner-shards.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The runners in `ravintio-zero` read `RAVINTIO_SHARD`. The repo workflow sets it per matrix entry. The summary jobs read the shard jobs' results through `needs`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `run-tests.sh` and `run-tests.ps1` | `test-0000036-req-001-003-runner.sh`, `test-0000385-req-003-clean-clone.sh` | U-001 |
| Workflow job or step edit | `test-0000036-req-005-windows-ci-job.sh`, `test-0000037-req-006-bash-suites-ci-job.sh`, `test-0000151-req-015-faster-powershell-ci.sh`, `test-0000394-req-002-pinned-actions.sh`, `test-0000319-req-002-ci-jobs.sh` | U-002 |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Backlog entry id (none pulled in) | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/tests/run-tests.sh`, `ravintio-zero/tests/run-tests.ps1`, `ravintio-zero/tests/test-0000409-req-001-runner-shards.sh` | 1 | U-002 sets the variable that U-001 reads, so the runner lands first |
| U-002 | U-001 | `.github/workflows/ravintio.yml`, the three CI-shape tests, `ravintio-zero/tests/README.md`, `docs/adr/0284-ci-runs-suites-in-shards.md` | 2 | It depends on the runner variable from U-001 |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | GitHub names a summary job's check after its `name:` | The ruleset waits on a missing check |

## Open Questions

None.
