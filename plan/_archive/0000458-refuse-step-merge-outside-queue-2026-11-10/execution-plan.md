# Execution Plan - refuse a step merge outside the queue

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000458-refuse-step-merge-outside-queue
**Version:** 0.80.1
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-refuse-step-merge.md](requirements/req-001-refuse-step-merge.md) | Refuse a merge under `RAVINTIO_INITIATIVE_QUEUE=1`, keep the queue path, and name the queue in the docs |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | The change only narrows what passes the guard | 0 newly allowed commands | `test-0000318-req-004-merge-guard-pinned.sh` and the new suite |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The driver sets `RAVINTIO_INITIATIVE_QUEUE=1` for the step session. The `PreToolUse` hook inherits it and `merge-guard.mjs` reads it. The queue runs as a driver process that no hook sees. The source lives in `src/ravintio-zero/`, and `sync-installed.mjs` copies it to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `merge-guard.mjs` | `test-0000043-req-006-merge-guard-hook.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, `test-0000245-req-001-hook-enforcement-reference.sh`, `test-0000197-req-001-block-message.sh`, `test-0000248-req-001-plain-merge-command.sh` | U-001 |
| Edit to carve-out text | `test-0000043-req-010-merge-carve-out-governance.sh`, `test-0000252-req-001-guard-widening-rule.sh` | U-001 |
| Edit to the ship skill and the invocation reference | `test-0000245-req-003-004-repo-skills-and-size-cap.sh`, `test-0000380-req-002-rule-anchors.sh` | U-001 |
| New test file | `test-0000458-req-001-refuse-step-merge.sh` | U-001 |
| Non-suite file | none found | none |
| Skill count (no skill added) | none found | none |
| Backlog entry id | 0000431 | U-001 |
| Workflow job or step edit (none) | none found | none |
| Fixture-pinned line | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `src/ravintio-zero/hooks/enforcement/merge-guard.mjs`, `src/ravintio-zero/tests/test-0000458-req-001-refuse-step-merge.sh`, `src/ravintio-zero/standards/roadmap-standards.md`, `src/ravintio-zero/skills/ravintio-ship/SKILL.md`, `src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-phase-invocation.md`, `src/ravintio-zero/standards/hook-enforcement.md` | 1 | One requirement across a hook and its text, so a single unit |
| U-002 | U-001 | `docs/architecture-overview.md`, `docs/adr/0301-refuse-step-merge-outside-queue.md`, `docs/decisions-index.md` | 2 | Living docs unit. It records what U-001 built |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Claude Code passes its environment to hook processes | The guard allows the merge as it does today |

## Open Questions

None.
