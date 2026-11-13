---
title: "ADR 0291: Archetype manifest format"
summary: "Each archetype is a JSON manifest plus a files folder that mirrors ravintio-overrides."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0291 - Archetype manifest format

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Component:** ravintio-zero
**File:** `docs/adr/0291-archetype-manifest-format.md`
**Date:** 2026-11-09T18:20:48Z

## Context

Teams need a catalogue of ready-made standards and templates. The `archetype` command must read each entry, check it, and copy its files. The pack scripts use Node with no packages, so a YAML parser is not available.

## Decision

Each archetype lives at `ravintio-zero/archetypes/{kind}/{name}/`. The folder holds an `archetype.json` manifest and a `files/` folder.

The manifest has these fields:

- `name`: the archetype name, equal to the folder name.
- `kind`: `alternative` or `constraint`.
- `summary`: one sentence for `archetype list`.
- `slots`: the slot names that the archetype claims.
- `thresholds`: an object that maps a threshold name to a number.
- `gates`: the gates that P3 runs. See ADR-0294.

The `files/` folder mirrors `ravintio-overrides/`. A file at `files/standards/x.md` lands at `ravintio-overrides/standards/x.md`. The format is JSON because `node` parses it with no package.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| YAML manifest | Matches `component.yml` | Needs a parser, and the scripts use no packages | Adds a dependency |
| Markdown with frontmatter | Reads well | Needs a custom parser | More code and more bugs |
| One flat folder per archetype with no kind folder | Shorter paths | No place to group by kind | `list` must read every manifest to group |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains `archetypes/` and a manifest reader in `archetype.mjs` |

## Consequences

**Positive:**
- Any script reads a manifest with `JSON.parse` and no package.
- The `files/` mirror makes the copy step a plain path join.

**Negative:**
- JSON has no comments, so a manifest explains itself only through `summary` and the README.

**Risks:**
- A manifest with a wrong field name fails late. `archetype.mjs` validates every field before it copies.

## Related ADRs

- ADR-0292 - related-to: the resolver reads the files that this layout installs.
- ADR-0293 - depends-on: the command reads this manifest.
- ADR-0294 - related-to: the `gates` field feeds the gate check.

## Supersedes

- None

## Superseded By

- None
