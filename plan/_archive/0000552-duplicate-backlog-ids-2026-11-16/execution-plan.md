# Execution Plan - Two open entries share one backlog id

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000552-duplicate-backlog-ids
**Version:** 0.139.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-duplicate-id-check.md](requirements/req-001-duplicate-id-check.md) | `--check` exits 1 and names a duplicated backlog id |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |
| NFR-002 | Safety | The generate mode never fails on a duplicate | exit 0 with two folders on one id | the new suite |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The merge queue keeps calling the generate mode unchanged.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id | none found for 0000542. The run edits `backlog-index.mjs`, which 14 suites grep. The nearest are `test-0000321-req-002-index-generator.sh`, `test-0000321-req-003-ci-index-check.sh`, and `test-0000481-req-001-regenerate.sh`. None builds a duplicate id | U2 |
| Output order | `test-0000321-req-002-index-generator.sh` and `test-0000321-req-003-ci-index-check.sh` read `--check` stderr. The run adds a line only when ids are duplicated, so no existing text moves | U2 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U2 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U1 |
| Pack content | none, because the run adds no pack content file | U1 |
| Diff reader | none, because the run reads no git diff | U2 |
| Fixture-pinned line | none found | U2 |
| Sibling copy | none found in `ravintio-zero/tests/regression/` | U1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/scripts/backlog-index.mjs` | c269f565 | U2 |
| `src/ravintio-zero/tests/test-0000552-req-001-duplicate-id-check.sh` | new | U1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/tests/test-0000552-req-001-duplicate-id-check.sh | 1 | Red phase comes first. | none |
| U2 | U1 | src/ravintio-zero/scripts/backlog-index.mjs | 2 | The test must fail first. | none |
| U3 | U2 | ravintio-zero/ | 3 | The sync copies every earlier edit. | none |
| U4 | U3 | docs/ | 4 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The merge queue runs the generate mode before `renumberCollisions`. | The check could also cover the generate mode. |

## Open Questions

None.
