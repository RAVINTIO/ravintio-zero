# Execution Plan - Start the baseline run before the P0 artifacts

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000559-start-baseline-first
**Version:** 0.141.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-baseline-first.md](requirements/req-001-baseline-first.md) | The baseline run starts before any P0 artifact |

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
| Prose rewrite | `test-0000557-req-001-safe-suite-wait.sh` reads four lines after the `p0-start-baseline` anchor. The edit keeps the wait bullet there. Its messages say "step 15", so U2 updates them. `test-0000487-req-003-p0-text.sh` and `test-0000385-req-002-baseline-failures.sh` grep fixed phrases that stay | U2 |
| Path move | none, because no file moves | U2 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U2 |
| Pack content | none, because the run adds no pack content file | U1 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U1 |
| Skill-text budget | none, because the edit adds under 2 lines to `SKILL.md` and changes one word | U2 |
| Output order | none, because the run changes no printed line | U2 |
| Sibling copy | none. `ravintio-zero/tests/regression/` holds no copy of the suites the run edits | U1, U2 |
| Fixture-pinned line | `ravintio-zero/tests/fixtures/0000151-orchestrator-skill-base.md` holds an old copy of the start actions. The run does not edit it | U2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md` | d41a9463 | U2 |
| `src/ravintio-zero/tests/test-0000559-req-001-baseline-first.sh` | new | U1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/tests/test-0000559-req-001-baseline-first.sh | 1 | none | none |
| U2 | U1 | src/ravintio-zero/skills/ravintio-orchestrator/, src/ravintio-zero/standards/roadmap-standards.md, src/ravintio-zero/tests/test-0000557-req-001-safe-suite-wait.sh | 2 | The test must fail before the text changes. | none |
| U3 | U2 | ravintio-zero/ | 3 | The sync copies every earlier edit. | none |
| U4 | U3 | docs/ | 4 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Tests pin start actions by anchor, not by number. | A suite fails on the renumbering. |

## Open Questions

None.
