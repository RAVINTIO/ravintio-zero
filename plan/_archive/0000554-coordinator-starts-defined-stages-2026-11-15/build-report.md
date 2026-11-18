# Build report - 0000554-coordinator-starts-defined-stages

- Run speed: fast.
- Wall clock: P0 2 minutes, P1 1, P2 20, P3 23, P4 1. The suites took most of P2 and P3.
- Agents: none spawned. Every unit was inline content work.
- Parallelism: none. U-1 and U-2 both write `roadmap-standards.md`, so they ran in turn.
- Self-corrections: 0. Two build-log ordering fixes came from `build-log-check.mjs` on the docs unit.
- Improvement, P0: the first Bash call failed on the sentinel. The sentinel must exist before the first plan write.
- Improvement, P2: the docs unit needs a RED and a GREEN line before its Done line. Backlog 0000410 tracks it.
- Postmortems: none.
- Inherited failures: `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`.
- Retrospective: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 307 (run 43755331737) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |
