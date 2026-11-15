# Execution Plan - Test impact scan lists the mirrored pack tree

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Version:** 0.115.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-scan-causes-in-reference-file.md](requirements/req-001-scan-causes-in-reference-file.md) | Scan causes move to a reference file |
| [req-002-pack-file-edit-cause.md](requirements/req-002-pack-file-edit-cause.md) | A `Pack file edit` cause lists the handoff suite |
| [req-003-component-paths-rule.md](requirements/req-003-component-paths-rule.md) | P0 lists the source tree in Component Paths |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | `ravintio-plan/SKILL.md` shrinks | Fewer than 13947 bytes | `wc -c` |
| NFR-002 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is text and tests in one component.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget | `test-0000384-skill-text.sh`, `test-0000383-req-001-005-test-impact-causes.sh` (total of 1720 lines) | U1 |
| Size cap | none found for `ravintio-plan` | U1 |
| Backlog entry id | none found for 0000540 | U1 |
| Reference file edit | `test-0000151-req-011-orchestrator-references-split.sh` | U2 |
| Scan section read | `test-0000246-req-001-test-impact-scan.sh`, `test-0000355-req-003-workflow-marker.sh`, `test-0000383-req-001-005-test-impact-causes.sh` | U3 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U4 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1 |
| Fixture-pinned line | none found | U1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | 3c789ad6 | U1 |
| `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` | new | U1 |
| `src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-gate.md` | c269f565 | U2 |
| `src/ravintio-zero/tests/test-0000246-req-001-test-impact-scan.sh` | c269f565 | U3 |
| `src/ravintio-zero/tests/test-0000355-req-003-workflow-marker.sh` | c269f565 | U3 |
| `src/ravintio-zero/tests/test-0000383-req-001-005-test-impact-causes.sh` | c269f565 | U3 |
| `src/ravintio-zero/tests/test-0000562-req-001-003-pack-file-edit-cause.sh` | new | U4 |
| `src/ravintio-zero/component.yml` | d813df28 | U5 |
| `docs/architecture-overview.md` | d813df28 | U5 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/skills/ravintio-plan/SKILL.md, src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md | 1 | none | none |
| U2 | none | src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-gate.md | 1 | none | none |
| U3 | U1 | src/ravintio-zero/tests/test-0000246-req-001-test-impact-scan.sh, src/ravintio-zero/tests/test-0000355-req-003-workflow-marker.sh, src/ravintio-zero/tests/test-0000383-req-001-005-test-impact-causes.sh | 2 | none | none |
| U4 | U1, U2 | src/ravintio-zero/tests/test-0000562-req-001-003-pack-file-edit-cause.sh | 2 | none | none |
| U5 | U1, U2 | docs/architecture-overview.md, src/ravintio-zero/component.yml | 2 | none | none |
| U6 | U3, U4, U5 | ravintio-zero/ | 3 | The sync copies every earlier edit, so it runs after them. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | `sync-installed.mjs` copies a new reference file to `ravintio-zero/`. | The parity check fails. |

## Open Questions

None.
