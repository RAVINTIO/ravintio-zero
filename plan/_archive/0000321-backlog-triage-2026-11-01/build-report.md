# Build report - 0000321-backlog-triage

**Run speed:** fast

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 2 | 0 | primary | 0 |
| P2 Implement | 16 | 5 | primary | 2 |
| P3 Validate | 12 | 1 | primary | 1 |
| P4 Ship | 1 | 0 | primary | 0 |

## Parallelism

P2 ran U-001, U-002, and U-005 as three parallel sonnet tracks in batch 1. It ran U-003 and U-004 as two tracks in batch 2, after the script they name existed. U-006 ran inline because the migration run and shared docs needed the finished code. P3 ran the security review as one subagent beside the inline execution checks. P1 wrote its artifacts inline because they share one format.

## Self-corrections

One. The security review found a backtracking regex in the PowerShell helper and an unchecked index path. Neither was avoidable by the suites, which had no hostile CRLF or symlinked-output case. Commit `27a6366c` fixed both and added tests.

## Suggestions

- P1: read the build log after each phase block, so a failed command in a chain does not leave a block out.
- P2: tell test tracks which programs the macOS shell lacks, such as `timeout`.
- P3: ask the security reviewer to run the PowerShell helpers under `pwsh` when the host has it. It caught S-001 that way.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-002) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000321-backlog-triage-2026-11-01.md
