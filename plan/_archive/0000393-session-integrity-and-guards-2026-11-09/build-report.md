# Build report - 0000393-session-integrity-and-guards

- Run speed: standard
- Phases: P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship. Wall clock per phase is in `build-log.md`.
- Agents: 4, all sonnet (cheaper tier), one per unit, in one parallel batch at P2.
- Parallelism: P2 used it. P0, P1, P3, and P4 ran inline because their artifacts depend on each other.
- Self-corrections: 0 at P3. Subagents fixed test pins during P2.
- Improvements:
  - P2: the full suite takes about 18 minutes and reports "tree changed" when commits land mid-run. Commit before the full run.
  - P2: a unit that changes the hook list should name the pinned tests in the plan, as the Test impact table did only in part.
- Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: none
