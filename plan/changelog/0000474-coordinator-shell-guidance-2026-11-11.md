# Changelog (0000474-coordinator-shell-guidance, 11 Nov 2026)

**Feature:** Coordinator shell guidance
**Version:** set by the merge queue at merge
**PR:** #182

## What changed

- `roadmap-standards.md` gains the section Coordinator shell tasks (rule `coord-shell-tasks`). It names bash and tells the coordinator to write scripts with the Write tool. It lists three snags:
  - `set -- $x` in zsh.
  - The `$b:r` modifier in zsh.
  - `$'` in a JavaScript `replace`.
- `scripts/initiative-queue.mjs drain --step {n}` removes the queue items of a merged step.
- `scripts/bulk-edit.mjs {spec.json}` applies literal edits from a JSON spec file. `--dry-run` previews them.
- The initiative skill points to the section and to the drain command.
- Tests: `test-0000474-req-001-004-shell-section-and-guards.sh`, `test-0000474-req-002-queue-drain.sh`, and `test-0000474-req-003-bulk-edit.sh`.
- ADR 0316 records the decision.

## Why

Shell snags cost the coordinator time from 2026-11-08 to 2026-11-10 (backlog entry 0000437). The advice in three build reports never reached a standard.

## Deviations

None. The overlap check stays in `coordinator-pr-check.mjs`, as the plan assumed. The change does not touch `merge-guard` or `block-forced-add`.

## Validation results

Full suite from `src/ravintio-zero/tests/run-tests.sh`, 4 shards: 426 feature suites and 19 regression suites passed, 0 failed.

## Skipped phases

None.
