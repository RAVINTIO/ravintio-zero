# Execution Plan - Reply time matches the clock

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000468-reply-time-matches-the-clock
**Version:** 0.83.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-clock-check.md](requirements/req-001-clock-check.md) | The reply hook compares the leading time with the clock and warns past the margin |
| [req-002-read-the-clock-rule.md](requirements/req-002-read-the-clock-rule.md) | Each place that states the reply form tells the step to read `date +%H:%M` |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Reliability | The hook exits 0 on every path | 0 non-zero exits | AC-1 to AC-3 of REQ-001 check the exit code |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

`check-reply-prefix.mjs` reads the local clock, compares it with the leading time, and appends to `plan/.prefix-misses.log`. The source lives in `src/ravintio-zero/`. `sync-installed.mjs` copies it to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U-001, U-002 |
| Edit to `check-reply-prefix.mjs` | `test-0000388-req-001-time-before-prefix.sh`, `test-0000388-req-002-clear-prefix-warning.sh`, `test-0000200-req-003-stop-hook-warns-and-logs.sh`, `test-0000320-req-004-final-reply-prefix.sh`, `test-0000358-req-001-question-status.sh` | U-001 |
| Edit to `roadmap-standards.md` | `test-0000388-req-005-driver-watcher-time.sh` | U-002 |
| Edit to the boot templates | `test-0000029-req-001-003-boot-file-regeneration.sh`, `test-0000200-req-001-002-reply-conventions.sh` | U-002 |
| Edit to `hook-enforcement.md` | `test-0000245-req-001-hook-enforcement-reference.sh` | U-002 |
| Skill-text budget (orchestrator and initiative `SKILL.md`) | `test-0000042-req-008-pack-prose.sh`, `test-0000031-req-003-five-phases.sh` | U-002 |
| Backlog entry id | none found | none |
| Skill count (no skill added) | none found | none |
| Size cap (line count unchanged) | none found | none |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Fixture-pinned line | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Shared resources | Sequential reason |
|------|-----------|--------|-------|------------------|-------------------|
| U-001 | none | `src/ravintio-zero/hooks/enforcement/check-reply-prefix.mjs`, `src/ravintio-zero/tests/test-0000468-req-001-clock-check.sh`, `src/ravintio-zero/tests/test-0000388-req-001-time-before-prefix.sh`, `src/ravintio-zero/tests/test-0000388-req-002-clear-prefix-warning.sh` | 1 | none | - |
| U-002 | none | `src/ravintio-zero/standards/roadmap-standards.md`, `src/ravintio-zero/standards/hook-enforcement.md`, `src/ravintio-zero/skills/ravintio-orchestrator/SKILL.md`, `src/ravintio-zero/skills/ravintio-initiative/SKILL.md`, `src/ravintio-zero/templates/standard-boot.md`, `src/ravintio-zero/templates/codex-boot.md`, `src/ravintio-zero/tests/test-0000468-req-002-read-the-clock-rule.sh` | 1 | none | - |
| U-003 | U-001, U-002 | `docs/architecture-overview.md`, `docs/decisions-index.md`, `docs/adr/0305-reply-time-clock-check.md` | 2 | none | Living docs unit. It records what U-001 and U-002 built |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The hook shares the session's clock | A warning on a correct time |

## Open Questions

None.
