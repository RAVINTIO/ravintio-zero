# Execution Plan - Merge queue test gaps

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000464-merge-queue-test-gaps
**Version:** 0.84.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-rerun-fixture.md](requirements/req-001-rerun-fixture.md) | A second run adds no commit and still merges |
| [req-002-version-mismatch-fixture.md](requirements/req-002-version-mismatch-fixture.md) | A mismatch after the set stops the run before the merge |
| [req-003-dash-guard.md](requirements/req-003-dash-guard.md) | A ref name that starts with a dash gets refused |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Coverage | The two untested branches of `mergeAndRelease` run in the suite | 2 of 2 branches | AC-1 of REQ-001 and AC-1 of REQ-002 |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

`merge-queue.mjs run` calls `gh pr view` and then `git`. The new tests use the fake `gh` shim pattern of test 0000456. The source lives in `src/ravintio-zero/`, and `sync-installed.mjs` copies it to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `merge-queue.mjs` | `test-0000378-req-002-003-merge-queue.sh`, `test-0000405-req-001-short-base-merge-subject.sh`, `test-0000454-req-001-queue-failure-recovery.sh`, `test-0000456-req-001-queue-resolves.sh`, `test-0000458-req-001-refuse-step-merge.sh`, `test-0000392-req-003-queue-waits-for-ci.sh`, `test-0000411-req-001-queue-waits.sh`, `test-0000420-req-001-optional-version-files.sh`, `test-0000379-req-004-queue-handoff.sh` | U-002 |
| Backlog entry id | `test-0000351-req-003-shape-check.sh`, `test-0000247-req-002-commit-id-reservations.sh` | U-003 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U-001, U-002 |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Non-suite file (none) | none found | none |
| Fixture-pinned line | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Shared resources | Sequential reason |
|------|-----------|--------|-------|------------------|-------------------|
| U-001 | none | `src/ravintio-zero/tests/test-0000464-req-001-002-queue-branches.sh` | 1 | none | - |
| U-002 | none | `src/ravintio-zero/scripts/merge-queue.mjs`, `src/ravintio-zero/tests/test-0000464-req-003-dash-guard.sh` | 1 | none | - |
| U-003 | U-001, U-002 | `docs/architecture-overview.md`, `docs/about.md` | 2 | none | Living docs unit. It records what U-001 and U-002 built |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The fake `gh` of test 0000456 extends to both fixtures | The step writes a new shim |

## Open Questions

None.
