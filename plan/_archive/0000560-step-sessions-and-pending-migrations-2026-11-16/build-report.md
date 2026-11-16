# Build report - 0000560

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 44 |
| P3 Validate and Accept | 0 | primary | 22 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

The baseline run started in the background at P0. The units ran inline, because the feature has one requirement.

## Self-corrections

The commit hook rejected passive phrases in four prose records. The agent reworded each one. Each fix was avoidable. The `block-forced-add` hook also blocked two commands that passed a variable to `git add`. The agent reran them with literal paths.

## Improvements

- P2: the entry was mostly covered before the step began. A check of the entry against shipped features at charting would have shortened the step.
- P2: the P0 and P1 records each need a prose-check pass. A template with active-voice sentences would avoid the rework.

## Postmortems

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

These match the chart's known baseline failures. No backlog entry is offered for them.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |

Retrospective: none
