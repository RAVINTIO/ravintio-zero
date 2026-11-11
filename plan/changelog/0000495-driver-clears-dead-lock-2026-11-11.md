# Changelog (0000495-driver-clears-dead-lock, 11 Nov 2026)

**Feature:** Driver clears a dead lock
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The driver reads `plan/.initiative-runner.lock` when the `wx` write fails. If the lock holds only the pid of a process that no longer runs, the driver prints the pid and takes the lock.
- A pid that runs, text that is not a pid, and a symlink still refuse. The driver leaves the file alone in each case.
- The driver header, the roadmap standards, and the architecture overview state the rule.
- A new suite, `test-0000495-req-001-002-dead-lock`, covers the behaviour and the text.
- ADR 0324 records the decision.

## Why

On 2026-11-10 at 19:05 a driver left its lock with the pid of a process that no longer ran. The next driver refused to start, and the coordinator removed the file by hand.

## Deviations

- The three requirements and the ADR share one script, so the agent ran every unit in one context with no subagents.

## Validation results

- The new suite passes 34 checks. The full suite shows no new failure and 3 inherited failures.

## Skipped phases

None.
