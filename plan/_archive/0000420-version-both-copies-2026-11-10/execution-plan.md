# Execution Plan - the version bump writes both pack copies

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000420-version-both-copies
**Version:** 0.76.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-optional-version-files.md](requirements/req-001-optional-version-files.md) | Optional list entries, the source copy in the list, and the queue stages present files only |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Compatibility | A repo with no `src/` sets and checks versions as before | 100% of required files | `test-0000420-req-001-optional-version-files.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

`merge-queue.mjs` reads the list through `version-files.mjs`. The source lives in `src/ravintio-zero/`, and `sync-installed.mjs` copies it to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `version-files.mjs` and the list | `test-0000378-req-001-version-files.sh` | U-001 |
| Edit to `merge-queue.mjs` | `test-0000378-req-002-003-merge-queue.sh`, `test-0000392-req-003-queue-waits-for-ci.sh`, `test-0000405-req-001-short-base-merge-subject.sh`, `test-0000411-req-001-queue-waits.sh` | U-001 |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Backlog entry id (none pulled in) | none found | none |
| Workflow job or step edit (none) | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `src/ravintio-zero/scripts/version-files.mjs`, `src/ravintio-zero/scripts/merge-queue.mjs`, `src/ravintio-zero/version-files.txt`, `src/ravintio-zero/tests/test-0000420-req-001-optional-version-files.sh`, `docs/architecture-overview.md` | 1 | One requirement across two scripts that share the list, so a single unit |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Only the pack repo has `src/ravintio-zero/` | A consumer with that folder gets the version there too |

## Open Questions

None.
