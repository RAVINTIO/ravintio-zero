# Build report - 0000507-hook-check-after-setup

**Run speed:** standard

## Phases

| Phase | Wall clock (minutes) | Agents | Parallel batches |
|-------|----------------------|--------|------------------|
| P0 Discovery | 379, including a pause from 07:25Z | 0 | 0 |
| P1 Plan | 1 | 0 | 0 |
| P2 Implement | 42 | 0 | 0 |
| P3 Validate and Accept | 22 | 0 | 0 |
| P4 Ship | 0 | 0 | 0 |

## Parallelism

- No phase used a subagent. The three P2 units form three dependent batches in the Concurrency plan, so none could run together.
- The full suite and the baseline run went in parallel in P2.

## Self-corrections

- One. P3 execution verification showed that a missing guard script passed the check, because `guard-run.mjs` exits 2 for a script it cannot run. The agent added the launcher-line rule. The plan could have caught it, so it was avoidable.

## Improvement suggestions

- P0: write the pause record and queue answer into one step so a design question does not leave a session idle for hours.
- P1: list each way the checked component can produce its pass signal (filed as backlog entry 0000529).
- P2: a background test run that dies with the session leaves no baseline. Run the baseline in a scratch clone at once.
- P3: the clean-clone suite ran for about 22 minutes and printed no progress in quiet mode.

## Postmortems

- `plan/postmortems/2026-11-12-missing-guard-passed-hook-check.md`

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh` fails on the base commit in a clean clone.
- `test-0000318-req-004-merge-guard-pinned.sh` fails on the base commit in a clean clone.
- `test-0000450-req-004-report-format.sh` fails on the base commit. Migration 0009 archived ADR 0314.

This run files no entry for them. Entry 0000529 covers the process gap.
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-002) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 376 (run 43241613073) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 4 | 1 |
Retrospective: plan/retrospectives/0000507-hook-check-after-setup-2026-11-12.md
