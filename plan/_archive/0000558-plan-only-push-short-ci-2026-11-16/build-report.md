---
title: "Build Report - 0000558-plan-only-push-short-ci"
summary: "Phase times, parallelism, and inherited failures for step 14."
---
# Build Report - 0000558-plan-only-push-short-ci

Run speed: fast.

## Phases

| Phase | Agents | Tier | Wall clock |
|-------|--------|------|------------|
| P0 Discovery | 0 | primary | 1 minute |
| P1 Plan | 0 | primary | 1 minute |
| P2 Implement | 0 | primary | 27 minutes |
| P3 Validate and Accept | 1 | primary | 1 minute |
| P4 Ship | 0 | primary | not recorded in whole minutes beyond the CI wait of 316 seconds |

## Parallelism

The run dispatched no parallel batch. The artifact set and the one workflow edit were too small to justify subagent overhead. The docs edit pass used one subagent.

## Self-corrections

None in P3. Four prose-check commit rejections in P0 and P1 each cost one retry. Each was avoidable with a prose check before the commit.

## Improvement suggestions

- P2: the full suite took 26 minutes and dominates the run. Start it earlier.
- P4: the build-log marker script inserts lines after the divider, which breaks later inserts that anchor on the divider.

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 316 (run 43804915688) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
Retrospective: plan/retrospectives/0000558-plan-only-push-short-ci-2026-11-16.md
