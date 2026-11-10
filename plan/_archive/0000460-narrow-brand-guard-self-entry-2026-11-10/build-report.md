# Build Report - 0000460-narrow-brand-guard-self-entry

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 2 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 26 |
| P3 Validate and Accept | 0 | primary | 22 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

None used. Each phase held one unit, so no batch had two independent units.

## Self-corrections

- Substring match in the new suite: the skipped-path check matched a look-alike path. Avoidable by matching whole lines.
- A self-entry check that was too strict: it flagged an older row with a bare-dot path regex. Avoidable by reading the allowlist before writing the check.

## Improvements

- P0: the build log times came from a typed value once. Read the clock for every log line.
- P2: the baseline run took longer than the build. Start it as the first P0 action, before the artifacts.
- P3: the full suite takes about 13 minutes in a clean clone. Start it as soon as P2 commits.

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`: `core.hooksPath` is unset in a clean clone.
- `test-0000318-req-004-merge-guard-pinned.sh`: the pinned `origin/initiative/0000312-guards-history-and-test-noise` ref is missing in a clean clone.

Backlog entries for these two stay with the retrospective.


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
| unclassified | unclassified | 1 | 0 |

Retrospective: plan/retrospectives/0000460-narrow-brand-guard-self-entry-2026-11-10.md
