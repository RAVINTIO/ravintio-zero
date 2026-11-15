# Build report - 0000566

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 1 |
| P3 Validate and Accept | 0 | primary | 50 |
| P4 Ship | 0 | primary | 0 |

## Parallelism

None used. Every unit was a text change, so the units ran inline.

## Self-corrections

None.

## Improvements

- P3: a wait loop that uses `pgrep -f` on its own command line matches itself and never ends. Use the end marker or the process id.

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
| content | inline | 1 | 0 |
| unclassified | unclassified | 2 | 0 |
Retrospective: plan/retrospectives/0000566-test-impact-for-history-moves-2026-11-15.md
