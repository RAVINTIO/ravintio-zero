# Build report - 0000397-pack-source-in-src

Run speed: standard.

## Phases

| Phase | Agents | Tier | Wall clock (minutes) | Parallel batches |
|-------|--------|------|----------------------|------------------|
| P0 Discovery | 0 | primary | 2 | 0 |
| P1 Plan | 0 | primary | 3 | 0 |
| P2 Implement | 7 | primary | 115 | 2 |
| P3 Validate and Accept | 1 | primary | 20 | 0 |
| P4 Ship | 0 | primary | 1 | 0 |

## Parallelism

- P2 ran U4, U5, and U6 as one batch of three, then four test-fix tracks (U3a to U3d) as one batch of four.
- P1 wrote its artifacts inline. The requirement files and ADR are independent, so a fast run could have split them.

## Self-corrections

- REQ-003: the first suite run from the source failed 43 suites on repo-root paths. Avoidable, because a path move needs a scan for root lookups.
- REQ-005: the prose baseline keys by path. Avoidable by the same scan.
- REQ-003: three whole-repo scan tests read the wrong root from the installed folder. Avoidable if P2 ran the suite from both folders before P3.

## Improvement suggestions

- P1: add a `Path move` cause to the test impact scan (backlog 0000419).
- P2: run the suite from both folders before the refresh commit.
- P3: record the baseline failures at P0, as Discovery Start Actions step 15 says. This run recorded them at P3.

Postmortems: `plan/postmortems/2026-11-09-tests-assumed-pack-at-repo-root.md`, `plan/postmortems/2026-11-09-prose-baseline-keyed-by-path.md`.

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh` fails in any clone, because it needs local git config. Not filed, since CI runs in a configured checkout.
- `test-0000318-req-004-merge-guard-pinned.sh` fails in any clone, because it needs an `origin` ref. Not filed, for the same reason.

Retrospective: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 2 (REQ-003) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | primary | 2 | 0 |
| unclassified | unclassified | 6 | 3 |
