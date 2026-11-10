# Execution Plan - CI duration metric

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000472-ci-duration-metric
**Version:** 0.87.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-ci-duration-metric-script.md](requirements/req-001-ci-duration-metric-script.md) | CI duration row in `workflow-metrics.mjs` |
| [req-002-ci-duration-standards-and-marker.md](requirements/req-002-ci-duration-standards-and-marker.md) | Marker, threshold, and target in the standards and the ship skill |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Maintainability | The skill-text total stays within its cap | 1720 lines or fewer | `test-0000384-skill-text.sh` |
| NFR-002 | Reliability | A breach never fails the gate | exit code 0 on a breach | REQ-001 AC-2 |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

Ship appends the marker to the archived build log. `workflow-metrics.mjs` reads the log and the Thresholds table. `sync-installed.mjs` copies `src/ravintio-zero/` to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `workflow-metrics.mjs` | `test-0000173-req-001-workflow-metrics-script.sh`, `test-0000173-req-003-metric-markers.sh`, `test-0000173-req-004-ship-governance-report.sh`, `test-0000386-req-003-metrics-by-class-and-tier.sh` | U-001 |
| Edit to the governance standard (new Thresholds row) | `test-0000173-req-001-workflow-metrics-script.sh`, `test-0000173-req-003-metric-markers.sh` | U-002 |
| Skill-text budget (edit to `ravintio-ship/SKILL.md`) | `test-0000384-skill-text.sh` | U-002 |
| New test file | `test-0000164-req-008` style tests | U-001, U-002 |
| Backlog entry id | 0000436 | U-001 |
| Skill count (no skill added) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Non-suite file | none found | none |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Fixture-pinned line | none found | none |

## Branch-point reads

The plan read these files at the tip of `origin/initiative/0000360-backlog-sweep` (`f7573cde`) on 2026-11-10.

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/scripts/workflow-metrics.mjs` | c952df2c | U-001 |
| `src/ravintio-zero/standards/workflow-governance-standards.md` | c952df2c | U-002 |
| `src/ravintio-zero/standards/testing-standards.md` | c952df2c | U-002 |
| `src/ravintio-zero/skills/ravintio-ship/SKILL.md` | c952df2c | U-002 |
| `src/ravintio-zero/tests/test-0000472-req-001-ci-duration-metric.sh` | new | U-001 |
| `src/ravintio-zero/tests/test-0000472-req-002-ci-duration-standards.sh` | new | U-002 |
| `docs/architecture-overview.md` | b75d165f | U-003 |
| `docs/adr/0308-report-ci-duration-in-workflow-metrics.md` | new | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | `src/ravintio-zero/scripts/workflow-metrics.mjs`, `src/ravintio-zero/tests/test-0000472-req-001-ci-duration-metric.sh` | 1 | none | none |
| U-002 | none | `src/ravintio-zero/standards/workflow-governance-standards.md`, `src/ravintio-zero/standards/testing-standards.md`, `src/ravintio-zero/skills/ravintio-ship/SKILL.md`, `src/ravintio-zero/tests/test-0000472-req-002-ci-duration-standards.sh` | 1 | none | none |
| U-003 | U-001, U-002 | `docs/architecture-overview.md`, `docs/adr/0308-report-ci-duration-in-workflow-metrics.md` | 2 | Living docs unit. It records what U-001 and U-002 built | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Ship can read a CI run's start and end with `gh` | The metric skips the run |
| A-002 | The target is 420 seconds | One table cell changes |

## Open Questions

None.
