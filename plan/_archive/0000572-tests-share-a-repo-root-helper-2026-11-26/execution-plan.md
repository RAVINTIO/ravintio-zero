# Execution Plan - Tests share a repo-root helper for both pack trees

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000572-tests-share-a-repo-root-helper
**Version:** 0.147.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-repo-root-helpers.md](requirements/req-001-repo-root-helpers.md) | `assert.sh` offers `repo_root` and the two tree helpers |
| [req-002-standard-and-adoption.md](requirements/req-002-standard-and-adoption.md) | The standards name the helpers, and two suites call them |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |
| NFR-002 | Quiet | Sourcing `assert.sh` prints nothing new | 0 extra output lines | the new suite |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is shell helpers, text, and tests in one component.

## Units

| Unit | Requirement | Work |
|------|-------------|------|
| U1 | REQ-001 | New suite `test-0000572-req-001-repo-root-helpers.sh`, then the three functions in `src/ravintio-zero/tests/helpers/assert.sh` |
| U2 | REQ-002 | New suite `test-0000572-req-002-standard-and-adoption.sh`, the standards paragraph, and the two suite edits |
| U3 | REQ-001, REQ-002 | Mirror to `ravintio-zero/` with `sync-installed.mjs` |
| U4 | REQ-001, REQ-002 | Update `docs/architecture-overview.md` and the `component.yml` scope line |

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Pack file edit | `test-0000493-req-004-handoff-text.sh` compares both trees file by file. It is also an edit target of U2 | U1, U2, U3 |
| Pack content | `test-0000042-req-010-pack-wording-allowlist.sh` and `test-0000042-req-008-pack-prose.sh` scan the new standards text | U2 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U1, U2 |
| Non-suite file | `assert.sh` is not a suite. Every suite sources it, so U1 runs the full suite before ship | U1 |
| Reference file edit | none, because the run edits no skill reference file | U1 |
| Size cap | none, because the run edits no `SKILL.md` | U1 |
| Skill-text budget | none found, because the run edits no `SKILL.md` | U1 |
| Backlog entry id | none found for 0000528 or 0000539 that the run changes | U1 |
| Output order | none found, because the run changes no printed script line | U1 |
| Fixture-pinned line | none found | U1 |
| Sibling copy | none found. `ravintio-zero/tests/regression/` holds no copy of the suites the run edits | U1, U2 |
| Path move | none, because the run moves no folder. U2 removes two depth-based root lines | U2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/tests/helpers/assert.sh` | c269f565 | U1 |
| `src/ravintio-zero/standards/testing-standards.md` | be0e10f2 | U2 |
| `src/ravintio-zero/tests/test-0000534-req-001-003-step-clock.sh` | c557f904 | U2 |
| `src/ravintio-zero/tests/test-0000493-req-004-handoff-text.sh` | fc5da569 | U2 |
| `src/ravintio-zero/tests/test-0000572-req-001-repo-root-helpers.sh` | new | U1 |
| `src/ravintio-zero/tests/test-0000572-req-002-standard-and-adoption.sh` | new | U2 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/tests/helpers/assert.sh, src/ravintio-zero/tests/test-0000572-req-001-repo-root-helpers.sh | 1 | none | none |
| U2 | none | src/ravintio-zero/standards/testing-standards.md, src/ravintio-zero/tests/test-0000534-req-001-003-step-clock.sh, src/ravintio-zero/tests/test-0000493-req-004-handoff-text.sh, src/ravintio-zero/tests/test-0000572-req-002-standard-and-adoption.sh | 1 | none | none |
| U3 | U1, U2 | ravintio-zero/ | 2 | The sync copies every earlier edit, so it runs after them. | none |
| U4 | U3 | docs/, src/ravintio-zero/component.yml | 3 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | `product.yml` sits at the repo root and nowhere between a suite and the root. | The helper returns a wrong folder. |

## Open Questions

None.
