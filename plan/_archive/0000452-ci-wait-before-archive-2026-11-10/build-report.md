# Build report - 0000452-ci-wait-before-archive

- Run speed: standard.
- Phases: P0 1 minute, P1 2 minutes, P2 43 minutes, P3 28 minutes, P4 10 minutes. No agents spawned. Model tier: primary throughout.
- Parallelism: none used. The two units edit one skill text and one standards file, and each depends on the one before.
- Self-corrections: 2 (a prose-check breach in the brief, and a test assertion that compared two items on one line). Both were avoidable by running the prose check and the test before commit.
- Improvement: P2 waited about 30 minutes for the full suite, and the clean clone in P3 waited another 25. Start the clean clone at the end of P2 so the two overlap.
- Postmortems: none.
- Inherited failures: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. Both depend on the clone. Backlog entry not filed, because the clone gap is known.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 1 | 0 |
| test | inline | 1 | 0 |

Retrospective: plan/retrospectives/0000452-ci-wait-before-archive-2026-11-10.md
