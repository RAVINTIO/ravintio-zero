# Execution Plan - Driver reads blocks from the reply

> Every requirement traces to a user story.

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000440-driver-reads-reply-blocks
**Version:** 0.78.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-reply-block.md](requirements/req-001-reply-block.md) | The driver reads blocks from the step's reply |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | The driver treats reply text as data | 0 shell or path uses of reply text | Test with shell characters in the reply |
| NFR-002 | Reliability | A stop line stays bounded | At most 500 characters | Existing `MAX_LINE` |

## API Summary

No API changes.

## Data Model Summary

No data changes.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000413 | `test-0000377-req-002-question-stop.sh` (no pin on the entry text) | U-003 |
| Edited pack line (continue prompt) | none found | U-001 |
| New test file | repo-wide style tests such as `test-0000164-req-008` | U-002 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-001 | none | ravintio-zero/scripts/initiative-run.mjs, ravintio-zero/tests/test-0000440-req-001-reply-block.sh | 1 | The test drives the code | none |
| U-002 | U-001 | ravintio-zero/standards/roadmap-standards.md, docs/ | 2 | Documents what U-001 built | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The final `result` event holds the reply in a string field `result`. | The driver misses the block and behaves as before. |

## Open Questions

None.
