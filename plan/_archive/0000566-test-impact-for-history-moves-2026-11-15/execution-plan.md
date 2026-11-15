# Execution Plan - Test impact scan misses suites that scan live files

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000566-test-impact-for-history-moves
**Version:** 0.124.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-history-move-cause.md](requirements/req-001-history-move-cause.md) | A `History move` cause lists the suites with a `plan/_archive/` exclusion when archived content moves into a live folder |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is text and tests in one component.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Reference file edit | `test-0000246-req-001-test-impact-scan.sh`, `test-0000355-req-003-workflow-marker.sh`, `test-0000383-req-001-005-test-impact-causes.sh`, `test-0000562-req-001-003-pack-file-edit-cause.sh`, `test-0000563-req-001-output-order-cause.sh`, `test-0000564-req-001-hook-change-cause.sh`, `test-0000565-req-001-path-move-cause.sh` | U1 |
| Skill-text budget | none found, because the run edits no `SKILL.md` | U1 |
| Backlog entry id | none found for 0000405 that the run changes. `test-0000405-req-001-short-base-merge-subject.sh` holds the number for another feature. | U1 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U2 |
| Output order | none found, because the run changes no printed line | U1 |
| Fixture-pinned line | none found | U1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` | bf80a4b2 | U1 |
| `src/ravintio-zero/tests/test-0000566-req-001-history-move-cause.sh` | new | U2 |
| `docs/architecture-overview.md` | bf80a4b2 | U3 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md | 1 | none | none |
| U2 | none | src/ravintio-zero/tests/test-0000566-req-001-history-move-cause.sh | 1 | none | none |
| U3 | none | docs/architecture-overview.md | 1 | none | none |
| U4 | U1, U2, U3 | ravintio-zero/ | 2 | The sync copies every earlier edit, so it runs after them. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The plan skill already has a Pack Index row for the reference file. | The step adds the row. |

## Open Questions

None.
