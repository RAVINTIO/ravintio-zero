# Build report - 0000351-step-titles-and-history-shape

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock | Parallelism |
|-------|--------|------|-----------|-------------|
| P0 | 0 | primary | 1 min | none |
| P1 | 0 | primary | 0 min | none, artifacts share files |
| P2 | 2 | sonnet units | 25 min | 1 batch of 2 units |
| P3 | 0 | primary | 0 min | none |
| P4 | 0 | primary | in progress at write time | none |

## Self-corrections

- 1: a start-actions line changed in place and failed a frozen-line test. Avoidable, because the test impact scan had no cause for reference files.

## Improvements

- P1: add reference files to the test impact scan (entry 0000361).

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000351-step-titles-and-history-shape-2026-11-06.md
