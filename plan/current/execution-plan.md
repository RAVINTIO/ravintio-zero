# Execution Plan - No HEAD diffs in tests

> Every requirement traces to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000550-no-head-diffs-in-tests
**Version:** 0.125.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-head-diff-rule.md](requirements/req-001-head-diff-rule.md) | The testing standard bans diffing against HEAD |
| [req-002-head-diff-check.md](requirements/req-002-head-diff-check.md) | A suite fails any suite that diffs against HEAD |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Performance | The scan finishes quickly | Under 5 seconds for about 480 suites | Time the suite run |

## API Summary

None.

## Data Model Summary

None.

## Component Interactions

None.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000416 | none found | U-001 |
| Fixture-pinned line: `testing-standards.md` | `test-0000472-req-002-ci-duration-standards.sh`, `test-0000042-req-008-pack-prose.sh`, `test-0000380-req-003-timeout-helper.sh`, `test-0000391-req-005-archetypes.sh`, `test-0000005-pack-governance.sh` | U-001 |
| Pack file edit | `test-0000493-req-004-handoff-text.sh` | U-001 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U-002 |
| Skill count, skill-text budget, size cap | none found | U-001 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/standards/testing-standards.md | 6606109c | U-001 |
| ravintio-zero/standards/testing-standards.md | 6606109c | U-001 |
| src/ravintio-zero/tests/test-0000550-req-002-no-head-diffs.sh | new | U-002 |
| ravintio-zero/tests/test-0000550-req-002-no-head-diffs.sh | new | U-002 |
| docs/architecture-overview.md | 5152ebe3 | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | src/ravintio-zero/standards/testing-standards.md | 1 | none | none |
| U-002 | none | src/ravintio-zero/tests/test-0000550-req-002-no-head-diffs.sh | 1 | none | none |
| U-003 | U-001, U-002 | docs/architecture-overview.md | 2 | Documents the finished change | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The four `--base HEAD` uses pass an argument to a script and are not git diffs | The check fails on them and needs an allowlist |

## Open Questions

None.
