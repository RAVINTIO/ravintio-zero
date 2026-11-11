# Execution Plan - Regenerate shared files after every base merge

> Every requirement traces to a user story or acceptance criterion.

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000481-regenerate-after-every-merge
**Version:** 0.92.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| ravintio-implement | plan | TDD loop for REQ-001 |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-regenerate-after-merge.md](requirements/req-001-regenerate-after-merge.md) | The queue regenerates shared files after every base merge |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | Git calls take argument arrays and file text is data | 0 shell-interpolated calls | Code review at P3 |

## API Summary

None. The feature has no API.

## Data Model Summary

None. The feature changes no stored data.

## Component Interactions

```mermaid
flowchart LR
    A[merge-queue.mjs] -->|calls| B[shared-files.mjs]
    B -->|runs| C[backlog-index.mjs]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000482 | none found | U-1 |
| Edit to `shared-files.mjs` and `merge-queue.mjs` | `test-0000456-req-001-shared-files.sh`, `test-0000456-req-001-queue-resolves.sh`, `test-0000464-req-001-002-queue-branches.sh`, `test-0000456-req-002-overlap-check.sh` | U-1 |
| New test file | repo-wide style tests such as `test-0000164-req-008` | U-1 |
| Edit to `roadmap-standards.md` | none found | U-2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/scripts/shared-files.mjs | fdc0dea9 | U-1 |
| src/ravintio-zero/scripts/merge-queue.mjs | b75d165f | U-1 |
| src/ravintio-zero/standards/roadmap-standards.md | 6c66f4d5 | U-2 |
| src/ravintio-zero/tests/test-0000481-req-001-regenerate.sh | new | U-1 |
| src/ravintio-zero/tests/test-0000481-req-001-queue-regenerates.sh | new | U-1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-1 | none | src/ravintio-zero/scripts/shared-files.mjs, src/ravintio-zero/scripts/merge-queue.mjs, src/ravintio-zero/tests/test-0000481-req-001-regenerate.sh, src/ravintio-zero/tests/test-0000481-req-001-queue-regenerates.sh | 1 | Too small to split. One script change with its test. | none |
| U-2 | none | src/ravintio-zero/standards/roadmap-standards.md, docs/architecture-overview.md, docs/decisions-index.md | 1 | none | none |
| U-3 | U-1, U-2 | ravintio-zero/ (sync-installed refresh) | 2 | Copies the source to the installed copy after both units | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | `backlog-index.mjs` is deterministic on a fixed set of entries | The queue commits on every run |

## Open Questions

None.
