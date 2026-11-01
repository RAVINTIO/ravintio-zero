---
title: "Build Report - 0000318-titled-coordinator-prs"
summary: "Phase times, parallelism, and self-corrections for initiative 0000312 step 6."
---
# Build Report - 0000318-titled-coordinator-prs

**Run speed:** fast

| Phase | Wall clock | Agents | Parallel batches | Notes |
|-------|-----------|--------|------------------|-------|
| P0 Discovery | 1 minute | 0 | 0 | Self-confirmed from the chart. |
| P1 Plan | 1 minute | 0 | 0 | Written inline. The artifacts share one vocabulary. |
| P2 Implement | 12 minutes | 3 | 1 | Units U1, U2, and U3 ran in parallel. |
| P3 Validate and Accept | 10 minutes | 1 | 1 | The full suite ran beside one read-only review. |
| P4 Ship | not recorded | 0 | 0 | Written at ship. |

## Parallelism

- P2 used the planned batch. U4 became living-doc edits at ship, so it ran in sequence.
- P1 ran inline. A split would have cost more than it saved.

## Self-corrections

- 1 cycle. The first full suite failed two suites. One needed the words "one commit" in the activation text. The other flagged old names in `discovery.md`. Both were avoidable: a grep of the suites for the changed text would have found them before the run.

## Improvement suggestions

- P2: dispatch living-doc edits as a unit in batch 1, so ship does not write them.
- P2: hand each subagent the 72-character commit subject limit. Three of three shortened a subject after the hook rejected it.
- P3: the build log Start times that I typed ahead of the clock failed the ship check. Read the clock with `date -u` when you open a phase block.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
