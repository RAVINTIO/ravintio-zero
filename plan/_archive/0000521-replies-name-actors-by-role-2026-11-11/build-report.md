# Build report: 0000521-replies-name-actors-by-role

Run speed: standard.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 2 | 0 | primary | 0 |
| P2 Implement | 23 | 0 | primary | 0 |
| P3 Validate and Accept | 22 | 1 | primary | 1 |
| P4 Ship | 1 | 0 | primary | 0 |

## Parallelism

The P3 docs edit pass ran as one subagent while the clean-clone suite ran. The three P2 units ran inline, because each is a small edit and U-1 and U-3 touch shared files.

## Self-corrections

None counted. The frozen-line suite and the boot template cap suite failed on the first text edit, before the unit reached GREEN. Both were avoidable. The affected-test list in the plan named neither suite, so the first edit ran without them.

## Improvement suggestions

- P1: The test impact scan should name the suites that freeze lines of a size-capped skill. Backlog entry 0000526 files this change.
- P2: `baseline-failures.mjs record` accepted the output of a clean-clone run that had not finished and recorded no failures. The agent reran it on the finished output. Backlog entry 0000525 files this change.

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`. The baseline already records it.
- `test-0000318-req-004-merge-guard-pinned.sh`. The baseline already records it.
- `test-0000450-req-004-report-format.sh`. It reads the repo root from `src/ravintio-zero/` only, so the installed copy fails it. The baseline already records it.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 343 (run 43082351391) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | inline | 1 | 0 |
| content | inline | 1 | 0 |
Retrospective: plan/retrospectives/0000521-replies-name-actors-by-role-2026-11-11.md
