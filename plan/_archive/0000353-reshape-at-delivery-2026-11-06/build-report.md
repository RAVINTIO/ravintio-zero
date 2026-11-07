# Build report - 0000353-reshape-at-delivery

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock | Parallelism |
|-------|--------|------|-----------|-------------|
| P0 | 0 | primary | 0 min | none |
| P1 | 0 | primary | 1 min | none, artifacts share files |
| P2 | 0 | primary | 3 min | none, units ran inline in turn |
| P3 | 0 | primary | 9 min | full suite in the background |
| P4 | 0 | primary | 1 min | none |

## Self-corrections

- 1: the build log note held two old product names, and the old-name guard failed in the full suite. Avoidable, because the guard scans `plan/current/` and the note quoted the migration triggers. The note now says the migrations do not apply.

## Improvements

- P0: write the migration note without quoting the old names that the guard scans for.
- P2: the units had disjoint write targets and could have run in parallel. Inline work kept the context small, but the batch went unused. U2 and U3 edited their text before their tests, because the tests only read that text, so no RED run exists for them.

Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000353-reshape-at-delivery-2026-11-06.md
