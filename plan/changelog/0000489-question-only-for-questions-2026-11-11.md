# Changelog (0000489-question-only-for-questions, 11 Nov 2026)

**Feature:** Steps use Question only for real questions
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- Rule `icrun-question-real` in `roadmap-standards.md` says that a `Question:` line asks the human a question and ends with a question mark. A step that waits for its own work keeps working, and a step session cannot schedule a wakeup.
- The orchestrator `SKILL.md` and `pipeline-reference.md` describe `Question:` the same way.
- `check-reply-prefix.mjs` warns on a final reply whose `Question:` status line has no question mark. It logs a `question:` line to `plan/.prefix-misses.log` and still exits 0.
- Two new suites, `test-0000489-req-001-question-wording.sh` and `test-0000489-req-002-question-check.sh`, cover the text and the hook.
- ADR 0317 records the decision.

## Why

On 2026-11-10 step 31 ended its turn with `I-C Run: Question: step 31 is partway through` while it waited for its suites. The driver stops on a `Question:` line, so the line looked like a stop for the human.

## Deviations

- P2 ran inline without subagents, because the units share the Question wording.
- The check tests for a question mark only. It cannot tell a false question that holds one.

## Validation results

- The text suite passes 8 of 8 checks and the hook suite 15 of 15. Each failed before its change.
- The full suite result is in the verification report.

## Skipped phases

None.
