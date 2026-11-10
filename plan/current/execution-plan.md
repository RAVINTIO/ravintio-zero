# Execution Plan - queue failure recovery

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Version:** 0.78.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-revert-stale-version-commit.md](requirements/req-001-revert-stale-version-commit.md) | A rerun reverts a stale set-version commit before it merges the base |
| [req-002-detach-queue-worktree.md](requirements/req-002-detach-queue-worktree.md) | The queue detaches its worktree after every run |
| [req-003-restart-test.md](requirements/req-003-restart-test.md) | One suite covers the failure, the base change, and the restart |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Safety | The queue never rewrites pushed history | 0 force-pushes | The new suite compares the remote branch history before and after |
| NFR-002 | Compatibility | A run with no earlier set-version commit takes the existing path | 0 added commits | The 0000378 suite still passes |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

`merge-queue.mjs` runs `git` and `gh` through argument arrays. The driver runs it in the queue worktree at `plan/.initiative-worktrees/queue`. The driver restarts a step session in a new worktree on the step branch. The source lives in `src/ravintio-zero/`, and `sync-installed.mjs` copies it to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `merge-queue.mjs` | `test-0000378-req-002-003-merge-queue.sh`, `test-0000379-req-004-position.sh`, `test-0000379-req-004-queue-handoff.sh`, `test-0000392-req-003-queue-waits-for-ci.sh`, `test-0000392-req-004-pr-title-form.sh`, `test-0000405-req-001-short-base-merge-subject.sh`, `test-0000411-req-001-queue-waits.sh`, `test-0000420-req-001-optional-version-files.sh`, `test-0000043-req-005-roadmap-advance.sh` | U-001 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U-002 |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Backlog entry id (entry 0000429 pulled in) | none found | none |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Non-suite file (none) | none found | none |
| Fixture-pinned line (no pack line edited) | none found | none |

## Concurrency plan

Units in one batch run at the same time. A unit alone in its batch gives its reason. See the [guide](execution-plan-guide.md).

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | `src/ravintio-zero/scripts/merge-queue.mjs` | 1 | REQ-001 and REQ-002 edit one function in one file | none |
| U-002 | U-001 | `src/ravintio-zero/tests/test-0000454-req-001-queue-failure-recovery.sh` | 2 | The suite needs the script change to pass | none |
| U-003 | U-002 | `docs/architecture-overview.md`, `docs/decisions-index.md`, `docs/adr/0298-queue-reverts-stale-version-commit.md`, `plan/changelog/0000454-queue-failure-recovery-2026-11-10.md`, `ravintio-zero/` (synced copy) | 3 | The docs describe the finished behaviour | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The queue worktree belongs to the queue | A detach drops a branch that a person had open there |
| A-002 | A set-version commit subject matches `chore({id7}): set version {v} for step {n}` | The queue finds no commit to revert and the conflict returns |

## Open Questions

None.
