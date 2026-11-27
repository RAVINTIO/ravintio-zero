# Build report - 0000551-refuse-symlink-style-outputs

**Run speed:** fast

## Phases

| Phase | Agents | Tier | Wall clock |
|-------|--------|------|------------|
| P0 Discovery | 0 | primary | 1 min |
| P1 Plan | 0 | primary | 1 min |
| P2 Implement | 0 | primary | 32 min |
| P3 Validate | 0 | primary | 1 min |
| P4 Ship | 0 | primary | 1 min |

The wall clock of P2 includes the full suite wait.

## Parallelism

The agent ran every unit inline. Units U2 and U3 had no dependency on each other and could have run as two subagents. Each edit was too small to justify one.

## Self-corrections

- 0 cycles in P3.
- Two commits failed the prose check and the agent fixed the wording. Both were avoidable by checking the text before the commit.

## Improvement suggestions

- P0: the sentinel write blocks when it shares a call with another plan artifact (0000587). The agent split the call.
- P0: a `cd` before a write made the write guard reject relative paths (0000588). The agent used root paths.
- P2: a docs unit needed hand-added note lines beside the marker script output (0000410).

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 4 | 0 |

Retrospective: none
