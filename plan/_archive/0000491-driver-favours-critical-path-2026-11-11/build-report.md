# Build report: 0000491-driver-favours-critical-path

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 61 | 0 | primary | 0 |
| P3 Validate and Accept | 2 | 1 | primary | 0 |
| P4 Ship | 1 | 0 | primary | 0 |

## Parallelism

None used. The code unit is one function and its suite, so the units ran in order.

## Self-corrections

None.

## Improvement suggestions

- P2: The clean-clone suites took about 50 minutes because three steps shared the machine. Filing nothing new.
- P4: The harness refused the `rm` of `plan/current/*`. Postmortem `2026-11-11-ship-removal-refused.md` and backlog entry 0000518 already cover it.

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`. The baseline already records it.
- `test-0000318-req-004-merge-guard-pinned.sh`. The baseline already records it.
- `test-0000450-req-004-report-format.sh`. The baseline already records it.
- `test-0000189-req-007-old-name-guard.sh` failed once in the full run and passes alone. Backlog entry 0000527 records it.

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
| code | inline | 1 | 0 |
| unclassified | unclassified | 1 | 0 |

Retrospective: none
