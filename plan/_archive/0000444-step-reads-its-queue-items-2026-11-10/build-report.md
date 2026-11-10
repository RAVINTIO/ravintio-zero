---
title: "Build Report - 0000444-step-reads-its-queue-items"
summary: "Agent counts, tiers, wall clock, and improvements for the run."
---
# Build Report - 0000444-step-reads-its-queue-items

Run speed: standard.

## Phases

| Phase | Agents | Tier | Wall clock (minutes) | Parallel batches |
|-------|--------|------|----------------------|------------------|
| P0 Discovery | 0 | primary | 1 | 0 |
| P1 Plan | 0 | primary | 1 | 0 |
| P2 Implement | 0 | primary | 16 | 0 |
| P3 Validate and Accept | 0 | primary | 1 | 0 |
| P4 Ship | 0 | primary | see build log | 0 |

## Parallelism

None used. Each unit is small, and U-002 depends on U-001. The full suite ran in 4 shards, as the chart decision for steps 25 to 41 sets.

## Self-corrections

One. CodeQL flagged an escape that missed the backslash. The fix was avoidable: the P3 review should have rejected a single-character escape on data that reaches a pattern.

## Improvement suggestions

- P0: the discovery commit hook rejects a sentence of 26 words. Check sentence length before the first commit.
- P3: run a local scan for single-character `replace` escapes that feed a `RegExp`.

## Postmortems

- `plan/postmortems/2026-11-10-incomplete-escape-in-queue-helper.md`

## Inherited failures

Inherited failures: none. The baseline lists two suites. Both passed in the step worktree.

Retrospective: none. A step session writes no retrospective record here, and a missing one never blocks ship.
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
| unclassified | unclassified | 1 | 1 |
