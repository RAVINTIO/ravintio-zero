# Build report - 0000572

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 2 |
| P3 Validate and Accept | 0 | primary | 44 |
| P4 Ship | 0 | primary | 0 |

## Parallelism

The baseline run ran in the background while the agent planned and built. The units ran inline. A fast batch of subagents would have cost more than the four small units.

## Self-corrections

The prose hook rejected one 26-word user story sentence, and the agent shortened it. The fix was avoidable. A hook rejected two commands that used a `cd` or a variable in `git add`, and the agent reran each with literal paths.

## Improvements

- P0: the baseline run took about 25 minutes against the 13 minutes the start actions state. Update the figure or shard the run.
- P3: the full suite took about 24 minutes. A fast mode that shards the clean-clone run would save P3 time.

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
| Longest CI run (seconds) | 445 (run 45778869757) | 420 | breach |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | primary | 4 | 0 |

Retrospective: plan/retrospectives/0000572-tests-share-a-repo-root-helper-2026-11-26.md
