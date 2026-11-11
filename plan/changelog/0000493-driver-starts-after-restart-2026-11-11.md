# Changelog (0000493-driver-starts-after-restart, 11 Nov 2026)

**Feature:** Driver keeps starting steps after a Restart
**Version:** set by the merge queue at merge
**PR:** 189

## What changed

- After a Restart-only merge, the concurrent driver hands over to a successor. It starts `initiative-run.mjs --handoff {pid}`. It then writes the successor pid into the lock.
- The old driver starts no step and runs no queue after the handoff. It supervises its own sessions and exits 0 when they end.
- The successor adopts steps whose `running` file holds the old pid. It queues a step when its `ready` file appears. It restarts a step if the old pid dies.
- A blocked or failed handed-over step gets a `stopped` file. The successor stops new starts when it reads it.
- The roadmap standards, the driver header, and the initiative skill describe the handoff.
- Two new suites, `test-0000493-req-001-003-handoff` and `test-0000493-req-004-handoff-text`, cover the behaviour and the text.
- ADR 0323 records the decision.

## Why

On 2026-11-10 step 25 merged at 20:01 and changed the driver. Step 26 waited until 21:43 for steps 36, 38, and 39 to end before a new driver started it.

## Deviations

- The restart case in `test-0000379-req-002-003-005-scheduler.sh` now blocks the fast-forward with a local file. Without it, the handoff replaces the stop that the case asserts.
- The text unit (U-2) mirrored its own files into `ravintio-zero/`. The plan listed that copy under U-3.
- The TDD loop for the driver unit ran in one context. Three requirements share one script and its fixtures.

## Validation results

- The handoff suite passes 42 checks and the text suite passes 10.
- The full suite result is in the verification report.

## Skipped phases

None.
