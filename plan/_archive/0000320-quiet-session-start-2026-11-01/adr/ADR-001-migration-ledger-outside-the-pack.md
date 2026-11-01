---
title: "ADR 001: migration ledger outside the pack"
summary: "Migration state lives in plan/state/migrations.md, and a Detect line lets the script see a condition turn true."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Migration ledger outside the pack

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Component:** ravintio-zero
**Date:** 2026-11-01

## Context

The migrator records a finished migration by moving its file into `ravintio-zero/migrations/_done/`. A pack update replaces that folder and ships each migration as pending again. The move also edits the pack, which entry 0000299 makes setup refuse when uncommitted. Migrations that never apply stay pending forever and appear in every finding.

## Decision

Keep migration state in the tracked file `plan/state/migrations.md`, outside the pack. Each row is `| {id} | done or not applicable | {pack version} |`. `resume-detect.mjs` reads it. The migrator appends to it and no longer moves files. A migration file may carry a `**Detect:**` line of read-only path checks, so the script can see a condition turn true without parsing prose. Migration 0006 copies the existing `_done/` files into the ledger.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep `_done/` and add a marker file | No new format | The pack update still resets it | Same defect |
| Evaluate `Applies when:` prose in the script | No new line | Prose is not machine-readable | Fragile |
| Store state in an ignored file | No tracked churn | A fresh clone loses it | Findings return on every clone |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New ledger, script change, migrator change, migration 0006 |

## Consequences

**Positive:**
- A pack update keeps finished migrations quiet.
- The migrator never edits the pack.

**Negative:**
- Each migration author adds a `Detect:` line to see a condition turn true.
- A new tracked file changes on each recorded migration.

**Risks:**
- A malformed ledger row. The script ignores a row that fails the id pattern.

## Related ADRs

- none

## Supersedes

- none

## Superseded By

- none
