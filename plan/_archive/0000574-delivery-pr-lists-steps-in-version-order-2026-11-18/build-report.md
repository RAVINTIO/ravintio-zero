# Build report - 0000574

- Run speed: fast
- Phases: P0 3 minutes, P1 and P2 inline with 0 agents, P3 and P4 inline with 0 agents. Wall clock of P2 reads 2904 minutes because the session paused for two days.
- Model tiers: primary only. Parallelism: none. The units were small and shared files with their tests.
- Self-corrections: 0. Rework: 0.
- Improvement: commit each P3 report as it lands (backlog 0000595).
- Postmortems: none
- Inherited failures:
  - `test-0000037-req-004-remove-old-folder.sh`
  - `test-0000318-req-004-merge-guard-pinned.sh`
  - `test-0000450-req-004-report-format.sh`
  - `test-0000189-req-007-old-name-guard.sh` (passed on the final commit)

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 4 | 0 |

Retrospective: plan/retrospectives/0000574-delivery-pr-lists-steps-in-version-order-2026-11-18.md
