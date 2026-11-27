# Build report - 0000552

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 48 |
| P3 Validate and Accept | 0 | primary | 22 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

The baseline run ran in the background while the agent worked. The full run waited for the baseline to end. The units ran inline.

## Self-corrections

- The sentinel hook blocked the first artifact write, because the sentinel did not exist yet. The agent wrote the sentinel first. The fix was avoidable.
- The commit hook rejected one passive phrase in the changelog. The agent reworded it.
- `build-log-mark.mjs` placed markers after the `---` rule of the phase block, and the agent moved them by hand. Step 33 logged the same gap.
- The base merge conflicted on two living docs and one ADR id. The queue helpers resolved both and renumbered the ADR from 0349 to 0350.

## Improvements

- P2: place a `build-log-mark.mjs` marker inside the open phase block.
- P0: write `plan/.orchestrator-active` before any command that writes under `plan/`.

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
| content | inline | 4 | 0 |

Retrospective: plan/retrospectives/0000552-duplicate-backlog-ids-2026-11-16.md
