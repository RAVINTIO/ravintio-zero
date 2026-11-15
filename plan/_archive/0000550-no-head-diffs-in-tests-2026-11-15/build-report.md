# Build report - 0000550-no-head-diffs-in-tests

Run speed: fast. Run mode: autonomous. Initiative 0000544, step 6.

| Phase | Agents | Tier | Parallel batches | Wall clock (minutes) |
|-------|--------|------|------------------|----------------------|
| P0 Discovery | 0 | primary | 0 | 1 |
| P1 Plan | 0 | primary | 0 | 1 |
| P2 Implement | 0 | primary | 1 | 1 |
| P3 Validate and Accept | 0 | primary | 0 | 25 |
| P4 Ship | 0 | primary | 0 | 1 |

## Parallelism

No subagent ran. The two units were small content units, so the agent ran them inline in one context. The baseline and P3 suites ran in the background.

## Self-corrections

- Two prose-hook rejections of P0 records. Avoidable with a sentence-length check before commit.
- Two scan-pattern fixes in P2, for a closing parenthesis and a comment line. Not avoidable before the planted cases ran.
- One consistency-check fix in P1, for a clobbered Batch cell. Avoidable.
- One build-log-check fix in P4, for missing `Complete:` lines. Avoidable.

## Improvement suggestions

- P0: the build log template has no `Complete: P{n}` lines, so every run fails the P4 check once.
- P4: the template could include the Summary table, so a step fills it instead of writing it.

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

CI duration: 571s.

Retrospective: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 571 (run 43749919714) | 420 | breach |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 1 | 0 |
