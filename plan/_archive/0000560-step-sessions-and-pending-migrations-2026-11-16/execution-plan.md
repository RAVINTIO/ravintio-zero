# Execution Plan - Step sessions meet pending migrations

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000560-step-sessions-and-pending-migrations
**Version:** 0.141.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-ledger-rows-with-detect.md](requirements/req-001-ledger-rows-with-detect.md) | A suite pins the ledger skip rules when a Detect line is true |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is one test in one component.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U1 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1 |
| Backlog entry id | Grep for 0000403 matched seven suites. Each uses the id as sample data and none reads the backlog folder, so the entry removal breaks none | U1 |
| Skill-text budget | none found, because the run edits no `SKILL.md` | U1 |
| Size cap | none found, because the run edits no skill | U1 |
| Reference file edit | none found, because the run edits no reference file | U1 |
| Pack content | none, because the run adds no pack content file | U1 |
| Output order | none found, because the run changes no printed line | U1 |
| Fixture-pinned line | none found | U1 |
| Sibling copy | none found. `ravintio-zero/tests/regression/` holds no copy of `test-0000399` or the new suite | U1 |
| Diff reader | none, because the run adds no unit that reads a git diff | U1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/tests/test-0000560-req-001-ledger-rows-with-detect.sh` | new | U1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/tests/test-0000560-req-001-ledger-rows-with-detect.sh | 1 | U1 is the only unit that needs no earlier output, and every later unit copies or records its file. | none |
| U2 | U1 | ravintio-zero/ | 2 | The sync copies the earlier edit, so it runs after it. | none |
| U3 | U2 | docs/ | 3 | The docs record the final state. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | 0000536 and 0000399 cover the rest of entry 0000403. | A step session still stops on a migration, and a follow-up entry adds the fix. |

## Open Questions

None.
