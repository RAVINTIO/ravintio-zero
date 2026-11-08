# Execution Plan - short subject for the queue's base merge

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000405-queue-merge-subject
**Version:** 0.62.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-short-base-merge-subject.md](requirements/req-001-short-base-merge-subject.md) | The queue's base merge uses a short subject that the `commit-msg` hook accepts |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Compliance | The base merge subject fits the commit standard | 72 characters or fewer | `test-0000405-req-001-short-base-merge-subject.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

The change edits one script in one component, `ravintio-zero`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `merge-queue.mjs` | `test-0000378-req-002-003-merge-queue.sh`, `test-0000043-req-005-roadmap-advance.sh`, `test-0000379-req-004-position.sh` | U-001 |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Backlog entry id (none pulled in) | none found | none |
| Workflow job or step edit (none) | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/scripts/merge-queue.mjs`, `ravintio-zero/tests/test-0000405-req-001-short-base-merge-subject.sh` | 1 | One requirement and a one-line fix, so a single unit in one context |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Every `Feature id` starts with 7 digits | The subject has no id prefix |

## Open Questions

None.
