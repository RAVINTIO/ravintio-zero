---
title: "Build Report - 0000483-mergeability-before-ci-wait"
summary: "Phases, parallelism, self-corrections, and the workflow metrics of the run."
---
# Build Report - 0000483-mergeability-before-ci-wait

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Model tier |
|-------|----------------------|--------|------------|
| P0 Discovery | 1 | 0 | primary |
| P1 Plan | 1 | 0 | primary |
| P2 Implement | 1 | 0 | inline |
| P3 Validate and Accept | 1 | 0 | primary |
| P4 Ship | 1 | 0 | primary |

## Parallelism

None used. Two small units shared one design, so they ran inline.

## Self-corrections

None.

## Improvement suggestions

- P4: the step's own PR conflicted with the initiative branch, the case this feature guards against. The rule now sits in the step text, so the next step reads it before the poll.
- P4: ADR 0310 collided with step 28's ADR 0310. The step renumbered it. Step 44 covers distinct ids for parallel steps.

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Retrospective: plan/retrospectives/0000483-mergeability-before-ci-wait-2026-11-11.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 378 (run 42942228664) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 2 | 0 |
