# Changelog (0000444-step-reads-its-queue-items, 10 Nov 2026)

**Feature:** Steps read their queue items
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- A new script, `initiative-queue.mjs`, lists the queue items whose `**Step:**` line names a step. Its `check` command fails when a named item has no committed destination and no build log report.
- The driver start and continue prompts name those items by folder name. They never carry item content.
- The `icrun-queue` rule and I-D Advance in `roadmap-standards.md` call the helper. The pickup step in the orchestrator references names it too.
- A new suite, `test-0000444-req-001-003-queue-items.sh`, covers the helper, the prompts, and the text.
- ADR 0307 records the decision.

## Why

Steps 13, 17, and 18 of initiative 0000360 missed queue items that named them. The start prompt named no item, and nothing compared the queue with the step diff. Backlog entry 0000425 asked for both.

## Deviations

- P2 ran inline without subagents, because each unit is small.
- Migration 0009 stays pending. It needs a human answer, and a step session has none.

## Validation results

- The new suite passes 7 of 26 checks before the change and 26 of 26 after it.

## Skipped phases

None.
