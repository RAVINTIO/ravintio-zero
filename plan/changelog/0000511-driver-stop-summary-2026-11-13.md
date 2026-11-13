# Changelog (0000511-driver-stop-summary, 13 Nov 2026)

**Feature:** Driver prints a stop summary
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- Every driver run now prints a summary block before its final line. The stop line or the `I-E Delivery:` line stays last. Each line starts with `I-C Run: Summary:`.
- `merged this run:` lists the steps the run merged, or `none`.
- `driver fixes:` counts the repairs the driver made by itself. One `fix:` line repeats each of the first 10.
- `action for the human:` ends the block. It reads `none` after a clean end, and names one action for a pending delivery, a `Restart:` stop, a `Setup:` stop, or any other stop.
- The summary changes no exit code and no existing line.
- The driver header and the "Concurrent steps" section of the roadmap standards state the rule.
- A new suite, `test-0000511-req-001-003-stop-summary`, covers the behaviour and the text.
- ADR 0341 records the decision.
- The first session of this step also filed backlog entry 0000532 for the queue item on self-matching `pgrep` waits.

## Why

At each driver stop, the human read many lines to learn what happened and whether they must act. The coordinator gathered the rest by hand.

## Deviations

- The three requirements and the ADR share one script, so the agent ran every unit in one context.
- The first session ended after it filed the queue item. This session found no build log, one commit, and no PR, so it ran P0 to P4 from the start.

## Validation results

See the build log.

## Skipped phases

None.
