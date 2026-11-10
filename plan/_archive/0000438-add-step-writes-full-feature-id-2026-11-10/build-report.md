# Build report - 0000438-add-step-writes-full-feature-id

**Run speed:** standard

## Phases

| Phase | Wall clock (minutes) | Agents | Model tier |
|-------|----------------------|--------|------------|
| P0 Discovery | 1 | 0 | primary |
| P1 Plan | 0 | 0 | primary |
| P2 Implement | 43 | 0 | primary |
| P3 Validate and Accept | 29 | 0 | primary |
| P4 Ship | 0 | 0 | primary |

The P2 and P3 time is mostly waiting on the full suite and the clean-clone run. Other sessions ran suites on the same machine.

## Parallelism

None used. Both units were too small to justify subagents. The two suite runs, the baseline and the worktree run, ran in the background.

## Self-corrections

0.

## Suggestions

- P0: the prose check rejects a passive or a long sentence in plan records, which cost two commit retries. Draft records to the 25-word limit.
- P2: do not touch tracked files such as `plan/.orchestrator-ack` while the full suite runs. The harness exits 1 when the tree changes.

Postmortems: none
Inherited failures:
- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

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
| unclassified | unclassified | 2 | 0 |
