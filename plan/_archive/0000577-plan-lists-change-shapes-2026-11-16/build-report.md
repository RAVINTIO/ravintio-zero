# Build report - 0000577

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 0 |
| P2 Implement | 0 | primary | 34 |
| P3 Validate and Accept | 0 | primary | 0 |
| P4 Ship | 0 | primary | 0 |

## Parallelism

The baseline run and the post-change run ran side by side in the background. The units ran inline.

## Self-corrections

The commit hook rejected one passive phrase in the acceptance evidence. The agent reworded it. The fix was avoidable. The build log markers landed after the `---` rule until the agent moved them by hand.

## Improvements

- P2: the baseline run and the full run shared the machine, and one PowerShell suite failed once. Run the baseline before the full run starts.
- P2: `build-log-mark.mjs` places a marker after the `---` rule that closes a phase block. Place it inside the open block.

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
| content | primary | 3 | 0 |

Retrospective: plan/retrospectives/0000577-plan-lists-change-shapes-2026-11-16.md
