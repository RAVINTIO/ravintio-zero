# Execution Plan - Parallel steps reserve distinct ids

> Every requirement traces to a user story.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Version:** 0.92.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-renumber-colliding-adr.md](requirements/req-001-renumber-colliding-adr.md) | Renumber a PR ADR whose number the base holds |
| [req-002-renumber-colliding-backlog-entry-and-queue-call.md](requirements/req-002-renumber-colliding-backlog-entry-and-queue-call.md) | Renumber a PR backlog entry, and run the module in the queue |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Safety | A run with no collision changes nothing | 0 changed files and 0 new commits | the module test |
| NFR-002 | Security | The module treats file text as data | git calls use argument arrays, 0 shell strings | code review |

## API Summary

No API.

## Data Model Summary

No data store.

## Component Interactions

```mermaid
flowchart LR
    Q[merge-queue.mjs] -->|after base merge| M[id-collisions.mjs]
    M -->|rebuild| B[backlog-index.mjs]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000479 | none found | U-1 |
| New test file | repo-wide style tests, such as `test-0000164-req-008` | U-1 |
| Reference file edit | none found, the change edits no `references/` file | U-2 |
| Fixture-pinned line | none found for the `roadmap-standards.md` merge queue lines | U-2 |
| Non-suite file | none, the change adds only `test-*.sh` suites | U-1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/scripts/id-collisions.mjs | new | U-1 |
| src/ravintio-zero/scripts/merge-queue.mjs | b75d165f | U-2 |
| src/ravintio-zero/standards/roadmap-standards.md | 6c66f4d5 | U-2 |
| docs/decisions-index.md | 6c66f4d5 | U-3 |
| docs/adr/0312-renumber-colliding-ids-in-the-merge-queue.md | new | U-3 |

## Concurrency plan

U-1 is the module and its suite. U-2 is the queue call, the standards text, and its suite. U-3 is the living docs.

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U-1 | none | src/ravintio-zero/scripts/id-collisions.mjs, src/ravintio-zero/tests/test-0000485-req-001-id-collisions.sh | 1 | the queue call needs the module | none |
| U-2 | U-1 | src/ravintio-zero/scripts/merge-queue.mjs, src/ravintio-zero/standards/roadmap-standards.md, src/ravintio-zero/tests/test-0000485-req-002-queue-renumbers.sh | 2 | depends on U-1 | none |
| U-3 | U-2 | docs/, plan/changelog/ | 3 | depends on the final behaviour | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | A PR's references to its own colliding number sit in files the PR changed. | A stale reference stays. |
| A-002 | A PR cannot cite a base ADR that the base added after the PR branched. | The module renumbers a reference it should keep. |

## Open Questions

None.
