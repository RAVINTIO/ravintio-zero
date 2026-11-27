# Build report - 0000576-phase-start-time-at-phase-start

**Run speed:** fast

## Phases

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 2 |
| P1 Plan | 0 | primary | 2 |
| P2 Implement | 0 | primary | 20 |
| P3 Validate and Accept | 0 | primary | 45 |
| P4 Ship | 0 | primary | 0 |

P2 ended at the last P2 commit. The session paused for two days after it and resumed at P3.

## Parallelism

The run used none. The three units were small, so the agent ran them inline.

## Self-corrections

- Cycles: 0 in P3.
- One CI failure: `sync-installed.mjs --check` found the two new tests in `ravintio-zero/tests/` only. The agent copied them to `src/ravintio-zero/tests/`. The miss was avoidable. The plan did not list the source-tree copy for the new test files.
- The first full-suite run hit the 10-minute background limit before it printed a summary. A rerun with a 60-minute limit passed. This was avoidable.

## Improvement suggestions

- P1: list the `src/ravintio-zero/tests/` copy as a deliverable of each new test file.
- P3: start the full suite with a long background limit.

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 68 (run 44265835796) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | inline | 1 | 0 |
| content | inline | 2 | 0 |

Retrospective: plan/retrospectives/0000576-phase-start-time-at-phase-start-2026-11-18.md
