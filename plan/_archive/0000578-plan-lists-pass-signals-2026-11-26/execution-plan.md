# Execution Plan - Plan lists every way a check can pass

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000578-plan-lists-pass-signals
**Version:** 0.145.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-pass-signal-paths.md](requirements/req-001-pass-signal-paths.md) | The plan skill lists every path to a pass signal, launcher failures included |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Parity | Both pack trees match | `sync-installed.mjs --check` exits 0 | the script |
| NFR-002 | Size | Combined skill text stays small | 1720 lines or fewer | the cap suites |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The component owns no data.

## Component Interactions

None. The change is text and tests in one component.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget | `test-0000031-req-003-five-phases.sh`, `test-0000206-req-002-step-application.sh`, `test-0000327-req-003-ship-skill-rules.sh`, and `test-0000359-req-001-no-tree-git-under-subagents.sh` cap the combined skill text at 1720. It holds 1690 | U1 |
| Prose rewrite | none found, because the run adds a section and rewrites no sentence | U1 |
| Pack file edit | `test-0000042-req-010-pack-wording-allowlist.sh` reads pack text. The new text avoids banned words | U1 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U2 |
| Pack content | none, because the run adds no pack content file | U2 |
| Output order | none found, because the run changes no printed line | U1 |
| Sibling copy | none found. `ravintio-zero/tests/regression/` holds no copy of the suite the run adds | U2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | 9c91dab5 | U1 |
| `src/ravintio-zero/tests/test-0000578-req-001-pass-signal-paths.sh` | new | U2 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | src/ravintio-zero/skills/ravintio-plan/SKILL.md | 1 | none | none |
| U2 | none | src/ravintio-zero/tests/test-0000578-req-001-pass-signal-paths.sh | 1 | none | none |
| U3 | U1, U2 | ravintio-zero/ | 2 | The sync copies every earlier edit, so it runs after them. | none |
| U4 | U3 | docs/ | 3 | The docs record the final text. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | About 8 lines fit under the cap. | The step moves the text to a reference file. |

## Open Questions

None.
