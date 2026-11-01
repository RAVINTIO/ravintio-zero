# Changelog (0000320-quiet-session-start, 1 Nov 2026)

**Feature:** Quiet session start
**Version:** 0.46.0
**PR:** pending

## What changed

- The load instruction fires once per session. `auto-trigger-orchestrator.mjs` records the session id in the ignored file `plan/.orchestrator-loaded`, and the advisory banner of `check-orchestrator-presence.mjs` follows the same rule.
- `resume-detect.mjs` reads the ledger `plan/state/migrations.md`. A `done` row gives no finding. A `not applicable` row gives none at the same pack version unless the migration's `**Detect:**` line is true.
- The migrator appends ledger rows and edits nothing inside `ravintio-zero/`. Migration 0006 and its helpers copy the `_done/` records into the ledger. Migrations 0004 and 0005 gain a `**Detect:**` line.
- `check-reply-prefix.mjs` checks `last_assistant_message` and exits silently when it finds no final reply.
- Four new suites cover the four requirements. Four older hook suites reset the session record between calls.

## Why

A signal that repeats trains the reader to ignore all signals. Backlog entries 0000307, 0000282, and 0000322 asked for each signal to speak only when it needs action.

## Deviations

The hook adds `plan/.orchestrator-loaded` to `.git/info/exclude`, as `check-reply-prefix.mjs` does for its log. Setup needs no change.

## Validation results

- The full suite passes: 248 feature suites and 19 regression suites. The consistency and self-description checks are clean.
- Execution checks of the hooks, the script, and the Stop hook verified 13 criteria. None are `not-verifiable` or docs only.
- The security review found no critical or high findings.
- After the version bump, `resume-detect.mjs` lists no migration 0004 and no migration 0005 in this repo.

## Skipped phases

None
