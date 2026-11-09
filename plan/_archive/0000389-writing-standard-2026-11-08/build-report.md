# Build report - 0000389-writing-standard

**Run speed:** standard

## Phases

| Phase | Agents | Tier | Wall clock (min) | Parallelism |
|-------|--------|------|------------------|-------------|
| P0 Discovery | 0 | primary | 1 | none |
| P1 Plan | 0 | primary | 1 | none, artifacts written inline |
| P2 Implement | 3 | primary (sonnet) | 69 | one batch of 3 units |
| P3 Validate and Accept | 0 | primary | 1 | none |
| P4 Ship | 0 | primary | 0 | none |

## Self-corrections

- The generator printed nothing through a symlinked path. A subagent found it. Avoidable with a test through a symlink in the first pass.
- The regression copy of the v0.4.0 settings pin lacked `outputStyle`. Avoidable by a grep for sibling copies of an edited test.

## Suggestions

- P1: the plan listed the regression copy of tests only by name. Add a sibling check to the test impact scan.
- P2: U1 and U2 ran inline and passed on the first run, so no test was seen failing first. Write the test before the implementation.
- P3: the full suite takes over 10 minutes. Start it with the long timeout.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-003) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000389-writing-standard-2026-11-08.md
