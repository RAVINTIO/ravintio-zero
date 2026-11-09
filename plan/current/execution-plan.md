# Execution Plan - the merge queue waits for GitHub before it merges

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000411-queue-waits
**Version:** 0.72.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-queue-waits-for-github.md](requirements/req-001-queue-waits-for-github.md) | The queue waits for the pushed head, CI, and mergeability before it merges, and retries a transient merge failure once |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Reliability | The queue stops with a named error when a wait passes its limit | 20 minutes by default | `test-0000411-req-001-queue-waits.sh` with a short limit |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The change edits one script in one component, `ravintio-zero`. It adds `gh pr view --json headRefOid,mergeable,mergeStateStatus` calls.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `merge-queue.mjs` | `test-0000378-req-002-003-merge-queue.sh`, `test-0000405-req-001-short-base-merge-subject.sh`, `test-0000043-req-005-roadmap-advance.sh`, `test-0000379-req-004-position.sh` | U-001 |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Backlog entry id (none pulled in) | none found | none |
| Workflow job or step edit (none) | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/scripts/merge-queue.mjs`, `ravintio-zero/tests/test-0000411-req-001-queue-waits.sh`, the fake `gh` in two suites | 1 | One requirement in one script, so a single unit in one context |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | `gh pr view` reports the mergeability that `gh pr merge` uses | The retry covers the gap |

## Open Questions

None.
