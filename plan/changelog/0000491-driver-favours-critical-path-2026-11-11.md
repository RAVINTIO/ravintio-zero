# Changelog (0000491-driver-favours-critical-path, 11 Nov 2026)

**Feature:** Driver favours the critical path
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- `readySteps` in `initiative-chart.mjs` lists the startable steps longest chain first. Chart order breaks ties.
- The chain of a step is 1 plus the longest chain among its unmerged dependants. A dependant lists the step in `After`, or is the next unmerged step in the same lane.
- Item 2 of `## Concurrent steps` in `roadmap-standards.md` states the order.
- A new suite, `test-0000491-req-001-chain-ranking.sh`, covers these cases:
  - The order and ties.
  - Lanes.
  - A cycle.
  - The run time on 60 steps.
- ADR 0319 records the decision.

## Why

On 2026-11-10 the driver lane, steps 24 to 29 then 41, waited while steps in shorter lanes ran. The initiative took hours longer than its longest chain required.

## Deviations

- P2 ran inline without subagents, because the code unit is one function and its suite.
- `initiative-run.mjs` needed no change. It already takes the first free steps of the `readySteps` list.

## Validation results

- The new suite passes 10 of 10 checks. It failed 4 before the change.
- The full suite result is in the verification report.

## Skipped phases

None.
