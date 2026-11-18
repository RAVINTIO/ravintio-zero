# Execution Plan - Delivery PR lists steps in version order

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000574-delivery-pr-lists-steps-in-version-order
**Version:** 0.143.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-rule-6-order.md](requirements/req-001-rule-6-order.md) | Rule 6 names the table order |
| [req-002-printed-table.md](requirements/req-002-printed-table.md) | The script prints the step table |
| [req-003-order-test.md](requirements/req-003-order-test.md) | A test checks the printed order |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |
| NFR-002 | Correctness | The printed rows ascend by version | strictly ascending for any chart | the new suite |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is one script, one standard, and tests in one component.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Output order | The script adds a table after the `wrote` lines. `test-0000353-req-001-004-reshape-script.sh`, `test-0000378-req-004-merge-order.sh`, and `test-0000378-req-005-reshape-folds.sh` read the output. They assert on single lines, and none reads the last line. `test-0000353-req-005-006-delivery-and-ship.sh` greps the delivery text | U1 |
| Prose rewrite | none found. No suite greps the text of rule 6 | U2 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U1, U2 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U1, U2 |
| Backlog entry id | none found for 0000543 that the run changes | U2 |
| Skill-text budget | none found, because the run edits no `SKILL.md` | U1, U2 |
| Pack content | none, because the run adds no pack content file | U1, U2 |
| Fixture-pinned line | none found | U2 |
| Sibling copy | none found in `ravintio-zero/tests/regression/` for the suites the run edits or adds | U1, U2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/scripts/reshape-initiative.mjs` | c269f565 | U1 |
| `src/ravintio-zero/standards/roadmap-standards.md` | 59461c5e | U2 |
| `src/ravintio-zero/tests/test-0000574-req-002-003-printed-table.sh` | new | U1 |
| `src/ravintio-zero/tests/test-0000574-req-001-rule-6-order.sh` | new | U2 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/scripts/reshape-initiative.mjs, src/ravintio-zero/tests/test-0000574-req-002-003-printed-table.sh | 1 | none | none |
| U2 | none | src/ravintio-zero/standards/roadmap-standards.md, src/ravintio-zero/tests/test-0000574-req-001-rule-6-order.sh | 1 | none | none |
| U3 | U1, U2 | ravintio-zero/ | 2 | The sync copies every earlier edit, so it runs after them. | none |
| U4 | U3 | docs/ | 3 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The version sort at line 149 stays the one source of order. | The table and the replay disagree. |

## Open Questions

None.
