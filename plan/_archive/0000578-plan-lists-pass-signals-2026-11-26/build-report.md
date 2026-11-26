---
title: "Build report - 0000578-plan-lists-pass-signals"
summary: "Build assessment for the run that made the plan list every path to a pass signal."
---
# Build report - 0000578-plan-lists-pass-signals

Run speed: `fast`.

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) |
|-------|--------|------------|----------------------|
| P0 Discovery | 0 | primary | 0 |
| P1 Plan | 0 | primary | 0 |
| P2 Implement | 0 | primary | 0 |
| P3 Validate and Accept | 0 | primary | 24 |
| P4 Ship | 0 | primary | 0 |

## Parallelism

The run used none. P2 ran four units in sequence. The units were small and touched shared files.

## Self-corrections

None.

## Improvements

- P3: The full suite took 24 minutes. A faster baseline command would cut it (see backlog entry 0000603).

Postmortems: none

Inherited failures:

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
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | primary | 4 | 0 |

Retrospective: none
