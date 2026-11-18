# Execution Plan - Old-name guard fails in the full suite

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000561-old-name-guard-fails-in-full-suite
**Version:** 0.144.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-stable-guard-input.md](requirements/req-001-stable-guard-input.md) | The guard reads input that no earlier suite changes |
| [req-002-planted-change-test.md](requirements/req-002-planted-change-test.md) | A test plants the earlier suite's change and the guard passes |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |
| NFR-002 | Stability | The guard gives one result in a solo and a full-suite run | 0 differing results in the baseline and the P3 full run | the two run outputs |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is one test suite in one component.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1 |
| Sibling copy | none found. `ravintio-zero/tests/regression/` holds no copy of the guard suite | U1 |
| Prose rewrite | none found. The run rewrites no pack sentence | U1 |
| Pack content | none, because the run adds no content file | U1 |
| New test file | none, because the run adds no test file | U1 |
| Output order | `test-0000320-req-002-migration-reporting.sh` names the guard. It reads no printed line of it | U1 |
| Fixture-pinned line | none found | U1 |
| Backlog entry id | none found for 0000527 that the run changes | U1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/tests/test-0000189-req-007-old-name-guard.sh` | c269f565 | U1 |
| `ravintio-zero/tests/test-0000189-req-007-old-name-guard.sh` | c269f565 | U2 |

## Units

- U1: change the guard suite for REQ-001, and add the planted-change cases for REQ-002.
- U2: run `sync-installed.mjs` to copy U1 into `ravintio-zero/`.
- U3: update the docs that name the guard.

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/tests/test-0000189-req-007-old-name-guard.sh | 1 | The reproduction decides the fix, so one unit holds it. | none |
| U2 | U1 | ravintio-zero/ | 2 | The sync copies the U1 edit, so it runs after U1. | none |
| U3 | U2 | docs/ | 3 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | An earlier suite changes the tree, or the guard races with the runner. | Reproduction finds another cause and the fix targets it. |

## Open Questions

None.
