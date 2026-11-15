# Execution Plan - List sibling copies of a pinned test in the impact scan

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000570-sibling-test-copies-in-impact-scan
**Version:** 0.133.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-sibling-copy-line.md](requirements/req-001-sibling-copy-line.md) | The scan says to list the regression copy of each test it names |

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
| Skill-text budget | `test-0000384-skill-text.sh` caps the total `SKILL.md` lines at 1720. The sentence adds no line | U1 |
| Size cap | `test-0000383-req-001-005-test-impact-causes.sh`, `test-0000567-req-001-002-size-cap-frozen-lines.sh`, `test-0000568-req-001-prose-rewrite-cause.sh`, and `test-0000569-req-001-pack-content-cause.sh` cap the scan at 21. The sentence adds no line | U1 |
| Scan section pins | `test-0000246-req-001-test-impact-scan.sh` reads the `## Test impact scan` section | U1 |
| Backlog entry id | none found for 0000407 that the run changes | U1 |
| Reference file edit | none, because the run edits no reference file | U1 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U2 |
| Pack content | none, because the run adds no pack content file | U2 |
| Output order | none found, because the run changes no printed line | U1 |
| Fixture-pinned line | none found | U1 |
| Sibling copy | none found. `ravintio-zero/tests/regression/` holds no copy of the suites the run edits or adds | U1, U2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | 462e7100 | U1 |
| `src/ravintio-zero/tests/test-0000570-req-001-sibling-copy-line.sh` | new | U2 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/skills/ravintio-plan/SKILL.md | 1 | none | none |
| U2 | none | src/ravintio-zero/tests/test-0000570-req-001-sibling-copy-line.sh | 1 | none | none |
| U3 | U1, U2 | ravintio-zero/ | 2 | The sync copies every earlier edit, so it runs after them. | none |
| U4 | U3 | docs/ | 3 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The sentence fits the existing scan paragraph. | Four suites need a higher scan cap. |

## Open Questions

None.
