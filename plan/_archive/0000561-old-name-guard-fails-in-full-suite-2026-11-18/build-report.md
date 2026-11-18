# Build report - 0000561-old-name-guard-fails-in-full-suite

**Run speed:** fast

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) | Parallel batches |
|-------|--------|-----------|----------------------|------------------|
| P0 Discovery | 0 | primary | 2 | 0 |
| P1 Plan | 0 | primary | 2 | 0 |
| P2 Implement | 0 | primary | 44 | 0 |
| P3 Validate and Accept | 1 | primary | 2 | 0 |
| P4 Ship | 0 | primary | not recorded | 0 |

## Parallelism

None used. The change was one inline unit. The full suite ran in the background while the agent waited, and the docs unit waited on the sync.

## Self-corrections

None. Two commit-time prose checks failed on a passive phrase and on long sentences. The agent fixed each at once. Both were avoidable by a check before the commit.

## Suggestions

- P0: write the brief and design through `prose-check.mjs check` before the first commit.
- P2: the baseline and the full suite each took about 20 minutes. Starting the full run before the docs commit would save one wait.

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Deviations

The chart row offered a stable copy of the tree or a fix to an earlier suite. The cause was a flaky allowlist match, so the fix removed the pipe to `grep -q`.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 363 (run 44268599394) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 1 | 0 |
Retrospective: plan/retrospectives/0000561-old-name-guard-fails-in-full-suite-2026-11-18.md
