# Execution Plan - Scan new pack files for the wording allowlist

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000569-scan-new-pack-files-for-wording-allowlist
**Version:** 0.131.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-pack-content-cause.md](requirements/req-001-pack-content-cause.md) | The scan has a `Pack content` cause that lists the wording tests |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |
| NFR-002 | Size | The scan stays small | 21 lines or fewer | the cap suites |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is text and tests in one component.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Reference file edit | `test-0000246-req-001-test-impact-scan.sh`, `test-0000355-req-003-workflow-marker.sh`, `test-0000383-req-001-005-test-impact-causes.sh`, `test-0000562-req-001-003-pack-file-edit-cause.sh`, `test-0000563-req-001-output-order-cause.sh`, `test-0000564-req-001-hook-change-cause.sh`, `test-0000565-req-001-path-move-cause.sh`, `test-0000566-req-001-history-move-cause.sh`, `test-0000567-req-001-002-size-cap-frozen-lines.sh`, `test-0000568-req-001-prose-rewrite-cause.sh` | U1 |
| Size cap | `test-0000383-req-001-005-test-impact-causes.sh`, `test-0000567-req-001-002-size-cap-frozen-lines.sh`, `test-0000568-req-001-prose-rewrite-cause.sh` cap the scan at 20. Each moves to 21 | U1 |
| Skill-text budget | none found, because the run edits no `SKILL.md` | U1 |
| Backlog entry id | none found for 0000415 that the run changes | U1 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U2 |
| Pack content | none, because the run adds no pack content file. It adds a test under `ravintio-zero/tests/`, which `test-0000042-req-010` reads for the word it bans | U2 |
| Output order | none found, because the run changes no printed line | U1 |
| Fixture-pinned line | none found | U1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` | a256a338 | U1 |
| `src/ravintio-zero/tests/test-0000383-req-001-005-test-impact-causes.sh` | a256a338 | U1 |
| `src/ravintio-zero/tests/test-0000567-req-001-002-size-cap-frozen-lines.sh` | a256a338 | U1 |
| `src/ravintio-zero/tests/test-0000568-req-001-prose-rewrite-cause.sh` | a256a338 | U1 |
| `src/ravintio-zero/tests/test-0000569-req-001-pack-content-cause.sh` | new | U2 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md, src/ravintio-zero/tests/test-0000383-req-001-005-test-impact-causes.sh, src/ravintio-zero/tests/test-0000567-req-001-002-size-cap-frozen-lines.sh, src/ravintio-zero/tests/test-0000568-req-001-prose-rewrite-cause.sh | 1 | none | none |
| U2 | none | src/ravintio-zero/tests/test-0000569-req-001-pack-content-cause.sh | 1 | none | none |
| U3 | U1, U2 | ravintio-zero/ | 2 | The sync copies every earlier edit, so it runs after them. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The causes live in the reference file and not in `SKILL.md`. | None, because the test reads the scan text from both files. |

## Open Questions

None.
