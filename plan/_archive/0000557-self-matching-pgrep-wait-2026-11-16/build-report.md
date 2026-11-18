# Build report - 0000557-self-matching-pgrep-wait

Run speed: fast

## Phases

| Phase | Agents | Tier | Wall clock |
|-------|--------|------|------------|
| P0 Discovery | 0 | primary | 1 minute |
| P1 Plan | 0 | primary | 1 minute |
| P2 Implement | 0 | primary | 31 minutes |
| P3 Validate and Accept | 0 | primary | 23 minutes |
| P4 Ship | 0 | primary | 1 minute |

## Parallelism

No subagent ran. The four units were small inline units, and the suite runs dominated the wall clock.

## Self-corrections

0.

## Improvement suggestions

- P2 and P3: a Monitor expires after 10 minutes. Backlog 0000591 files it.

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

Retrospective: plan/retrospectives/0000557-self-matching-pgrep-wait-2026-11-16.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 327 (run 43778836572) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 4 | 0 |
