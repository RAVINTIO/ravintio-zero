# Build report - 0000549-baseline-record-checks

**Run speed:** fast

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallelism |
|-------|----------------------|--------|------|-------------|
| P0 to P2 | see build log | 0 | primary | none |
| P3 | 1165 | 0 | primary | none |
| P4 | 0 at first ship, CI wait 376s | 0 | primary | none |

All work ran inline. The three units are small and share files, so subagents would cost more than they save.

## Self-corrections

None.

## Suggestions

- P4: `build-log-check.mjs` flags an inline docs unit that has no RED or GREEN line. Backlog 0000410 covers it.
- P4: The base merge at ship conflicted on both tests READMEs. Rebasing earlier would have cut the conflict.

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh` fails in a clean clone and on the base.
- `test-0000318-req-004-merge-guard-pinned.sh` fails in a clean clone and on the base.
- `test-0000450-req-004-report-format.sh` fails in a clean clone and on the base.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 376 (run 43714299274) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |

Retrospective: none
