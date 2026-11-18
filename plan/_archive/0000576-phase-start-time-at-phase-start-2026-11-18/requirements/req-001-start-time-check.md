---
title: "Requirement: REQ-001 - Start-time check"
summary: "Check 10 of build-log-check.mjs fails a phase block whose Start follows its first artifact commit."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Start-time check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000576-phase-start-time-at-phase-start
**Source:** US-001
**Priority:** must-have

## User Story

As the ship phase, I fail a phase block whose `Start` follows its first artifact commit, so that a late block write fails ship.

## Functional Requirements
- Check 10 finds the commit that added the build log. It then lists later commits that touch each phase's artifact paths.
- P1 paths are `requirements/`, `scope.md`, `execution-plan.md`, `risk-register.md`, `story-map.md`, and `domain-glossary.md` under `plan/current/`.
- P2 paths are any path outside `plan/` and `docs/`.
- P3 paths are `verification-report.md`, `security-report.md`, and `acceptance-evidence.md` under `plan/current/`.
- P4 paths are `build-report.md` under `plan/current/`.
- The check fails a phase when its `Start` is more than one minute later than the oldest listed commit. The finding names the phase.
- The check skips a phase that has no committed artifact, a skipped phase, an unreadable `Start`, and a log outside git.

## Acceptance Criteria
- [ ] AC-1: late Start fails
  - Given a git repo whose log adds a P1 block with a Start after the first P1 artifact commit
  - When the check runs
  - Then it exits 1 and the finding names P1
- [ ] AC-2: on-time Start passes
  - Given a block whose Start is at or before the first artifact commit
  - When the check runs
  - Then it reports no finding for that phase
- [ ] AC-3: nothing to compare skips
  - Given a log outside git, or a phase with no committed artifact
  - When the check runs
  - Then it reports no finding for check 10

## Dependencies
- Check 6 shares the one-minute margin.
