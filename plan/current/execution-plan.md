---
title: "Execution Plan - Light discovery and audits"
summary: "Four independent units and a docs unit."
status: "active"
---
# Execution Plan - Light discovery and audits

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Version:** 0.67.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | plan | none |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-light-track.md](requirements/req-001-light-track.md) | Light discovery track |
| [req-002-grouped-commits.md](requirements/req-002-grouped-commits.md) | Grouped coaching commits |
| [req-003-criterion-content-check.md](requirements/req-003-criterion-content-check.md) | Criterion content check |
| [req-004-audit-refresh.md](requirements/req-004-audit-refresh.md) | Audit refresh at plan |
| [req-005-major-bump-coaching.md](requirements/req-005-major-bump-coaching.md) | Major-bump coaching |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | Orchestrator SKILL.md stays under its cap | 9,000 bytes or fewer | test-0000151-req-011 |
| NFR-002 | Size | Boot template stays under its cap | 3,600 bytes or fewer | test-0000151-req-011 |

## API Summary

None. No endpoints.

## Data Model Summary

| Entity | Owner Component | Key Fields | Relationships |
|--------|----------------|------------|--------------|
| discovery.md Track field | ravintio-zero | `Track` | none |

## Component Interactions

None. Markdown rules read by the agent.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000281, 0000284, 0000348, 0000328, 0000329 | none found | n/a |
| Size cap: orchestrator SKILL.md and boot template | test-0000151-req-011-orchestrator-references-split.sh | U1, U2 |
| Skill edit: ravintio-plan | test-0000384-skill-text.sh, test-0000170-req-001-story-map-pass.sh, test-0000246-req-001-test-impact-scan.sh | U4 |
| Reference file edit: orchestrator-p0-coaching | test-0000151-req-011-orchestrator-references-split.sh, test-0000388-req-003-explicit-agreement.sh | U3 |
| Fixture-pinned line: Hard Limit 8 | fixtures/0000151-orchestrator-skill-base.md | U1 |
| Template edit: discovery and build log | test-0000017-req-006-structured-discovery-pass.sh, test-0000172-req-003-phase-timing.sh, test-0000248-req-002-build-log-wall-clock-check.sh | U1, U4 |
| Boot template edit | test-0000029-req-001-003-boot-file-regeneration.sh, test-0000042-req-008-pack-prose.sh, test-0000379-req-007-worktree-rule.sh | U2 |
| New test file: repo-wide style tests | test-0000164-req-008 | U1 to U4 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Shared resources | Sequential reason |
|------|-----------|--------|-------|------------------|-------------------|
| U1 | none | ravintio-zero/skills/ravintio-orchestrator/SKILL.md, references/orchestrator-light-discovery.md, templates/discovery.template.md, tests/test-0000387-req-001-light-track.sh | 1 | none | none |
| U2 | none | references/orchestrator-discovery-records.md, templates/standard-boot.md, tests/test-0000387-req-002-grouped-commits.sh | 1 | none | none |
| U3 | none | references/orchestrator-p0-coaching.md, tests/test-0000387-req-003-005-coaching-checks.sh | 1 | none | none |
| U4 | none | skills/ravintio-plan/SKILL.md, templates/build-log.template.md, tests/test-0000387-req-004-audit-refresh.sh | 1 | none | none |
| U5 | U1, U2, U3, U4 | docs/architecture-overview.md | 2 | none | Shared docs after the code units land |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | check-design and gate-write read design.md headings only | A light design fails the gate |

## Open Questions

None.
