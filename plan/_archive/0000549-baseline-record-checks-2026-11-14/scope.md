---
title: "Scope - 0000549-baseline-record-checks"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000549-baseline-record-checks

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000549-baseline-record-checks
**Version:** 0.115.0

## In Scope

- `record` exits 2 with one stderr line when the input has no `Feature suites:` line.
- `check` exits 1 with `no baseline recorded` on stderr when the baseline file is missing.
- Tests for both cases in `test-0000385-req-002-baseline-failures.sh`.
- Update to the script header comment and the pinned AC-3 text that said a missing file is an empty baseline.

## Out of Scope

- Making `clean-clone-test.mjs` or the P0 start action run `record`.
- Changing how `check` reads runner output.
- Report inherited and new suites (gap: out of scope).

## Deferred

Nothing deferred.
