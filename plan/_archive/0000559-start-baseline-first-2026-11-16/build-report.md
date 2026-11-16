# Build report - 0000559

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 2 |
| P1 Plan | 0 | primary | 0 |
| P2 Implement | 0 | primary | 20 |
| P3 Validate and Accept | 0 | primary | 23 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

The baseline run started before any P0 artifact and finished while P2 ran. The units ran inline.

## Self-corrections

The agent edited the pack text before the plan and the failing test existed. It reverted the edit, wrote the plan and the test, and reapplied the edit. The fix was avoidable. Two suites pinned start action numbers, and the step updated both. A later commit hook rejected two prose breaches, and the agent reworded them.

## Improvements

- P0: the sentinel guard blocks a command that writes the sentinel and other plan files together. Write the sentinel in its own command.
- P1: the scan has no cause for a renumbered list. Filed as part of 0000586 for the marker, and the cause is open.

## Postmortems

- `plan/postmortems/2026-11-16-pin-update-after-renumbering-logged-as-rework.md`

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

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
| content | primary | 4 | 0 |
| unclassified | unclassified | 0 | 1 |

Retrospective: plan/retrospectives/0000559-start-baseline-first-2026-11-16.md
