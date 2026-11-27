---
title: "Build report - 0000545-clear-feature-id-at-ship"
summary: "Phase times, parallelism, and self-corrections for step 1 of initiative 0000544."
status: "closed"
---
# Build report - 0000545-clear-feature-id-at-ship

**Run speed:** fast

## Phases

| Phase | Agents | Tier | Wall clock |
|-------|--------|------|------------|
| P0 Discovery | 0 | primary | 1 minute |
| P1 Plan | 0 | primary | 1 minute |
| P2 Implement | 0 | primary | 10 minutes |
| P3 Validate and Accept | 0 | primary | 1161 minutes, including a pause |
| P4 Ship | 0 | primary | 1 minute at the open PR, closing push after CI |

## Parallelism

No phase dispatched a subagent. Two P2 units ran inline in one batch.

## Self-corrections

None.

## Improvements

- P3: run the full suite in the background with a long limit at the start, because the foreground limit stopped the first run.
- P4: merge the base before the PR, because the ADR number collided.

## Postmortems

Postmortems: none

## Inherited failures

Three suites fail only in a clean clone: `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. Backlog entry 0000585 files them.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 334 (run 43712526680) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
| unclassified | unclassified | 2 | 0 |

Retrospective: plan/retrospectives/0000545-clear-feature-id-at-ship-2026-11-15.md
