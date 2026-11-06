# Build report - 0000354-steps-run-to-the-end

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock | Parallelism |
|-------|--------|------|-----------|-------------|
| P0 | 0 | primary | 1 min | none |
| P1 | 0 | primary | 1 min | none, artifacts share files |
| P2 | 0 | primary | 21 min | none, units ran inline in turn. The full suite ran in the background. |
| P3 | 0 | primary | 3 min | none |
| P4 | 0 | primary | 0 min | none |

## Self-corrections

- 1: the test runner stopped on an undiscovered helper, because `run-tests.sh` did not list `helpers/driver-args.sh`. Avoidable, because the plan's test impact scan did not grep the runner's allowlist for new helper files.

## Improvements

- P1: add the runner allowlist to the test impact scan for a run that adds a file under `ravintio-zero/tests/`.
- P2: the units had disjoint write targets and could have run in parallel. Inline work kept the context small, but the batch went unused. The full suite takes about 10 minutes, so run it in the background right after the first unit lands.

Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-004) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000354-steps-run-to-the-end-2026-11-06.md
