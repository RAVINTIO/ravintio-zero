# Build report - 0000536-pending-migrations-reach-the-human-early

Run speed: standard

## Phases

| Phase | Tier | Agents | Wall clock (minutes) |
|-------|------|--------|----------------------|
| P0 Discovery | primary | 0 | 1 |
| P1 Plan | primary | 0 | 4 |
| P2 Implement | primary | 0 | 49 |
| P3 Validate and Accept | primary | 1 | 25 |
| P4 Ship | primary | 0 | 1 |

## Parallelism

None. The edits share one rule text and the content units ran inline.

## Self-corrections

- The prose check flagged two long sentences in `roadmap-standards.md`. Avoidable by checking sentence length before the commit.
- The mirrored-tree test needed the `src/ravintio-zero/` copies. Avoidable if the plan had listed that cause (backlog entry 0000539).

## Improvement suggestions

- P1: add the mirrored tree to the Test impact scan.
- P3: run the full suite from the repo root.

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
| Longest CI run (seconds) | 348 (run 43373466633) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 4 | 0 |

Retrospective: plan/retrospectives/0000536-pending-migrations-reach-the-human-early-2026-11-13.md
