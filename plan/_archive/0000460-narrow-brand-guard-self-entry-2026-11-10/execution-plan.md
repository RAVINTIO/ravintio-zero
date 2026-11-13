# Execution Plan - narrow the brand guard self-entry

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000460-narrow-brand-guard-self-entry
**Version:** 0.77.1
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-exact-path-skip.md](requirements/req-001-exact-path-skip.md) | Exact-path skip, no self-entry, one rule for the hook and CI |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Security | No file other than the two named paths skips the guard | 0 look-alike paths skipped | `test-0000460-req-001-exact-path-skip.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data.

## Component Interactions

`pre-push` and `test-0000160-req-006-brand-guard.sh` both source `brand-guard.sh`. The source lives in `src/ravintio-zero/`, and `sync-installed.mjs` copies it to `ravintio-zero/`.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Edit to `brand-guard.sh` | `test-0000394-req-004-brand-guard-before-push.sh`, `test-0000160-req-006-brand-guard.sh`, `test-0000397-req-005-guards-cover-both.sh` | U-001 |
| Edit to the allowlist (row removed) | `test-0000397-req-005-guards-cover-both.sh` compares the entries with the base commit | U-001 |
| New test file | `test-0000164-req-008` style tests | U-001 |
| Non-suite file | none found | none |
| Skill count (no skill added) | none found | none |
| Skill-text budget (no `SKILL.md` edit) | none found | none |
| Size cap (no capped skill edited) | none found | none |
| Backlog entry id | 0000432 | U-001 |
| Workflow job or step edit (none) | none found | none |
| Reference file edit (none) | none found | none |
| Fixture-pinned line | none found | none |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `src/ravintio-zero/scripts/brand-guard.sh`, `src/ravintio-zero/tests/brand-guard-allowlist.txt`, `src/ravintio-zero/tests/test-0000160-req-006-brand-guard.sh`, `src/ravintio-zero/tests/test-0000397-req-005-guards-cover-both.sh`, `src/ravintio-zero/tests/test-0000460-req-001-exact-path-skip.sh` | 1 | One requirement across a script, its allowlist and their tests, so a single unit |
| U-002 | U-001 | `src/ravintio-zero/tests/README.md`, `docs/architecture-overview.md`, `docs/adr/0300-exact-path-brand-guard-skip.md` | 2 | Living docs unit. It records what U-001 built |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | Paths reach the guard relative to the repo root | The guard reports the allowlist file and fails closed |

## Open Questions

None.
