# Build report: 0000489-question-only-for-questions

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 2 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 32 | 0 | primary | 0 |
| P3 Validate and Accept | 21 | 1 | primary | 0 |
| P4 Ship | not recorded | 0 | primary | 0 |

## Parallelism

None used. The two P2 units share the Question wording, so they ran in order.

## Self-corrections

None.

## Improvement suggestions

- P0: A heredoc in a Bash call that follows a `cd` made `gate-write` read the file name as a path outside the design. The Write tool with an absolute path avoided it. No change filed.

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`. The baseline already records it.
- `test-0000318-req-004-merge-guard-pinned.sh`. The baseline already records it.
- `test-0000450-req-004-report-format.sh`. The baseline already records it.

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
| content | inline | 2 | 0 |

Retrospective: plan/retrospectives/0000489-question-only-for-questions-2026-11-11.md
