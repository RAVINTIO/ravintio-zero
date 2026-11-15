# Build report - 0000570

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 31 |
| P3 Validate and Accept | 1 | primary | 1 |
| P4 Ship | 0 | primary | 0 |

## Parallelism

The baseline run and the post-change run ran side by side in the background. The units ran inline.

## Self-corrections

One commit hook rejected two sentences over 25 words in the P0 files. The agent split them. The fix was avoidable.

## Improvements

- P0: the writing standard's sentence limit trips on list items that carry two ideas. Draft discovery notes in short sentences.

## Postmortems

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

These match the chart's known baseline failures. No backlog entry is offered for them.

## Workflow governance

Breaches: 0.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 1 | 0 |

Retrospective: plan/retrospectives/0000570-sibling-test-copies-in-impact-scan-2026-11-15.md
