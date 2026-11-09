---
title: "ADR 002: Keep developer files at install"
summary: "Setup moves a developer CLAUDE.md aside, copies whole skill folders, and prunes retired commands by manifest."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000381-setup-safety"
---
# ADR-0269 - Keep developer files at install

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Setup overwrites `CLAUDE.md` (0000290), copies only `SKILL.md` of a capability skill (0000289), and leaves retired commands (0000293).

## Decision

A boot file without the line `# RAVINTIO Zero - Mandatory Pipeline Rules` is the developer's. Setup copies it to `ravintio-overrides/instructions/original-{boot file name}` before the write, and never overwrites an existing file there. Capability skills copy with `cp -R` and a PowerShell recursive copy. Setup records pack commands in `.claude/commands/.ravintio-manifest`, removes a listed file the pack stopped shipping, and removes the three retired names when their `name:` line matches. Migration 0008 applies the same removal.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Back up to a `.bak` file | No override change | The content never reaches the new `CLAUDE.md` | Fails the wanted outcome |
| Delete retired commands by name only | No manifest | Removes a developer file of the same name | Weakens developer ownership |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `setup.sh`, `setup.ps1`, migrations, and tests change |

## Consequences

**Positive:**
- A developer keeps their content and their commands.
- Capability skills work with their references.

**Negative:**
- Two more files in the install.
- A developer file named like a retired command and holding that name line is removed.

**Risks:**
- See the risk register.

## Related ADRs

- ADR-0268 - related-to

## Supersedes

- None

## Superseded By

- None
