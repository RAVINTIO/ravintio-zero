# Build report: 0000495-driver-clears-dead-lock

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 3 | 0 | primary | 0 |
| P1 Plan | 0 | 0 | primary | 0 |
| P2 Implement | 27 | 0 | primary | 0 |
| P3 Validate and Accept | 1 | 0 | primary | 0 |
| P4 Ship | 1 | 0 | primary | 0 |

## Parallelism

None. The three requirements and the ADR share one script and one fixture, so every unit ran inline. The two full suite runs (baseline and post-change) ran in the background at the same time.

## Self-corrections

None.

## Improvement suggestions

- P0: A step session has no human for a pending migration. The agent skipped 0009 because the ADRs already live in `docs/adr/`. Mark a migration done in the ledger when the repo already meets its target.
- P2: The agent wrote the unit marker lines after the work, from one clock read. Compare the typed-marker-times postmortem.

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
| Longest CI run (seconds) | 320 (run 43112285132) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |

Retrospective: plan/retrospectives/0000495-driver-clears-dead-lock-2026-11-11.md
