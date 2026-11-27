# Execution Plan - Coordinator starts a defined stage without asking

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000554-coordinator-starts-defined-stages
**Version:** 0.126.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | plan | No capability skill applies. |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-defined-stage-rule.md](requirements/req-001-defined-stage-rule.md) | Rule `coord-defined-stage` and the skill line |
| [req-002-clean-end-action.md](requirements/req-002-clean-end-action.md) | The clean-end action text |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Maintainability | The initiative skill stays short. | Fewer than 120 lines and a total under 1720 lines | `wc -l` in four existing tests |

## API Summary

None. The step adds no endpoint.

## Data Model Summary

None. The step adds no data.

## Component Interactions

The driver prints the action line and the coordinator reads the skill and the standards. No new interaction.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget | test-0000205-req-004, test-0000313-req-002, test-0000314-req-002, test-0000399-req-003-004, test-0000536-req-001-003 (all cap the skill below 120 lines) | U-1 |
| Skill-text budget | test-0000314-req-002 (total cap 1720, current 1689) | U-1 |
| Backlog entry id 0000541 | none found | U-1 |
| Output order | test-0000511-req-001-003-stop-summary.sh pins the delivery action text on line 37 | U-2 |
| Fixture-pinned line | none found | U-1 |
| Size cap | none found | U-1 |
| Pack file edit | test-0000493-req-004-handoff-text.sh | U-1, U-2 |
| New test file | none found, the new check joins an existing suite | U-1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/standards/roadmap-standards.md | 202f5871 | U-1, U-2 |
| src/ravintio-zero/skills/ravintio-initiative/SKILL.md | 202f5871 | U-1 |
| src/ravintio-zero/scripts/initiative-run.mjs | c557f904 | U-2 |
| src/ravintio-zero/tests/test-0000511-req-001-003-stop-summary.sh | 8712c561 | U-2 |
| src/ravintio-zero/tests/test-0000399-req-003-004-question-rule.sh | a1d31cee | U-1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-1 | none | roadmap-standards.md, ravintio-initiative/SKILL.md, test-0000399-req-003-004-question-rule.sh | 1 | Both units write `roadmap-standards.md`, so they run in turn. | none |
| U-2 | U-1 | roadmap-standards.md, initiative-run.mjs, test-0000511-req-001-003-stop-summary.sh | 2 | Writes `roadmap-standards.md` after U-1. | none |
| U-3 | U-2 | docs/ | 3 | Documents the finished change. | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Only test-0000511 pins the old action text. | Another suite fails and the step updates its pin. |

## Open Questions

None.
