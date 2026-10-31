---
title: "Build Report - 0000316-hooks-fail-closed"
summary: "Phase times, parallelism, and self-corrections for the run."
---
# Build Report - 0000316-hooks-fail-closed

**Run speed:** fast

| Phase | Wall clock (min) | Agents | Model tier | Parallel batches |
|-------|------------------|--------|------------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 29 | 0 | primary | 0 |
| P3 Validate and Accept | 9 | 0 | primary | 1 |
| P4 Ship | 5 | 0 | primary | 0 |

Phase times come from commit timestamps.

## Parallelism

The run ran P2 and P4 sequentially, and the standing override asks for decomposition. P2 units U2 and U3 both depend on U1 and share one command format. The edits to nine older suites were mechanical and shared one cause. A fresh agent would have needed the same context. P3 ran the full suite in the background while verification and the security review ran inline.

## Self-corrections

| Cycle | Phase | Cause | Avoidable |
|-------|-------|-------|-----------|
| 1 | P2 | Nine older suites, four regression copies, and one fixture checked the old relative command form. | Yes. The plan's test-impact scan listed seven of them. A grep over every suite for `hooks/enforcement` would have found all. |
| 2 | P2 | `test-0000035-p5-security-fixes` left `${CLAUDE_PROJECT_DIR}` unescaped under `set -u`. | Yes. Running the edited suite alone before the full run would have caught it. |
| 3 | P2 | The commit subject was 76 characters, and the commit-msg hook rejected it. | Yes. |

## Improvement suggestions

- P1: The test-impact scan should grep every suite for the wired command string, not only suites named after hooks.
- P2: Run each edited suite alone before starting the full run, which takes about 8 minutes.
- P2: A command that holds the text of a blocked action, such as a merge command in a heredoc, trips `merge-guard`. Write such files with the Write tool.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 2 (REQ-002) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000316-hooks-fail-closed-2026-10-31.md
