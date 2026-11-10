# Build report - 0000399-smoother-activation

- Run speed: standard.
- Phases: P0 2 minutes, P1 3 minutes, P2 27 minutes, P3 21 minutes, P4 under 1 minute. Total 53 minutes.
- Agents: 6 sonnet subagents. P1 used one. P2 used five in one parallel batch (U-001, U-002, U-005, U-006, U-007). U-003 ran inline.
- Self-corrections: 1 (REQ-006). It was avoidable. The unit test planted fixtures and never planted a stale ledger row. Postmortem: `plan/postmortems/2026-11-10-stale-ledger-rows-still-pending.md`.
- Improvement, P2: tell each unit to check its outcome against the repo's real inputs, not only planted fixtures.
- Improvement, P3: the clean-clone run needs an environment that holds `core.hooksPath` and the `origin/initiative/*` ref, so two suites stop failing there.
- Inherited failures: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. Both fail only in a clean clone. No backlog entry is filed.
- Retrospective: none.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-006) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 1 | 0 |
| unclassified | unclassified | 5 | 1 |
