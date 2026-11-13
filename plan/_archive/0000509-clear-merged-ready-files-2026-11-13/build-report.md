# Build Report - 0000509-clear-merged-ready-files

**Run speed:** standard

## Phases

| Phase | Agents | Tier | Wall clock (minutes) | Parallelism |
|-------|--------|------|----------------------|-------------|
| P0 | 0 | primary | 1 | none |
| P1 | 0 | primary | 1 | none |
| P2 | 0 | primary | 44 | none |
| P3 | 1 | primary | 2 | none |
| P4 | 0 | primary | 0 | none |

The units share one driver file, so no phase ran in parallel.

## Self-corrections

None.

## Improvement suggestions

- P2: the full suite takes about 20 minutes. A progress line in quiet mode would help the agent wait without a custom loop.

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

Retrospective: plan/retrospectives/0000509-clear-merged-ready-files-2026-11-13.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 319 (run 43352081051) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |
