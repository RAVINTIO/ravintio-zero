# Build report - 0000383-test-impact-scan

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) | Notes |
|-------|--------|------|------------------|-------|
| P0 Discovery | 0 | primary | 0 | Initiative step, design self-confirmed |
| P1 Plan | 0 | primary | 0 | Artifacts written inline |
| P2 Implement | 0 | primary | 16 | Includes the 11 minute full suite |
| P3 Validate | 0 | primary | 0 | Reused the clean-tree suite run |
| P4 Ship | 0 | primary | 0 | |

- Parallelism: none. The five edits are short and share the plan skill, so dispatch would add cost without a gain.
- Multi-task phases that ran sequentially: P2 and P1 ran inline for that reason.
- Self-corrections: 1, avoidable. A pin test matched the plan skill's new `run-tests.sh` name. The scan has no cause for it, which backlog entry 0000404 files.
- Improvement, P2: run the suites that `## Test impact` names before the full suite. This step wrote that rule into the implement skill.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-002) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000383-test-impact-scan-2026-11-07.md
