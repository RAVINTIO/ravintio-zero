# Build report - 0000555-initiative-pause-reaches-every-step

- Run speed: fast.
- Wall clock: P0 1 minute, P1 1, P2 45, P3 1, P4 8. The suites took most of P2, and the baseline and full runs went in turn because other steps loaded the machine.
- Agents: none spawned. Every unit was inline work, and each batch wrote files that its dependants read.
- Parallelism: none. U-1 and U-3 were independent but small, so they ran in turn.
- Self-corrections: 0. The prose check flagged long sentences in three artifacts, and one driver suite pinned the header length. Each fix was one edit.
- Improvement, P0: the sentinel write needs the Write tool first, because the Bash hook reads the sentinel before it runs.
- Improvement, P2: the full-suite wait needs an end marker, not `pgrep`. The run used an `EXIT` line.
- Postmortems: none.
- Inherited failures: `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`.
- Retrospective: none
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
| code | inline | 2 | 0 |
| content | inline | 2 | 0 |
