# Build report - 0000387-light-discovery-and-audits

- Run speed: standard
- Phases: P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship. Wall clock per phase is in `build-log.md`.
- Agents: 4, all sonnet (cheaper tier), one per unit U1 to U4, in one parallel batch at P2. U5 ran inline.
- Parallelism: P2 used it. P0, P1, P3, and P4 ran inline because their artifacts depend on each other.
- Self-corrections: 2 at P2, both avoidable. A size cap test (0000377) and the runner's fixture list were missed in the Test impact table.
- Improvements:
  - P1: the Test impact scan should grep for byte caps by file name, and for new fixture folders against `run-tests.sh`.
  - P2: the path guard blocks shell writes by relative path, so briefs should tell subagents to use the Write and Edit tools with absolute paths.
- Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: none
