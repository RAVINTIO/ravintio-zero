# Build report: 0000501-remove-merged-worktrees

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 2 | 0 | primary | 0 |
| P1 Plan | 0 | 0 | primary | 0 |
| P2 Implement | 49 | 0 | primary | 0 |
| P3 Validate and Accept | 22 | 1 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

## Parallelism

None. The four requirements and the ADR share one script, so every unit ran inline. The baseline run ran in the background while the agent wrote the tests and the driver change. One subagent ran the docs edit pass.

## Self-corrections

- The new suite failed once in the full run, because its ADR path broke in the installed copy. The agent fixed the path with `git rev-parse --show-toplevel`. The failure was avoidable.

## Improvement suggestions

- P0: A step session has no human for a pending migration. The agent skipped 0009 again. Mark the migration done in the ledger.
- P2: The full suite and the clean-clone run each took about 21 minutes. A shard-parallel local runner would cut the wait.
- P2: A test that reads a file outside the pack folder needs a path that works in both copies. Resolve it from the git top level.

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
| Longest CI run (seconds) | 348 (run 43132543888) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |

Retrospective: plan/retrospectives/0000501-remove-merged-worktrees-2026-11-12.md
