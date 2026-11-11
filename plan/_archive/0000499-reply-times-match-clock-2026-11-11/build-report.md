# Build report: 0000499-reply-times-match-clock

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 2 | 0 | primary | 0 |
| P1 Plan | 3 | 0 | primary | 0 |
| P2 Implement | 32 | 0 | primary | 0 |
| P3 Validate and Accept | 27 | 1 | primary | 0 |
| P4 Ship | see build log | 0 | primary | 0 |

## Parallelism

None used for agents. The four P2 units share the clock rule, so they ran in order. The full suite ran in 4 shards.

## Self-corrections

One. Six existing suites pinned the old hook counts and the 5 minute margin. The Test impact scan named three of them, so the avoidable part was the scan. Postmortem 2026-11-11-hook-change-missed-pinning-suites covers it.

## Improvement suggestions

- P1: Add a hook change cause to the Test impact scan (backlog 0000523).
- P2: Write RED, GREEN, and Done lines with a script that reads the clock (backlog 0000524).
- P4: A shell heredoc after a `cd` made `gate-write` read a bare file name as a path outside the design. The Write tool with an absolute path avoided it. No change filed.

Postmortems:

- `plan/postmortems/2026-11-11-hook-change-missed-pinning-suites.md`
- `plan/postmortems/2026-11-11-typed-marker-times.md`

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`. The baseline already records it.
- `test-0000318-req-004-merge-guard-pinned.sh`. The baseline already records it.
- `test-0000450-req-004-report-format.sh`. The baseline already records it.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-003) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 452 (run 42998521786) | 420 | breach |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | inline | 3 | 0 |
| content | inline | 1 | 0 |
| unclassified | unclassified | 0 | 1 |

Retrospective: plan/retrospectives/0000499-reply-times-match-clock-2026-11-11.md
