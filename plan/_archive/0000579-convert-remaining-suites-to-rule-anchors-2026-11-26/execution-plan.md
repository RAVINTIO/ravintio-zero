# Execution Plan - Convert remaining suites to rule anchors

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Version:** 0.149.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-convert-suites.md](requirements/req-001-convert-suites.md) | Each suite that pins a rule's prose reads it through an anchor and key terms |
| [req-002-ledger-and-probe.md](requirements/req-002-ledger-and-probe.md) | A guard suite checks the ledger and rewords the anchored rules |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |
| NFR-002 | Size | Combined skill text stays within its caps | 1720 lines or fewer | the cap suites |
| NFR-003 | Suite time | The full suite takes no more time than the baseline plus 5 percent | wall clock | the clean-clone run |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is text and tests in one component.

## Conversion batches

The scan found 206 candidate suites. The units split them by the target file each suite reads most. A suite that reads two families goes to the first batch in this order: roadmap standards, orchestrator, ship, initiative, plan and implement and validate, other. Each batch writes `plan/current/conversion-{batch}.txt` with one line per suite, `converted: {file}` or `structure: {file}: {reason}`.

## Pass signal paths

None. No requirement judges a component by its exit code.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget | The cap suites, such as `test-0000031-req-003-five-phases.sh`, hold at 1720. Anchors add no lines | U1 to U7 |
| Size cap | Orchestrator cap suites. Anchors add no lines | U3 |
| Reference file edit | `test-0000151-req-011-orchestrator-references-split.sh` freezes base lines of the orchestrator references. Each anchor edit changes a line | U3 |
| Prose rewrite | none found, because the run adds anchors to sentences and rewrites none | U1 to U7 |
| Fixture-pinned line | The batch greps `ravintio-zero/tests/fixtures/` for each line it anchors | U1 to U7 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh`, because the run edits pack files in both trees | U1 to U8 |
| Pack content | `test-0000042-req-010-pack-wording-allowlist.sh` reads pack text. The guard suite and the ledger avoid banned words | U8 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` and `test-0000151-req-008-quiet-test-output.sh` | U8 |
| Output order | none found, because the run changes no printed line | U1 to U8 |
| Sibling copy | none. The run edits no copy in `ravintio-zero/tests/regression/` | U1 to U8 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/` and `src/ravintio-zero/standards/` and `src/ravintio-zero/templates/` | a3ae8b71 | U1 to U7 |
| `src/ravintio-zero/tests/` | a3ae8b71 | U1 to U7 |
| `src/ravintio-zero/tests/test-0000579-req-001-anchor-conversion-guard.sh` | new | U8 |
| `src/ravintio-zero/tests/helpers/anchor-conversions.txt` | new | U8 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | roadmap-standards suites part one | 1 | none | the roadmap standards file |
| U2 | U1 | roadmap-standards suites part two | 2 | U1 and U2 both anchor rules in the roadmap standards file. | the roadmap standards file |
| U3 | none | orchestrator suites | 1 | none | none |
| U4 | none | ship suites | 1 | none | none |
| U5 | none | initiative suites | 1 | none | none |
| U6 | none | plan, implement, and validate suites | 1 | none | none |
| U7 | none | other-family suites | 1 | none | none |
| U8 | U1, U2, U3, U4, U5, U6, U7 | guard suite, ledger | 3 | The ledger lists the converted suites that earlier batches write. | none |
| U9 | U8 | ravintio-zero/ | 4 | The sync copies every earlier edit, so it runs after them. | none |
| U10 | U9 | docs/ | 5 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Anchors add no sentences, so the prose check and the line caps hold. | The step trims text. |
| A-002 | Half of the scanned suites pin prose. | The ledger records the real count. |

## Open Questions

None.
