---
title: "Build Report - 0000450-coordinator-status-view"
summary: "Phases, parallelism, self-corrections, and the workflow metrics of the run."
---
# Build Report - 0000450-coordinator-status-view

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Model tier |
|-------|----------------------|--------|------------|
| P0 Discovery | 1 | 0 | primary |
| P1 Plan | 1 | 0 | primary |
| P2 Implement | 43 | 3 | primary |
| P3 Validate and Accept | 25 | 0 | primary |
| P4 Ship | 18 | 0 | primary |

## Parallelism

P2 ran U-1, U-2, and U-3 as three parallel subagents on the primary tier. U-4 and U-5 ran inline in order. Most of the P2 wall clock was the full suite run.

## Self-corrections

Two. Both were avoidable.

- The status script printed stop text with control characters. A test world with an escape character in a log line would have caught it at P2.
- The manual base merge left the backlog index stale and CI failed on it. Backlog entry 0000517 records the gap.

## Improvement suggestions

- P2: state "failing test first, then the code" in each subagent brief and ask for the red run in the report. Two of three agents wrote the code first.
- P4: after a manual base merge, rebuild the backlog index before the push (backlog entry 0000517).

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Retrospective: plan/retrospectives/0000450-coordinator-status-view-2026-11-11.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 348 (run 42958405294) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
| unclassified | unclassified | 3 | 0 |
