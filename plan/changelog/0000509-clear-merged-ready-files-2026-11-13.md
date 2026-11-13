# Changelog (0000509-clear-merged-ready-files, 13 Nov 2026)

**Feature:** Driver clears ready files of merged steps
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- At start, the driver clears the `ready` file of each merged step. It prints `I-C Run: Cleared: step {n} ready file of a merged step` for each file it removes.
- The driver keeps the file while a live pid sits in the step's `running` file, or when the removal fails. It prints `I-C Run: Kept: step {n} {reason}`. A kept file never stops the run.
- The pass removes no other control file and skips a driver that takes over with `--handoff`.
- The driver header and the "Concurrent steps" section of the roadmap standards state the rule.
- A new suite, `test-0000509-req-001-003-clear-ready`, covers the behaviour and the text.
- ADR 0340 records the decision.
- The first session of this step also filed backlog entry 0000530 for the coordinator oversight queue item.

## Why

On 2026-11-11 the coordinator removed 7 `ready` files of merged steps by hand. Only the queue deleted control folders, and only for a step that reached it in the current run.

## Deviations

- The three requirements and the ADR share one script, so the agent ran every unit in one context.
- The first session ended after it filed the queue item. This session found no build log, one commit, and no PR, so it ran P0 to P4 from the start.

## Validation results

See the build log.

## Skipped phases

None.
