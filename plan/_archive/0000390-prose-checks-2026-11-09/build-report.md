# Build report - 0000390-prose-checks

Run speed: standard.

| Phase | Agents | Tier | Parallel batches | Wall clock |
|-------|--------|------|------------------|------------|
| P0 | 0 | primary | 0 | 2 min |
| P1 | 0 | primary | 0 | 0 min |
| P2 | 3 | primary | 1 | 60 min |
| P3 | 1 | primary | 0 | 0 min |
| P4 | 0 | primary | 0 | 0 min |

P2 wall clock includes long waits for the full suite on a shared machine.

- Parallelism: U3, U4, and U5 ran in one batch. U1 and U2 ran inline because later units import them. U6 ran inline.
- Self-corrections: 3, all avoidable. The brand and wording tests should have been in the test impact scan. A sibling copy of the commit-msg test and the PowerShell twin of a pin were missed.
- Improvement (P1): the test impact scan lacks a cause for a new tracked file that holds file names, such as the baseline.
- Improvement (P2): write the tests before the code for the shared module.
- Postmortems: none
- Inherited failures: `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`. Backlog entries are not offered because earlier runs already track them.
- Retrospective: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-003) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
