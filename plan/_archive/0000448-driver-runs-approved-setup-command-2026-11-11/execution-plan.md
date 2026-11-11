# Execution Plan - Driver runs the approved setup command

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Version:** 0.91.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-setup-command-helper.md](requirements/req-001-setup-command-helper.md) | `setup-command.mjs` reads and checks the command |
| [req-002-driver-runs-setup-command.md](requirements/req-002-driver-runs-setup-command.md) | The driver runs the command at a `Setup:` stop |
| [req-003-standards-and-skill-text.md](requirements/req-003-standards-and-skill-text.md) | Standards and initiative skill text |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | The driver runs no shell and no command outside the allowed form | 0 other commands run | REQ-001 AC-3, REQ-002 AC-2 |
| NFR-002 | Maintainability | The skill-text total stays within its cap | 1720 lines or fewer | `test-0000384-skill-text.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The driver reads the chart from the initiative ref. It calls `setup-command.mjs` at a `Setup:` hit. It then runs `setup.sh` in the root. `sync-installed.mjs` copies `src/ravintio-zero/` to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `initiative-run.mjs` | `test-0000313-req-001-driver-setup-stop.sh`, `test-0000377-req-003-setup-check-after-last-step.sh`, `test-0000250-req-002-driver-restart-stop.sh`, `test-0000379-req-002-003-005-scheduler.sh`, `test-0000446-req-001-drain-after-queue-failure.sh` | U-002 |
| Edit to `roadmap-standards.md` | `test-0000313-req-003-standards-setup-stop.sh`, `test-0000043-req-009-roadmap-resume-and-prefixes.sh`, `test-0000468-req-002-read-the-clock-rule.sh` | U-003 |
| Edit to the initiative skill | `test-0000313-req-002-initiative-skill-setup-stop.sh`, `test-0000205-req-004-initiative-skill.sh`, `test-0000384-skill-text.sh` | U-003 |
| Skill-text budget (edit to `ravintio-initiative/SKILL.md`) | `test-0000384-skill-text.sh` | U-003 |
| New script listed in `component.yml` | `self-description-check.mjs` | U-001 |
| New test file | `test-0000164-req-008` style tests | U-001, U-002, U-003 |
| Backlog entry id | 0000427 | U-001 |
| Skill count (no skill added) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Non-suite file | none found | none |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Fixture-pinned line | none found | none |

## Branch-point reads

The plan read these files at the tip of `origin/initiative/0000360-backlog-sweep` (`55a758ff`) on 2026-11-11.

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/scripts/setup-command.mjs` | new | U-001 |
| `src/ravintio-zero/tests/test-0000448-req-001-setup-command-helper.sh` | new | U-001 |
| `src/ravintio-zero/scripts/initiative-run.mjs` | 6c66f4d5 | U-002 |
| `src/ravintio-zero/tests/test-0000448-req-002-driver-runs-setup-command.sh` | new | U-002 |
| `src/ravintio-zero/standards/roadmap-standards.md` | 6c66f4d5 | U-003 |
| `src/ravintio-zero/skills/ravintio-initiative/SKILL.md` | ae9dfaee | U-003 |
| `src/ravintio-zero/tests/test-0000448-req-003-standards-and-skill-text.sh` | new | U-003 |
| `src/ravintio-zero/component.yml` | 6c66f4d5 | U-001 |
| `docs/architecture-overview.md` | 6c66f4d5 | U-004 |
| `docs/adr/0310-driver-runs-the-approved-setup-command.md` | new | U-004 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | `src/ravintio-zero/scripts/setup-command.mjs`, `src/ravintio-zero/component.yml`, `src/ravintio-zero/tests/test-0000448-req-001-setup-command-helper.sh` | 1 | Later units import the helper | none |
| U-002 | U-001 | `src/ravintio-zero/scripts/initiative-run.mjs`, `src/ravintio-zero/tests/test-0000448-req-002-driver-runs-setup-command.sh` | 2 | The driver imports the helper | none |
| U-003 | U-002 | `src/ravintio-zero/standards/roadmap-standards.md`, `src/ravintio-zero/skills/ravintio-initiative/SKILL.md`, `src/ravintio-zero/tests/test-0000448-req-003-standards-and-skill-text.sh` | 3 | The text describes what U-002 built | none |
| U-004 | U-003 | `docs/architecture-overview.md`, `docs/adr/0310-driver-runs-the-approved-setup-command.md` | 4 | Living docs unit. It records what U-001 to U-003 built | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The main working tree sits on the initiative branch | The driver stops with the `Setup:` line as before |
| A-002 | The row names the command in code font | The helper finds no command and the driver stops |

## Open Questions

None.
