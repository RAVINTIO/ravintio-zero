---
title: "ADR 0292: Override resolver and protected rules"
summary: "A resolver returns an override before the pack copy, unless protected.json says the file is hook-enforced."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0292 - Override resolver and protected rules

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Component:** ravintio-zero
**File:** `docs/adr/0292-override-resolver-and-protected-rules.md`
**Date:** 2026-11-09T18:21:30Z

## Context

A team cannot change a standard or template without editing the pack, and setup refuses that edit. Only `library-standards` reads an override first today. Some pack files carry rules that a hook enforces. An override must never relax those.

## Decision

The script `ravintio-zero/scripts/resolve-override.mjs` takes a pack-relative path and returns the path to read. It checks `ravintio-overrides/standards/` and `ravintio-overrides/templates/` before the pack copy.

The resolver also reads `ravintio-zero/archetypes/protected.json`. Each entry maps a pack-relative path to a mode:

- `ignore`: a hook enforces the whole file. The resolver always returns the pack copy.
- `require`: the entry lists pinned lines. The resolver returns the override only when it keeps every pinned line. Otherwise the pack copy wins.

The resolver refuses a path outside the repo and any symlink, and exits 1. Other scripts import the resolver. `writing-style.mjs` is the first.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Let overrides replace any file | No list to keep | An override can switch off a guard | Breaks the safety rule |
| Block the copy at install time only | No resolver check | A hand-made override skips the block | The resolver must also protect |
| Hash-pin each protected file | Strong check | Any pack edit breaks every override | Too brittle |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains the resolver and `protected.json`, and `writing-style.mjs` imports the resolver |

## Consequences

**Positive:**
- A relaxing override has no effect, so every guard stays in force.
- One module gives every reader the same lookup rule.

**Negative:**
- A maintainer must add a new hook-enforced file to `protected.json` by hand.

**Risks:**
- A stale list lets a new rule go unprotected. A test lists each protected path and fails when a listed file disappears.

## Related ADRs

- ADR-0291 - related-to: the archetype files that the resolver reads.
- ADR-0293 - related-to: the command installs the overrides.

## Supersedes

- None

## Superseded By

- None
