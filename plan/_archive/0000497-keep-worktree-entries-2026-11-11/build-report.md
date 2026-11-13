# Build report: 0000497-keep-worktree-entries

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 3 | 0 | primary | 0 |
| P1 Plan | 0 | 0 | primary | 0 |
| P2 Implement | 41 | 0 | primary | 0 |
| P3 Validate and Accept | 1 | 0 | primary | 0 |
| P4 Ship | 1 | 0 | primary | 0 |

## Parallelism

None. The three requirements and the ADR share one script and one fixture, so every unit ran inline. The baseline run in a clean clone ran in the background while the agent wrote the tests and the driver change.

## Self-corrections

None.

## Improvement suggestions

- P0: A step session has no human for a pending migration. The agent skipped 0009 again because the ADRs already live in `docs/adr/`. Mark the migration done in the ledger.
- P2: The full suite took about 22 minutes, and the baseline in a clean clone took about 17. A shard-parallel local runner would cut the wait.
- P2: The path guard resolved a relative path in a heredoc against the project folder and blocked a write. The agent used absolute paths.

Postmortems: none

Inherited failures:

- `test-0000450-req-004-report-format.sh`

The baseline in a clean clone also held `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. Both pass in the working tree.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 262 (run 43120991399) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |

Retrospective: plan/retrospectives/0000497-keep-worktree-entries-2026-11-11.md
