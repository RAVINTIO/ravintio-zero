---
title: "Execution Plan - driver setup stop"
summary: "Three units, one batch."
status: "active"
version: "0.41.0"
---
# Execution Plan - driver setup stop

> Every requirement traces to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Version:** 0.41.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | plan | No capability skill is active. |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-driver-setup-stop.md](requirements/req-001-driver-setup-stop.md) | Driver stops after a merged step that changes setup paths |
| [req-002-initiative-skill-setup-stop.md](requirements/req-002-initiative-skill-setup-stop.md) | Initiative skill handles the stop |
| [req-003-standards-setup-stop.md](requirements/req-003-standards-setup-stop.md) | Standards and manifest document the stop |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Reliability | The stop fires on every watched-path change and on no test-only change | 100% of the fixture cases | Bash test with a stub `claude` |
| NFR-002 | Security | The skill reruns only the exact command a `Confirmation:` row names | 1 rule in the skill text | Text assertion |
| NFR-003 | Size | The initiative skill stays short | fewer than 120 lines, and all skill text 1720 lines or fewer | Existing tests |

## API Summary

No API.

## Data Model Summary

No data model.

## Component Interactions

```mermaid
flowchart LR
    A[initiative-run.mjs] -->|Setup: line, exit 1| B[initiative skill]
    B -->|setup.sh, new driver| A
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget: the run edits the initiative `SKILL.md` | `test-0000031-req-003-five-phases.sh`, `test-0000206-req-002-step-application.sh` (1720 lines, now 1545) | U2 |
| Skill-text budget: the initiative skill line cap | `test-0000205-req-004-initiative-skill.sh` (fewer than 120 lines, now 102) | U2 |
| Skill count: no skill added | none found | none |
| Size cap: no orchestrator edit | none found | none |
| Backlog entry id 0000311 | none found | none |
| Driver behaviour: a skill file change now stops the driver | `test-0000250-req-002-driver-restart-stop.sh` AC-3 | U1 |
| Restart rule text | `test-0000250-req-001-routing-and-restart-rules.sh` | U2, U3 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U1 | none | `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/tests/test-0000313-req-001-driver-setup-stop.sh`, `ravintio-zero/tests/test-0000250-req-002-driver-restart-stop.sh` | 1 | none |
| U2 | none | `ravintio-zero/skills/ravintio-initiative/SKILL.md`, `ravintio-zero/tests/test-0000313-req-002-initiative-skill-setup-stop.sh` | 1 | none |
| U3 | none | `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/component.yml`, `ravintio-zero/tests/test-0000313-req-003-standards-setup-stop.sh` | 1 | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Step 1 ends with a `Restart:` line from the old driver. | The combined line appears one step early. |

## Open Questions

None.
