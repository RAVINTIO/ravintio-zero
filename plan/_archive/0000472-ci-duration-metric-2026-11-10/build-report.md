---
title: "Build Report - 0000472-ci-duration-metric"
summary: "Phases, parallelism, self-corrections, and the workflow metrics of the run."
---
# Build Report - 0000472-ci-duration-metric

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Model tier |
|-------|----------------------|--------|------------|
| P0 Discovery | 1 | 0 | primary |
| P1 Plan | 1 | 0 | primary |
| P2 Implement | 1 | 0 | inline |
| P3 Validate and Accept | 49 | 0 | primary |
| P4 Ship | 1 | 0 | primary |

## Parallelism

None used. Two small units shared one design, so they ran inline.

## Self-corrections

None.

## Improvement suggestions

- P3: the full suite in a clean clone runs for about 35 minutes, and the baseline run takes the same. Start both at P0.

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Retrospective: plan/retrospectives/0000472-ci-duration-metric-2026-11-10.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 302 (run 42917291732) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 2 | 0 |
