# Build report - 0000548-ack-write-mid-suite-fails-run

Run speed: fast.

## Phases

| Phase | Wall clock (minutes) | Agents | Parallel batches |
|-------|----------------------|--------|------------------|
| P0 Discovery | 2 | 0 | 0 |
| P1 Plan | 1 | 0 | 0 |
| P2 Implement | 11 | 0 | 0 |
| P3 Validate and Accept | 953 | 0 | 0 |
| P4 Ship | 1 | 0 | 0 |

## Observations

- Parallelism: none used. Each phase held one unit of work, so nothing could split.
- Self-corrections: 0.
- P3 took 953 minutes, nearly all of it the full suite. Four step suites shared the machine, and the run took about four hours. Improvement: stagger the full-suite runs across steps.
- P3 had two commit refusals from the prose check, both for passive voice in new records. Improvement: write the P3 records to the writing standard on the first pass.

Postmortems: none
Inherited failures:

- `test-0000450-req-004-report-format.sh`. It fails the same way on the merge base.

Retrospective: none

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
| content | inline | 1 | 0 |
