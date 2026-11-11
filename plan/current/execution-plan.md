# Execution Plan - Check mergeability before a CI wait

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000483-mergeability-before-ci-wait
**Version:** 0.91.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-queue-stops-on-conflict-or-absent-checks.md](requirements/req-001-queue-stops-on-conflict-or-absent-checks.md) | The queue stops on a conflict or absent checks |
| [req-002-step-reads-mergeability-before-the-ci-poll.md](requirements/req-002-step-reads-mergeability-before-the-ci-poll.md) | The step reads mergeability before the CI poll |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Maintainability | The skill-text total stays within its cap | 1720 lines or fewer | `test-0000384-skill-text.sh` |
| NFR-002 | Reliability | A conflicting PR stops the queue within one poll | one poll interval | REQ-001 AC-1 |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

`merge-queue.mjs` calls `gh pr view --json mergeable` while it waits for checks. The roadmap standards and the ship skill tell a step to read the same value before its poll. `sync-installed.mjs` copies `src/ravintio-zero/` to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `merge-queue.mjs` | `test-0000378-req-002-003-merge-queue.sh`, `test-0000392-req-003-queue-waits-for-ci.sh`, `test-0000411-req-001-queue-waits.sh`, `test-0000405-req-001-short-base-merge-subject.sh`, `test-0000454-req-001-queue-failure-recovery.sh`, `test-0000456-req-001-queue-resolves.sh`, `test-0000464-req-001-002-queue-branches.sh`, `test-0000420-req-001-optional-version-files.sh` | U-001 |
| Edit to `roadmap-standards.md` | `test-0000043-req-005-roadmap-advance.sh`, `test-0000043-req-009-roadmap-resume-and-prefixes.sh` | U-002 |
| Skill-text budget (edit to `ravintio-ship/SKILL.md`) | `test-0000384-skill-text.sh` | U-002 |
| New test file | `test-0000164-req-008` style tests | U-001, U-002 |
| Backlog entry id | 0000484 | U-001 |
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
| `src/ravintio-zero/scripts/merge-queue.mjs` | b75d165f | U-001 |
| `src/ravintio-zero/tests/test-0000483-req-001-queue-stops-on-conflict.sh` | new | U-001 |
| `src/ravintio-zero/standards/roadmap-standards.md` | 6c66f4d5 | U-002 |
| `src/ravintio-zero/skills/ravintio-ship/SKILL.md` | e908187e | U-002 |
| `src/ravintio-zero/tests/test-0000483-req-002-step-reads-mergeability.sh` | new | U-002 |
| `docs/architecture-overview.md` | 6c66f4d5 | U-003 |
| `docs/adr/0310-stop-ci-waits-on-a-conflicting-pr.md` | new | U-003 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | `src/ravintio-zero/scripts/merge-queue.mjs`, `src/ravintio-zero/tests/test-0000483-req-001-queue-stops-on-conflict.sh` | 1 | none | none |
| U-002 | none | `src/ravintio-zero/standards/roadmap-standards.md`, `src/ravintio-zero/skills/ravintio-ship/SKILL.md`, `src/ravintio-zero/tests/test-0000483-req-002-step-reads-mergeability.sh` | 1 | none | none |
| U-003 | U-001, U-002 | `docs/architecture-overview.md`, `docs/adr/0310-stop-ci-waits-on-a-conflicting-pr.md` | 2 | Living docs unit. It records what U-001 and U-002 built | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | GitHub reports `CONFLICTING` for a conflicting PR | The no-checks timeout still stops the wait |
| A-002 | `UNKNOWN` is transient | The no-checks timeout stops the wait |

## Open Questions

None.
