---
title: "Scope - narrow the brand guard self-entry"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - narrow the brand guard self-entry

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000460-narrow-brand-guard-self-entry
**Version:** 0.77.1

## In Scope

- `brand_guard_skips_path` in `brand-guard.sh`, used by the script and the CI test.
- Removal of the self-entry row from the allowlist.
- A new suite, and an update to the 0000397 allowlist comparison.
- ADR-0298, docs, and a changelog entry.
- The sync of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- Other allowlist rows, including the row for `test-0000160-req-006-brand-guard.sh`.
- The excluded prefixes.
- The separate pack-wording allowlist in `test-0000042-req-010-pack-wording-allowlist.sh`, which has its own rows.

## Deferred

Nothing deferred.
