---
title: "Requirement: REQ-003 - Pack version has its own record"
summary: "Pack version has its own record"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Pack version has its own record

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000393-session-integrity-and-guards
**Source:** US-003
**Priority:** must-have

## User Story

As a consumer, I want resume detection to compare the pack with a `plan/state/` record, so that the product version never raises a pack finding.

## Functional Requirements

- `resume-detect.mjs` compares the `component.yml` pack version with `plan/state/pack-version.md` and never reads `docs/about.md`.
- If the record is absent, it prints no pack version finding.
- If either version is unreadable, it prints `pack version unreadable`.
- The finding reads `pack version differs from plan/state/pack-version.md`.
- The pack update policy and the `about.md` template say `docs/about.md` holds the product version only.
- The orchestrator resume check says who writes the record.

## Acceptance Criteria

- [ ] AC-1: Matching record
  - Given pack `0.37.0`, product `0.4.0`, and a record of `0.37.0`
  - When resume detection runs
  - Then it prints no pack version finding
- [ ] AC-2: Older record
  - Given the same repo with a record of `0.36.0`
  - When resume detection runs
  - Then it prints one pack version finding
- [ ] AC-3: Docs state the split
  - Given the policy and the template
  - When a reader opens them
  - Then both say `docs/about.md` holds the product version only

## Dependencies

- None.
