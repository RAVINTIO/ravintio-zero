# Build report: 0000546-queue-failure-leaves-dirty-files

**Run speed:** fast

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) | Parallel batches |
|-------|--------|-----------|----------------------|------------------|
| P0 Discovery | 0 | primary | 2 | 0 |
| P1 Plan | 0 | primary | 1 | 0 |
| P2 Implement | 0 | primary | 27 | 0 |
| P3 Validate and Accept | 0 | primary | 22 | 0 |
| P4 Ship | 0 | primary | see build log | 0 |

## Parallelism

None applied. The three P2 units depend on each other, so the batches ran in sequence.

## Self-corrections

One. CI `validate-branch` failed the sync check because the new test sat only in `ravintio-zero/tests/`. The agent copied it to `src/ravintio-zero/tests/`. The failure was avoidable, because the sync check skips while an initiative is active and the local suite could not catch it.

## Improvement suggestions

- P1: the plan should name both test trees when a unit adds a test. The plan assumed only `ravintio-zero/tests/`.
- P2: run `node src/ravintio-zero/scripts/sync-installed.mjs --check` before the first push in an initiative step.

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 279 (run 43756519972) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | inline | 1 | 0 |
| content | inline | 1 | 0 |

Retrospective: plan/retrospectives/0000546-queue-failure-leaves-dirty-files-2026-11-15.md
