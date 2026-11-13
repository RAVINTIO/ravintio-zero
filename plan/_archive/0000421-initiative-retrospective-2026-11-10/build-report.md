# Build report - 0000421-initiative-retrospective

**Run speed:** standard

| Phase | Wall clock (min) | Agents | Parallel batches | Notes |
|-------|------------------|--------|------------------|-------|
| P0 Discovery | 1 | 0 | 0 | Self-confirmed design. Migration 0009 left pending. |
| P1 Plan | 1 | 0 | 0 | No ADR. Artifacts written inline. |
| P2 Implement | 9 | 3 | 1 | Three research agents in one batch. |
| P3 Validate and Accept | 21 | 0 | 0 | Clean clone suite took about 20 minutes. |
| P4 Ship | 0 | 0 | 0 | Version set by the merge queue. |

## Parallelism

Phase P2 ran three research units in parallel. The record and the entries ran in order, because the entries need the record's findings.

## Self-corrections

None. The prose check rejected four commits and each fix took one edit. All were avoidable by running `prose-check.mjs` before the commit.

## Improvement suggestions

- P0: run the baseline suite in the background at start, as the start actions require. This run missed it.
- P2: tell research subagents they cannot write files and must return text, so they spend no turns on the refused write.
- P3: run the prose check on plan files before the first commit.

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`: fails in a clean clone, passes in the worktree.
- `test-0000318-req-004-merge-guard-pinned.sh`: fails in a clean clone, passes in the worktree.

Retrospective: `plan/retrospectives/0000360-backlog-sweep-retrospective.md`

## Workflow governance

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
| content | primary | 2 | 0 |
| unclassified | unclassified | 3 | 0 |
