---
title: "Build Report - 0000485-adr-number-collision"
summary: "Phases, parallelism, self-corrections, and the workflow metrics of the run."
---
# Build Report - 0000485-adr-number-collision

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Model tier |
|-------|----------------------|--------|------------|
| P0 Discovery | 1 | 0 | primary |
| P1 Plan | 1 | 0 | primary |
| P2 Implement | 4 | 0 | inline |
| P3 Validate and Accept | 36 | 1 | primary |
| P4 Ship | 1 | 0 | primary |

## Parallelism

None used. The three units share one module and run in order.

## Self-corrections

One. The module skipped a backlog entry that the PR renamed. It was avoidable with a test world for a renamed file (`plan/postmortems/2026-11-11-module-missed-a-renamed-entry.md`).

## Improvement suggestions

- P1: when a unit reads a git diff, list a test world for each of add, rename, and delete (backlog entry 0000516).
- P3: start the baseline run at P0 as before, since the suite takes about 20 minutes.

Postmortems: plan/postmortems/2026-11-11-module-missed-a-renamed-entry.md

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Retrospective: plan/retrospectives/0000485-adr-number-collision-2026-11-11.md

## Workflow governance

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-002) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 374 (run 42946528064) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 0 | 1 |
