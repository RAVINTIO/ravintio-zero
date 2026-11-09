# Build report - 0000394-github-security-and-ci-lint

**Run speed:** standard

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 1 | primary and cheaper | 21 |
| P3 Validate | 0 | primary | 469, including a human stop of about 453 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

P2 ran one subagent (U2, community files) beside inline work. No multi-task phase ran sequentially without cause.

## Self-corrections

- The write guard read only one path from a two-path line in `design.md`. Avoidable: put one path on each line.
- Three sibling tests scanned the allowlist file and broke when the step shared it. Partly avoidable: a scan of dependent tests at P1 would find them.

## Suggestions

- P1: list tests that read a file the step moves or shares.
- P3: run the settings check before the evidence write, to avoid a stop on settings already on.

Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000394-github-security-and-ci-lint-2026-11-08.md
