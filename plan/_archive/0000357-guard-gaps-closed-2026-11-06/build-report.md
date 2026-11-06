# Build report - 0000357-guard-gaps-closed

Run speed: standard

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) |
|-------|--------|------------|----------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 29 |
| P3 Validate and Accept | 0 | primary | 12 |
| P4 Ship | 0 | primary | 2 |

Wall clocks come from the recorded phase timestamps, which are coarse. P0 and P1 ended on typed times that the first draft got wrong, and the log now holds clock readings only.

## Parallelism

None used. P2 ran its units inline. U-001 and U-003 share both setup scripts, and U-002 and U-004 are a few lines each.

## Self-corrections

- REQ-001: the hook filter, hook parity, and setup hardening suites pinned the old guard command text. Avoidable: the plan's test impact scan named them, but the plan did not budget the edits.
- REQ-003: `test-0000316` counted one Codex hook and now counts two. Avoidable: the scan named it.
- REQ-002: the first guard draft blocked a commit message that held `$` and passed `git${IFS}add`. Avoidable: a probe script before P3 would have found both.

## Improvements

- P2: the forced-add guard blocks any shell text that names the command, including test and edit scripts. Write such text with the Write or Edit tool, or in a script file.
- P2: write build-log times from `date -u`, never by hand. Two typed times were in the future and needed a fix.

Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
