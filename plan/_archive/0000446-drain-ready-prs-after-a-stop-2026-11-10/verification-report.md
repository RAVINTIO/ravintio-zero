# Verification report - 0000446-drain-ready-prs-after-a-stop

## What ran

The driver `src/ravintio-zero/scripts/initiative-run.mjs` ran against a real git repo with a bare origin. The fixture in `helpers/scheduler-fixture.sh` supplies a stub `claude` and a stub merge queue. Nothing reached the network.

## Criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1: another ready PR merges | CLI run of the driver with `QUEUE_FAIL_STEP=1` | verified | `queue.log` held `1 101,2 102,`. Origin showed step 2 `merged`. The driver printed `I-D Advance: Complete: step 2 merged`. |
| REQ-001 AC-2: the failure stays visible | Same run | verified | Exit code 1. The output held `queue stopped on step 1`, `I-C Run: Step 1: stopped`, and the log line for step 1 last. |
| REQ-001 AC-3: one attempt per step | CLI run with `QUEUE_FAIL_STEP=1,2` | verified | `queue.log` held one line for each step. Exit code 1. |
| REQ-001: a dependent step does not start | CLI run with step 2 after step 1 | verified | No `step-2.env` file. The report read `I-C Run: Step 2: pending`. |
| REQ-002 AC-1: the rule is in the standards | Read `roadmap-standards.md` line 317 | verified | The text holds the drain sentence, the failed-step sentence, and the restart sentence. The test greps all three. |

## Not verifiable

None.
