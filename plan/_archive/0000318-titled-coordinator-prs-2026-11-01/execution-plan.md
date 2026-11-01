---
title: "Execution Plan - titled coordinator PRs"
summary: "Four units, two batches."
status: "active"
version: "0.44.0"
---
# Execution Plan - titled coordinator PRs

> Every requirement traces to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Version:** 0.44.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | plan | No capability skill is active. |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-no-direct-commits.md](requirements/req-001-no-direct-commits.md) | No direct commits on the initiative branch |
| [req-002-coordinator-pr-bar.md](requirements/req-002-coordinator-pr-bar.md) | Coordinator PR bar and carve-out |
| [req-003-pr-number-before-squash.md](requirements/req-003-pr-number-before-squash.md) | Ship records the PR number before the squash |
| [req-004-merge-guard-pinned.md](requirements/req-004-merge-guard-pinned.md) | `merge-guard` is pinned |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | No case that `merge-guard` blocks today becomes allowed | 0 regressions | Existing guard tests pass unchanged |
| NFR-002 | Maintainability | The initiative skill stays under its line cap | Under 120 lines | `test-0000314-req-002` |

## API Summary

No API.

## Data Model Summary

No data model.

## Component Interactions

```mermaid
flowchart LR
    A[Coordinator work] -->|driver stopped| B[feature branch and titled PR]
    B -->|local suite and green CI| C[gh pr merge --squash]
    C -->|merge-guard: base initiative/*| D[initiative branch]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget: the run edits the initiative and ship `SKILL.md` (total cap 1720, now 1555) | `test-0000031-req-003-five-phases.sh`, `test-0000206-req-002-step-application.sh`, `test-0000314-req-002-driver-files-stay.sh` (initiative skill under 120, now 112) | U1, U2 |
| Skill count: no skill added | none found | none |
| Size cap: no orchestrator edit | none found | none |
| Standards wording | `test-0000043-req-005-roadmap-advance.sh`, `test-0000043-req-008-roadmap-delivery.sh`, `test-0000043-req-010-merge-carve-out-governance.sh` | U1 |
| Backlog entry id 0000274 (entry deleted in P0) | `test-0000189-req-008-open-backlog-entries.sh`, `test-0000205-req-005-living-docs-and-counts.sh` | U4 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U1 | none | `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/skills/ravintio-initiative/SKILL.md`, `ravintio-zero/tests/test-0000318-req-001-002-coordinator-prs.sh` | 1 | none |
| U2 | none | `ravintio-zero/skills/ravintio-ship/SKILL.md`, `ravintio-zero/tests/test-0000318-req-003-pr-number-before-squash.sh` | 1 | none |
| U3 | none | `ravintio-zero/tests/test-0000318-req-004-merge-guard-pinned.sh` | 1 | none |
| U4 | U1, U2, U3 | `plan/current-initiative/initiative.md`, `ravintio-zero/templates/initiative.template.md`, `ravintio-zero/component.yml`, `product.yml`, `docs/about.md`, any count tests in Test impact | 2 | The docs, chart, and version record state what U1 to U3 wrote. |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | `merge-guard` reads the PR base only. | The pinning test fails and the step stops. |

## Open Questions

None.
