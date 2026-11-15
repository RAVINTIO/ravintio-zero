# Build report - 0000547-step-merge-regenerates-index

Run speed: fast

## Phases

| Phase | Tier | Agents | Wall clock (minutes) |
|-------|------|--------|----------------------|
| P0 Discovery | primary | 0 | 3 |
| P1 Plan | primary | 0 | 1 |
| P2 Implement | primary | 0 | 92 |
| P3 Validate and Accept | primary | 0 | 40 |
| P4 Ship | primary | 0 | 7 |

P2 includes a gap of about 90 minutes between the commit of the rule and the resumed session.

## Parallelism

None. The three content units share one rule text and ran inline.

## Self-corrections

- The build log lacked `RED:` and `GREEN:` markers for U-1 and U-3, and two wall-clock values were wrong. The agent fixed them before the check passed. Avoidable by writing the markers when each unit ends.
- The `Done:` line for U-3 and the first P3 block were missing after the resume. The agent wrote them from the commit history.

## Improvement suggestions

- P3: `baseline-failures.mjs check` reads `plan/current/baseline-failures.md`, which P0 did not write. The check listed all three inherited suites as new until the agent recorded them from the chart list.
- P3: a clean-clone run started as a detached subshell ended without a result. Start it with `run_in_background` instead.

Postmortems: none

Inherited failures:

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
| Longest CI run (seconds) | 293 (run 43620989602) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 3 | 0 |
- Retrospective: plan/retrospectives/0000547-step-merge-regenerates-index-2026-11-14.md
