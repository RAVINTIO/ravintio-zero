# Build report - 0000381-setup-safety

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) | Notes |
|-------|--------|------|------------------|-------|
| P0 Discovery | 0 | primary | 1 | Initiative step, design self-confirmed |
| P1 Plan | 0 | primary | 1 | Artifacts written inline |
| P2 Implement | 0 | primary | 23 | Four units in sequence, tests first. The full suite took about 13 of these minutes. |
| P3 Validate | 0 | primary | 0 | Evidence from one manual setup run and the full suite |
| P4 Ship | 0 | primary | 0 | Initiative step, so no version bump |

- Parallelism: none. U1 to U4 all edit `setup.sh` and `setup.ps1`, so they could not split across agents.
- Multi-task phases that ran sequentially: P2, for the shared-file reason above. The TDD loop ran inline instead of through the test-writer and implementer skills.
- Self-corrections: 0.
- Improvement, P2: the full Bash run takes about 13 minutes and prints nothing in quiet mode until it ends. A progress line per suite would show a hung suite sooner.
- Improvement, P3: resume detection reports a migration as pending after the ledger marks it done (backlog 0000403).

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000381-setup-safety-2026-11-07.md
