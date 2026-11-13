# Build Report - 0000462-tests-without-git-identity

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 2 |
| P2 Implement | 0 | primary | 22 |
| P3 Validate and Accept | 0 | primary | 3 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

None used. U-001 and U-002 had no dependency, but both change the runners' test tree and a parallel run gave no gain for two small units.

## Self-corrections

None. The BOM suite found a defect in `setup.sh` that the brief did not name. That was a finding of the new test, not a failed check.

## Improvements

- P3: the clean-clone run and the in-tree run each took about 20 minutes. Start the clean-clone run as soon as P2 commits.
- P4: the PR conflicted with the initiative branch, so CI did not start and the check poll came back empty. Check `mergeable` before the poll.
- P4: a parallel step had reserved the same ADR number. See the backlog entry in the retrospective.

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`: `core.hooksPath` is unset in a clean clone.
- `test-0000318-req-004-merge-guard-pinned.sh`: the pinned `origin/initiative/0000312-guards-history-and-test-noise` ref is missing in a clean clone.

Backlog entries for these two stay with the earlier retrospective.

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
| code | inline | 1 | 0 |
| test | inline | 1 | 0 |
| unclassified | unclassified | 1 | 0 |

Retrospective: plan/retrospectives/0000462-tests-without-git-identity-2026-11-10.md
