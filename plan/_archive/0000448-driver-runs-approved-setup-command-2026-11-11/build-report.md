---
title: "Build Report - 0000448-driver-runs-approved-setup-command"
summary: "Phases, parallelism, self-corrections, and the workflow metrics of the run."
---
# Build Report - 0000448-driver-runs-approved-setup-command

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Model tier |
|-------|----------------------|--------|------------|
| P0 Discovery | 1 | 0 | primary |
| P1 Plan | 2 | 0 | primary |
| P2 Implement | 5 | 0 | inline |
| P3 Validate and Accept | 18 | 0 | primary |
| P4 Ship | 1 | 0 | primary |

## Parallelism

P3 ran the full suite in four shards at once. P0 to P2 ran inline, because three small units share one driver file.

## Self-corrections

None.

## Improvement suggestions

- P4: the CI run took 472 seconds against the 420-second target. The Windows shards took 5m19s at most. Rebalancing the Windows shards would cut the wall clock.
- P0: a step session should skip pending migration 0009. Backlog entry 0000513 records the change.

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Retrospective: plan/retrospectives/0000448-driver-runs-approved-setup-command-2026-11-11.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 472 (run 42939448651) | 420 | breach |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 3 | 0 |
