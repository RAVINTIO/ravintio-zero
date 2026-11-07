# Build report - 0000352-coordinator-admin-in-step-prs

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock | Parallelism |
|-------|--------|------|-----------|-------------|
| P0 | 0 | primary | 2 min | none |
| P1 | 0 | primary | 1 min | none, artifacts share files |
| P2 | 0 | primary | 23 min | none, units ran inline in turn |
| P3 | 0 | primary | 10 min | full suite in the background |
| P4 | 0 | primary | 1 min | none |

## Self-corrections

- 1: the standards test used a process-substitution loop that a repo-wide style test bans. Avoidable, because the plan phase had no cause for style rules on new test files (entry 0000362).

## Improvements

- P1: name repo-wide test style rules in the test impact scan (entry 0000362).
- P2: units had disjoint write targets and could have run in parallel. Inline work kept the context small, but the batch went unused.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-004) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000352-coordinator-admin-in-step-prs-2026-11-06.md
