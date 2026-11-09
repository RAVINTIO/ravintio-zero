# Build report - 0000385-faster-test-runs

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) | Notes |
|-------|--------|------|------------------|-------|
| P0 Discovery | 0 | primary | 0 | Initiative step, design self-confirmed |
| P1 Plan | 0 | primary | 0 | Artifacts written inline |
| P2 Implement | 0 | primary | 3 | Three units written inline |
| P3 Validate | 0 | primary | 0 | Block opened after the suite ran, so the time under-reports |
| P4 Ship | 0 | primary | 0 | |

- Parallelism: none. The three units in batch 1 were small and shared one design, so no subagent was briefed.
- Multi-task phases that ran sequentially: P2 batch 1 (U1 to U3), for the reason above.
- Self-corrections: 0.
- Improvement, P0: the full suite took about 15 minutes on the base commit. The P0 step now says to start it in the background and record the baseline before P3.
- Improvement, P3: open the phase block when the phase begins, not after its longest command.
- Postmortems: none.

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`: `core.hooksPath` is empty in a fresh clone. It failed in the base run and the clean-clone run.
- `test-0000378-req-001-version-files.sh`: failed in the base run only, which ran beside the build. It looks load-sensitive.
- `test-0000378-req-002-003-merge-queue.sh`: failed in the base run only, for the same reason.

No backlog entry is filed for them. The first is the one to pick up.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000385-faster-test-runs-2026-11-07.md
