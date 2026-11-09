---
title: "ADR 0293: Archetype command"
summary: "One Node script implements archetype list and use. Setup scripts only dispatch to it."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0293 - Archetype command

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Component:** ravintio-zero
**File:** `docs/adr/0293-archetype-command.md`
**Date:** 2026-11-09T18:22:10Z

## Context

The user runs `setup.sh archetype use {kind}/{name}` on Unix and `setup.ps1` on Windows. The two scripts must behave the same. Two implementations would drift.

## Decision

`ravintio-zero/scripts/archetype.mjs` implements `list` and `use {kind}/{name}`. `setup.sh` and `setup.ps1` only dispatch to it.

`use` runs in this order:

1. Read the manifest and validate it.
2. Run the slot clash check, the file clash check against a different installed archetype, and the threshold lowering check.
3. Stop with exit 1 and write nothing if any check fails.
4. Copy the files into `ravintio-overrides/` and print each pack file that the copy replaces.
5. Record the pick in `ravintio-overrides/archetypes.json`.

A rerun of the same pick changes no file. The command refuses a path outside the repo and any symlink.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Logic in both setup scripts | No Node call | Two copies drift | Breaks parity |
| Check each file as it copies | Less memory | A late failure leaves a partial install | Breaks the atomic rule |
| Install by symlink | No copy | The resolver refuses symlinks | Conflicts with ADR-0292 |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains `archetype.mjs` and a dispatch case in `setup.sh` and `setup.ps1` |

## Consequences

**Positive:**
- Both platforms run the same code, so a parity test needs only compare output.
- A failed check leaves the repo untouched.

**Negative:**
- Setup now needs `node` for the `archetype` verb.

**Risks:**
- A crash between the copy and the record leaves files with no record. A rerun repairs it because the copy is idempotent.

## Related ADRs

- ADR-0291 - depends-on: the manifest format.
- ADR-0292 - depends-on: the resolver reads what this command installs.
- ADR-0294 - related-to: the record feeds the gate check.

## Supersedes

- None

## Superseded By

- None
