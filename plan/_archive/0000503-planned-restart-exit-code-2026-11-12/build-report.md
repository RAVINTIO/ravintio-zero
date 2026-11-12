# Build report: 0000503-planned-restart-exit-code

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 2 | 0 | primary | 0 |
| P1 Plan | 0 | 0 | primary | 0 |
| P2 Implement | 30 | 0 | primary | 0 |
| P3 Validate and Accept | 0 | 1 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

## Parallelism

None. The three requirements and the ADR share one script, so every unit ran inline. The baseline run and the step run ran in the background while the agent wrote the P3 evidence. One subagent ran the docs edit pass.

## Self-corrections

- The full suite failed `test-0000379-req-002-003-005-scheduler.sh`, which expected exit 1 for a restart line. The Test impact table in the execution plan missed it, because the search matched the word `Restart` and not the exit-code assertion. The agent set the suite to 75. The failure was avoidable.

## Improvement suggestions

- P1: Search the tests for the old exit code beside the changed behaviour. A search for the stop line text found four of five suites.
- P0: A step session has no human for a pending migration. The agent skipped 0009 again. Mark the migration done in the ledger.
- P3: The longest CI run took 445 seconds, above the 420 second threshold. Shard balancing is the owner of that change.

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
| Longest CI run (seconds) | 445 (run 43138752203) | 420 | breach |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |

Retrospective: plan/retrospectives/0000503-planned-restart-exit-code-2026-11-12.md
