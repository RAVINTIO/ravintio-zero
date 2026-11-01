# Security report - 0000320-quiet-session-start

**Feature:** 0000320-quiet-session-start

## Summary

**Overall risk assessment:** low
**Components reviewed:** `ravintio-zero/hooks/enforcement`, `ravintio-zero/scripts/resume-detect.mjs`, `ravintio-zero/migrations`, `ravintio-zero/skills/ravintio-migrator`
**Review scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | `resume-detect.mjs` | The script prints only fixed lines and ids that match `^\d{4}$`. Ledger and migration text never reach the output. The suite plants hostile text and checks this. | None. | mitigated |
| S-002 | low | path traversal | `resume-detect.mjs` (`Detect:` items) | An item with an absolute path or a `..` segment is false, so a migration file cannot make the script read outside the project. A symlink inside the project can still point outside. The script returns only a true or false result. | None. | mitigated |
| S-003 | low | file write | `auto-trigger-orchestrator.mjs`, `check-orchestrator-presence.mjs` | The hooks write the session id to `plan/.orchestrator-loaded`. The id is compared as a string and printed nowhere. A write failure is caught and the hook exits 0. | None. | mitigated |
| S-004 | low | file write | `migrate-migration-ledger.sh`, `.ps1` | The helpers refuse a symlink at `plan`, `plan/state`, and the ledger. They delete nothing. | None. | mitigated |
| S-005 | low | availability | `check-reply-prefix.mjs` | The reread loop waits at most 4 times 250 ms. The hook always exits 0, so it cannot block a turn. | None. | mitigated |

## Dependency audit

No new dependencies. The scripts and hooks use Node built-ins only.

## Recommendations

1. Keep the `Detect:` grammar to read-only checks. A new item type needs its own review.

## Risk register cross-check

- R-001: open, low. The migrator skips a migration that does not apply.
- R-002: accepted by the backlog entry.
- R-003: mitigated by S-001.
- R-004: accepted. The finding returns once per release.

No critical or high findings.
