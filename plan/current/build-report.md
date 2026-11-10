# Build Report - 0000458-refuse-step-merge-outside-queue

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 4 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 22 |
| P3 Validate and Accept | 0 | primary | 35 |
| P4 Ship | 0 | primary | 0 |

## Parallelism

None used. Each phase held one unit, so no batch had two independent units.

## Self-corrections

- Five guard suites inherited the step variable and failed. Avoidable by searching for suites that run the hook before the first full run.
- The invocation reference edit broke a fixture-pinned line. Avoidable by reading the test impact table first.

## Improvements

- P2: run the suites that pin an edited file before the full suite.
- P3: the full suite takes about 25 minutes. Start it as soon as P2 commits.

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`: `core.hooksPath` is unset in a clean clone.
- `test-0000318-req-004-merge-guard-pinned.sh`: the pinned `origin/initiative/0000312-guards-history-and-test-noise` ref is missing in a clean clone.

Backlog entries for these two stay with the retrospective.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 1 | 0 |

Retrospective: plan/retrospectives/0000458-refuse-step-merge-outside-queue-2026-11-10.md
