# Build report - 0000327-squash-before-main

**Run speed:** fast

The run took 24 minutes from pipeline start to ship. The phase rows add to 25 minutes because each row rounds up to whole minutes. The log summary reports 24.

## Phases

| Phase | Wall clock (minutes) | Agents | Tier | Parallel batches |
|-------|----------------------|--------|------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 12 | 3 | primary | 1 |
| P3 Validate | 10 | 1 | primary | 1 |
| P4 Ship | 1 | 0 | primary | 0 |

All four agent calls used the primary tier, `claude-sonnet-5-5`. The cheaper tier, `claude-haiku-5-5`, ran no agents.

## Parallelism

Three phases ran multi-task work sequentially or inline:

- P1 Plan ran inline. Its requirement files, ADR, and records share one format, so one context wrote them.
- P2 Implement ran U-002 and U-005 inline. Both were small, and U-002 depended on U-001.
- P4 Ship ran inline. The version bump, initiative update, and changelog touched shared files.

P2 ran U-001, U-003, and U-004 as three parallel subagents in batch 1. P3 ran the security review as one subagent beside the inline execution checks. The full suite ran in the background.

## Self-corrections

Two self-corrections occurred.

1. The release-tag test rejected the new CI job. This was avoidable. A test-impact scan of workflow-shape tests would have flagged that test before the full suite ran. The fix landed in a separate commit.
2. The security review fixed S-004 and S-007. This was not avoidable. The review found no critical or high finding, and cycle 1 fixed both findings with a test for S-004.

Not counted as a self-correction: U-004 added one `sed` rule to `test-0000151-req-011-orchestrator-references-split.sh`. The `feat/` to `hotfix/` wording change broke its comparison with a frozen fixture. The fixture is unchanged.

## Suggestions

- P0 and P1: no change suggested. Both phases ran cleanly and quickly.
- P2: when a change adds a CI job or workflow step, run the test-impact scan first. This catches the release-tag failure before the suite runs.
- P2: when a step changes a shared string, list the frozen fixtures that compare it. The change plan then covers them.
- P3: ask the security reviewer to check for option injection. Values that start with a dash, passed to `git`, are the pattern behind S-004.
- P4: make the summary total match the phase rows, or label it as the span from start to ship. The log currently shows 24 against a row sum of 25.
- For the human: `CLAUDE.md` and `ravintio-overrides/instructions/custom-001-local-git-only.md` still say "Work on a feat/ branch". Mark `squash-before-main` as a required check in the main ruleset.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000327-squash-before-main-2026-11-01.md
