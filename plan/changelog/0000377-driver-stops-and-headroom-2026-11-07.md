# Changelog (0000377-driver-stops-and-headroom, 07 Nov 2026)

**Feature:** Driver stops and headroom
**Version:** 0.57.0
**PR:** 126

## What changed

- The driver and the watcher stop on an open `Question:` line, as they do on `Blocked:`. The driver does not resume the step and repeats the question in its stop line.
- The continue prompt names `Question:` as a valid place to end a turn.
- The driver runs the setup change check after the last step. It prints the `Setup:` line before `I-E Delivery: Pending:`.
- Context Hygiene moves from the orchestrator `SKILL.md` to `references/orchestrator-context-hygiene.md`, with a Pack Index row. `SKILL.md` drops from 8882 to 8608 bytes.
- Three new suites cover the changes. Backlog entries 0000371, 0000370, and 0000373 are pulled in and deleted.

## Why

An unattended step could guess an answer that only a human can give. Delivery could run on stale installed skills. The orchestrator skill had 118 bytes left under its cap.

## Deviations

- The size target is 8700 bytes, not 8000. The move alone frees 394 bytes.
- Two phases ran as forked agents.

## Validation results

- The full suite passes: 289 feature suites and 19 regression suites.
- 9 criteria verified by execution. 0 failed.
- Security review found no critical or high findings.
- The installed copy under `.claude/skills` stays stale until the coordinator reruns setup at the `Setup:` stop.

## Skipped phases

None
