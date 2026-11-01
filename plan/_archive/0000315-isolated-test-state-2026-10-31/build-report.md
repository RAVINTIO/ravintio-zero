# Build report - 0000315-isolated-test-state

Run speed was `fast`. The build log records the total wall clock in its summary table. Phase times come from commit timestamps.

## Phases

| Phase | Agents spawned | Model tier | Parallel batches | Wall clock (minutes) |
|-------|----------------|------------|------------------|----------------------|
| P0 Discovery | 0 | primary | 0 | 1 |
| P1 Plan | 0 | primary | 0 | 1 |
| P2 Implement | 0 | primary | 0 | 20 |
| P3 Validate and accept | 0 | primary | 1 | 1 |
| P4 Ship | 0 | primary | 0 | 0 |

Every phase has an End row, so no phase reads `not recorded`. The P4 block closed before the archive step, so its time is understated.

## Parallelism

- The chart asked for parallel units. No phase dispatched a subagent.
- P1, P2, and P4 ran sequentially. U2 built on U1, and U1 and U3 were short, so subagent overhead outweighed the gain.
- P3 ran the full suite in the background while verification and the security review ran inline.

## Self-corrections

- Clearing `RAVINTIO_TEST_QUIET` broke `test-0000151-req-008`. Avoidable: `assert.sh` reads the variable, and a grep of `tests/helpers/` before the design would have shown it.
- Process substitution in the runner failed `test-0000164-req-008`. Avoidable: the rule sits in that guard's header.

## Improvement suggestions

- P1: Grep `tests/helpers/` for each variable the runner clears before the plan names the keep list.
- P2: Run the guard suites after each runner edit, not only after the full run. The full run costs about four minutes.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000315-isolated-test-state-2026-10-31.md
