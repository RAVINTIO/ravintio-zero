# Build report: 0000487-steps-apply-decision-rows

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 39 | 0 | primary | 0 |
| P3 Validate and Accept | 29 | 1 | primary | 0 |
| P4 Ship | not recorded | 0 | primary | 0 |

## Parallelism

None used. The three P2 units ran in order because U-2 imports the U-1 module and U-3 pins text that U-1 and U-2 define.

## Self-corrections

None.

## Improvement suggestions

- P2: Write docs before the full suite starts or after it ends, because the runner fails on a changed tree (backlog entry 0000517).
- P4: Name `git rm -r` in ship Step 4, because the safety check refused the earlier removal (backlog entry 0000517).

Postmortems: `plan/postmortems/2026-11-11-ship-removal-refused.md`

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`. The baseline already records it.
- `test-0000318-req-004-merge-guard-pinned.sh`. The baseline already records it.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 1 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 417 (run 42957194743) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

No dispatched units.

Retrospective: plan/retrospectives/0000487-steps-apply-decision-rows-2026-11-11.md
