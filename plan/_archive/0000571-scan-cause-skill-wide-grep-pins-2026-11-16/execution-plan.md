# Execution Plan - Test impact scan covers skill-wide grep pins

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000571-scan-cause-skill-wide-grep-pins
**Version:** 0.135.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-skill-wide-grep-pin.md](requirements/req-001-skill-wide-grep-pin.md) | The scan says to list suites that loop over every skill |

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
| Skill-text budget | `test-0000246-req-001-test-impact-scan.sh` and `test-0000562-req-001-003-pack-file-edit-cause.sh` pin the cause name. The name stays. `test-0000384-skill-text.sh` caps `SKILL.md` lines, and the run edits no `SKILL.md` | U1 |
| Skill-wide grep pin | `test-0000151-req-008-quiet-test-output.sh` loops over every `SKILL.md` for `run-tests`. The run edits no `SKILL.md`, so it holds | U1 |
| Size cap | `test-0000383-req-001-005-test-impact-causes.sh`, `test-0000567-req-001-002-size-cap-frozen-lines.sh`, `test-0000568-req-001-prose-rewrite-cause.sh`, `test-0000569-req-001-pack-content-cause.sh`, and `test-0000570-req-001-sibling-copy-line.sh` cap the scan at 21. The sentence adds no line | U1 |
| Reference file edit | `test-0000562-req-001-003-pack-file-edit-cause.sh` and the frozen-line suites read the reference file. The run changes one line | U1 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U2 |
| Pack content | none, because the run adds no pack content file | U2 |
| Backlog entry id | none found for 0000404 that the run changes | U1 |
| Output order | none found, because the run changes no printed line | U1 |
| Fixture-pinned line | none found | U1 |
| Sibling copy | none found. `ravintio-zero/tests/regression/` holds no copy of the suites the run edits or adds | U1, U2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` | 141f3984 | U1 |
| `src/ravintio-zero/tests/test-0000571-req-001-skill-wide-grep-pin.sh` | new | U2 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md | 1 | none | none |
| U2 | none | src/ravintio-zero/tests/test-0000571-req-001-skill-wide-grep-pin.sh | 1 | none | none |
| U3 | U1, U2 | ravintio-zero/ | 2 | The sync copies every earlier edit, so it runs after them. | none |
| U4 | U3 | docs/ | 3 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The sentence extends the existing cause line. | Five suites need a higher scan cap. |

## Open Questions

None.
