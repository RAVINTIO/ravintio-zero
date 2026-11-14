# Execution Plan - Step base merge regenerates the backlog index

> Every requirement traces to a user story.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000547-step-merge-regenerates-index
**Version:** 0.115.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-rebuild-rule-in-i-d-advance.md](requirements/req-001-rebuild-rule-in-i-d-advance.md) | I-D Advance tells a step to rebuild the backlog index after a manual base merge and names the failing CI check |
| [req-002-standards-test-checks-the-rule.md](requirements/req-002-standards-test-checks-the-rule.md) | A standards test checks the rule |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | The rule adds a short block to `### I-D Advance`. | 4 lines or fewer | `git diff --stat` on the standards file |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature adds no data.

## Component Interactions

```mermaid
flowchart LR
    A[Step session] -->|manual base merge| B[backlog-index.mjs]
    B -->|index committed| C[CI: Check the backlog index]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Mirrored tree | `test-0000493-req-004-handoff-text.sh` needs `src/ravintio-zero/` to match `ravintio-zero/`. | U-1, U-2 |
| Pinned I-D Advance text | `test-0000043-req-005-roadmap-advance.sh` and `test-0000452-req-001-archive-after-ci.sh` read the section. The edit keeps every pinned phrase. | U-1 |
| Backlog entry id | none found | none |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U-2 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/standards/roadmap-standards.md` | 7c03f680 | U-1 |
| `ravintio-zero/standards/roadmap-standards.md` | 7c03f680 | U-1 |
| `src/ravintio-zero/tests/test-0000547-req-001-002-index-rebuild-rule.sh` | new | U-2 |
| `ravintio-zero/tests/test-0000547-req-001-002-index-rebuild-rule.sh` | new | U-2 |
| `docs/decisions-index.md` | 7c03f680 | U-3 |
| `docs/architecture-overview.md` | 7c03f680 | U-3 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-2 | none | `src/ravintio-zero/tests/test-0000547-req-001-002-index-rebuild-rule.sh`, `ravintio-zero/tests/test-0000547-req-001-002-index-rebuild-rule.sh` | 1 | Red phase runs first and alone | none |
| U-1 | U-2 | `src/ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/standards/roadmap-standards.md` | 2 | One rule text in one file | none |
| U-3 | U-1 | `docs/decisions-index.md`, `docs/architecture-overview.md` | 3 | Living docs follow the code edits | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | A step session reads I-D Advance before it merges the base branch by hand. | The step still fails CI once. |

## Open Questions

None.
