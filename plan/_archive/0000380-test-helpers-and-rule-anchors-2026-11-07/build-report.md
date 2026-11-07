# Build report - 0000380-test-helpers-and-rule-anchors

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) | Notes |
|-------|--------|------|------------------|-------|
| P0 Discovery | 0 | primary | 1 | Initiative step, design self-confirmed |
| P1 Plan | 0 | primary | not recorded | Block written at phase end, so the time under-reports |
| P2 Implement | 3 | primary and cheaper | not recorded | Block written at phase end |
| P3 Validate | 0 | primary | not recorded | Block written at phase end |
| P4 Ship | 0 | primary | see build log | |

- Parallelism: one batch of three subagents converted 16 suites. Helpers and anchors ran inline because they share `assert.sh`.
- Multi-task phases that ran sequentially: P1 wrote its artifacts inline. They share one design, and briefing agents would have cost more than writing.
- Self-corrections: 2, both avoidable. The first `rule_text` counted anchor mentions in docs as anchors. The first anchor pass broke 8 suites that pin numbered-step lines. The plan's test impact scan did not list them, because it greps for fixed causes only.
- Improvement, P1: add anchors and reformatted skill lines as a cause in the plan skill's test impact scan.
- Improvement, P4: record each phase Start time when the phase begins, not at its end.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
