# Build report: 0000493-driver-starts-after-restart

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 2 | 0 | primary | 0 |
| P1 Plan | 2 | 0 | primary | 0 |
| P2 Implement | 51 | 1 | primary | 1 |
| P3 Validate and Accept | 23 | 1 | primary | 1 |
| P4 Ship | 1 | 0 | primary | 0 |

## Parallelism

P2 ran the text unit in a subagent while the driver unit ran in the main context. P3 ran the docs edit pass in a subagent while the full suite ran in the background. The driver unit ran inline because three requirements share one script and one fixture.

## Self-corrections

One. The text suite compared the two pack trees with a path that fails from `ravintio-zero/tests/`. The fix was avoidable if the unit had run its suite from both trees. Postmortem `2026-11-11-tree-comparison-path.md` covers it.

## Improvement suggestions

- P2: Brief each unit that writes a test to run it from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/`.
- P2: The agent typed the RED and GREEN marker times and did not read the clock for each. The existing typed-marker-times postmortem covers the gap.
- P3: The full suite took about 22 minutes while other steps ran. Nothing new to file.

Postmortems: plan/postmortems/2026-11-11-tree-comparison-path.md

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-004) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 3 | 1 |

Retrospective: plan/retrospectives/0000493-driver-starts-after-restart-2026-11-11.md
