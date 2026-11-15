# Execution Plan - A failed queue run can leave written files in the queue worktree

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000546-queue-failure-leaves-dirty-files
**Version:** 0.126.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| none | plan | none |

## Functional Requirements Directory

Functional requirements are split into individual files, one user story per file, at `plan/current/requirements/`.

| File | Requirement |
|------|------------|
| [req-001-restore-written-files.md](requirements/req-001-restore-written-files.md) | A failed run restores the files it wrote before the commit lands |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Maintainability | Both copies of the script match | 0 differing bytes | `diff` of the two files |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature adds no data.

## Component Interactions

```mermaid
flowchart LR
    A[driver] -->|run| B[merge-queue]
    B -->|write, commit| C[queue worktree]
    B -->|restore on failure| C
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000477 | none found | U1 |
| Pack file edit | test-0000493-req-004-handoff-text.sh | U1 |
| New test file | test-0000164-req-008-no-process-substitution-loops.sh | U2 |
| Output order | test-0000446-req-001-drain-after-queue-failure.sh, test-0000450-req-003-driver-queue-line.sh, test-0000379-req-004-queue-handoff.sh | U1 |
| Fixture-pinned line | none found | U1 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| src/ravintio-zero/scripts/merge-queue.mjs | da687860 | U1 |
| ravintio-zero/scripts/merge-queue.mjs | da687860 | U1 |
| ravintio-zero/tests/test-0000546-req-001-restore-written-files.sh | new | U2 |
| docs/architecture-overview.md | 152adeba | U3 |
| docs/about.md | 152adeba | U3 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U2 | none | ravintio-zero/tests/test-0000546-req-001-restore-written-files.sh | 1 | The test goes first so it can fail | none |
| U1 | U2 | src/ravintio-zero/scripts/merge-queue.mjs, ravintio-zero/scripts/merge-queue.mjs | 2 | The change makes the test pass | none |
| U3 | U1 | docs/architecture-overview.md, docs/about.md | 3 | Living docs follow the code | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | The queue writes only the chart and the files in `version-files.txt`. | The restore leaves a written file dirty. |

## Open Questions

None.
