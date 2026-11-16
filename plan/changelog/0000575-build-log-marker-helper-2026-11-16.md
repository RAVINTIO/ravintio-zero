# Changelog (0000575-build-log-marker-helper, 16 Nov 2026)

**Feature:** Build log marker helper
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The new script `build-log-mark.mjs` reads the clock and appends a `RED:`, `GREEN:`, or `Done:` line to the build log.
- The implement skill rule `implement-inline-unit` names the script for each line. The governance and dispatch standards name it next to the marker forms.
- Two suites cover the script and the wiring. ADR 0348 records the decision.

## Why

Step 51 of an earlier initiative typed its RED and GREEN times by hand. The times were approximate.

## Deviations

- The agent ran units U1 to U3 inline in one tree and dispatched no subagent, because each unit is small.
- Unit U3 (docs) has no executable check. Backlog 0000410 tracks the rule.

## Validation results

Recorded at P3.

## Skipped phases

None.
