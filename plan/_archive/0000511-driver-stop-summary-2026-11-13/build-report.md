# Build Report - 0000511-driver-stop-summary

**Run speed:** standard

## Phases

| Phase | Agents | Tier | Wall clock (minutes) | Parallelism |
|-------|--------|------|----------------------|-------------|
| P0 | 0 | primary | 1 | none |
| P1 | 0 | primary | 1 | none |
| P2 | 0 | primary | 57 | none |
| P3 | 1 | primary | 1 | none |
| P4 | 0 | primary | 0 | none |

The units share one driver file, so no phase ran in parallel.

## Self-corrections

One. The first design printed the summary after the final line and broke five suites. The block now prints before it. The fix was avoidable with a search of the tests for readers of the last line.

## Improvement suggestions

- P1: the test impact step searches the tests for suites that read printed lines (backlog entry 0000533).
- P2: the full suite takes about 25 minutes. A progress line in quiet mode would help the agent wait.

Postmortems: plan/postmortems/2026-11-13-summary-broke-last-line-suites.md

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-002) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |
| unclassified | unclassified | 0 | 1 |

Retrospective: plan/retrospectives/0000511-driver-stop-summary-2026-11-13.md
