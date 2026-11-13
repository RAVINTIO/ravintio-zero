# Build report - 0000388-replies-and-questions

**Run speed:** standard

| Phase | Agents | Tier | Wall clock (min) | Notes |
|-------|--------|------|------------------|-------|
| P0 Discovery | 0 | primary | 1 | Self-confirmed by the initiative chart |
| P1 Plan | 1 | cheaper | 3 | 5 requirements, 1 ADR |
| P2 Implement | 4 | cheaper | 27 | Batch 1: U1, U2, U4 in parallel. Batch 2: U3 |
| P3 Validate | 0 | primary | 3 | Hooks run by hand, suite run once |
| P4 Ship | 0 | primary | 1 | Initiative step |

**Parallelism.** P2 ran two batches. U3 waited for U2 because both edit the initiative skill. No multi-task phase ran sequentially without a reason.

**Self-corrections.** One. U2 grew the orchestrator `SKILL.md` to 8710 bytes, over the 8700 cap in `test-0000377-req-001`. It was avoidable, because the plan named the 9000 cap and missed the stricter 8700 test.

**Improvements.**
- P1: the test impact scan should grep every size cap for a skill, not only the first match.
- P3: U3 reported a failing test without checking it against the base commit. The check took one archive extract.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000388-replies-and-questions-2026-11-07.md
