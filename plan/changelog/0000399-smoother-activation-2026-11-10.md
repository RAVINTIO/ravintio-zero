# Changelog (0000399-smoother-activation, 10 Nov 2026)

**Feature:** Smoother activation
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- `initiative-activate.mjs` activates a charted initiative after one confirmation. It runs the checks, pushes the branch, lands the coordinator PR, merges it, and prints the driver and watcher commands.
- `initiative-add-step.mjs` adds a step. It reserves the ids, files the backlog entry, and writes the row in every chart table.
- `coordinator-pr-check.mjs` prints `plan-only` after the plan format checks when only `plan/` files changed.
- The initiative skill and the roadmap standards state the question rule: restate the request, name the default, ask "Go?", ask one question per reply.
- `resume-detect.mjs` prints no pending line for a migration whose `Detect:` line matches nothing. Migrations 0004, 0005, and 0008 no longer show here.
- Both start-up hooks name the initiative skill for a coordinator session with an active initiative or a charted draft.

## Why

The human found I-B Activate of initiative 0000360 slow. Backlog entry 0000398 lists the causes.

## Deviations

- The activate script prints the driver and watcher commands. The coordinator starts them as background tasks.
- The presence hook still acts only while `plan/.orchestrator-active` exists.
- The first Detect rule missed stale ledger rows. A postmortem records the fix.

## Validation results

- Working tree suite: 382 feature suites and 19 regression suites passed.
- Clean clone: 380 passed. Two suites fail on the base commit too: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`.
- Security review: low risk, no open finding.

## Skipped phases

None.
