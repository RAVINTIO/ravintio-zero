# Build report - 0000395-pack-prose-to-the-standard

- Run speed: standard
- Agents: 16 in total. 14 slice units, 1 second pass, and 1 docs reviewer. All ran on the primary tier at high effort.
- Wall clock per phase: see the End and Wall clock rows in `build-log.md`.
- Parallelism: batch 1 ran U1 to U7, batch 2 ran U8 to U14. The second pass and the docs review ran alone.
- Self-corrections: 7. Five tests, two fixtures, and one allowlist row. Avoidable with a plan scan for wording pins.
- Improvement: add a prose rewrite cause to the test impact scan (backlog entry 0000418).
- Postmortems: `plan/postmortems/2026-11-09-prose-rewrite-wording-pins.md`
- Inherited failures: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. The backlog holds no entry for them yet.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 5 (REQ-002) | 2 | breach |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | primary | 13 | 0 |
| unclassified | unclassified | 2 | 5 |

Retrospective: plan/retrospectives/0000395-pack-prose-to-the-standard-2026-11-09.md
