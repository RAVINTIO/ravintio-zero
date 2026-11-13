# Execution Plan - unit dispatch

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000386-unit-dispatch
**Version:** 0.70.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-inline-tdd-path.md](requirements/req-001-inline-tdd-path.md) | A content unit that applies agreed text or changes one file runs inline, with RED before GREEN |
| [req-002-unit-class-tier-effort.md](requirements/req-002-unit-class-tier-effort.md) | One table maps class and signals to tier and effort, and the Done line records them |
| [req-003-metrics-by-class-and-tier.md](requirements/req-003-metrics-by-class-and-tier.md) | `workflow-metrics.mjs` reports units and rework by class and tier |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Compatibility | A build log with legacy `Done:` lines still passes every script | 0 new findings | `test-0000386-req-003-metrics-by-class-and-tier.sh` |
| NFR-002 | Maintainability | The table gives one tier and one effort for every class and score | 16 of 16 pairs | `test-0000386-req-002-unit-class-tier-effort.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The implement skill and the dispatch standards define the markers and the `Done:` form. `resume-detect.mjs`, `build-log-check.mjs`, and `workflow-metrics.mjs` each read those lines from `build-log.md`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (edits `ravintio-implement/SKILL.md`) | `test-0000005-pack-governance.sh`, `test-0000007-agent-optimisation.sh`, `test-0000042-req-008-pack-prose.sh` | U-001 |
| Edit to `agent-dispatch-standards.md` | `test-0000151-req-007-dispatch-model-tiers.sh`, `test-0000043-req-012-progress-markers-and-resume.sh`, `test-0000202-req-001-improvement-loop.sh` | U-002 |
| Edit to `resume-detect.mjs` | `test-0000243-req-001-002-006-resume-detect.sh` | U-002 |
| Edit to `build-log-check.mjs` | `test-0000248-req-002-build-log-wall-clock-check.sh`, `test-0000358-req-002-003-build-log-checks.sh` | U-001 |
| Edit to `workflow-metrics.mjs` and the governance standard | `test-0000173-req-001-workflow-metrics-script.sh`, `test-0000173-req-002-thresholds-gate.sh`, `test-0000173-req-003-metric-markers.sh` | U-001, U-003 |
| Edit to `build-log.template.md` | `test-0000172-req-003-phase-timing.sh`, `test-0000387-req-004-audit-refresh.sh` | U-002 |
| Backlog entry id (0000330, 0000366 pulled in) | none found | none |
| New test files | `test-0000164-req-008-no-process-substitution-loops.sh` and the other repo-wide style tests | U-001, U-002, U-003 |
| Reference file edit | none found | none |
| Non-suite file | none found | none |
| Fixture-pinned line | `ravintio-zero/tests/fixtures/0000243-resume-detection-base.md` | U-002 |

## Concurrency plan

| Unit | Depends on | Writes | Shared resources | Batch | Sequential reason |
|------|-----------|--------|------------------|-------|-------------------|
| U-001 | none | `ravintio-zero/skills/ravintio-implement/SKILL.md`, `ravintio-zero/standards/workflow-governance-standards.md`, `ravintio-zero/scripts/build-log-check.mjs`, `ravintio-zero/tests/test-0000386-req-001-inline-tdd-path.sh` | none | 1 | |
| U-002 | none | `ravintio-zero/standards/agent-dispatch-standards.md`, `ravintio-zero/templates/build-log.template.md`, `ravintio-zero/scripts/resume-detect.mjs`, `ravintio-zero/tests/test-0000386-req-002-unit-class-tier-effort.sh` | none | 1 | |
| U-003 | none | `ravintio-zero/scripts/workflow-metrics.mjs`, `ravintio-zero/tests/test-0000386-req-003-metrics-by-class-and-tier.sh` | none | 1 | |
| U-004 | U-001, U-002, U-003 | `docs/decisions-index.md`, `docs/architecture-overview.md`, `plan/changelog/0000386-unit-dispatch-2026-11-09.md` | none | 2 | The docs describe what the three units built |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The Agent tool accepts an `effort` value | The dispatch omits it and the table still records it |

## Open Questions

None.
