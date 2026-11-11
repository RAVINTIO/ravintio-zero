# Build report: 0000519-ship-removal-needs-human-approval

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 63 | 0 | primary | 0 |
| P3 Validate and Accept | 22 | 1 | primary | 0 |
| P4 Ship | not recorded | 0 | primary | 0 |

## Parallelism

None used. The two P2 units are small and ran in order.

## Self-corrections

One. The new req-001 suite computed the repo root from its own folder, which fails for the installed copy. It was avoidable if the P2 affected-test run had also run the installed copy.

## Improvement suggestions

- P2: The affected-test run covers the source copy only. A new suite fails first in the full run if it breaks only from the installed folder. No change filed.

Postmortems: plan/postmortems/2026-11-11-installed-copy-check-used-wrong-root.md

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`. The baseline already records it.
- `test-0000318-req-004-merge-guard-pinned.sh`. The baseline already records it.
- `test-0000450-req-004-report-format.sh`. The baseline already records it.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
| unclassified | unclassified | 0 | 1 |

Retrospective: plan/retrospectives/0000519-ship-removal-needs-human-approval-2026-11-11.md
