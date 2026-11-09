---
title: "ADR 001: targeted overrides append to the named skill"
summary: "An override names its target skill in frontmatter, and setup appends it to that installed skill."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000245-boot-rules-into-skills"
---
# ADR-0228 - targeted overrides append to the named skill

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

Every override lands in the boot file, which every session loads. Task-bound rules, such as the ship PR rule, only matter in one skill. Initiative 0000238 chart pre-approved a `target:` frontmatter field for this.

## Decision

An override with `target: {skill}` is appended to the installed `{skill}/SKILL.md` between marker comments. The frontmatter is stripped. The value must match `^[a-z0-9][a-z0-9-]*$` and name an installed skill. Otherwise setup warns and uses the boot file. An override with no target is unchanged. GUTD and branch cleanup become capability skills.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep all overrides in the boot file and raise the cap | No setup change | Every session loads every rule | The entry rejects raising the cap |
| Copy overrides into a reference folder | No skill edit | The agent must know to read it | Rules would not load on demand |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `setup.sh` and `setup.ps1` gain a targeted append |

## Consequences

**Positive:**
- The boot file holds only rules every session needs.

**Negative:**
- Installed skills differ from the pack source by the appended block.

**Risks:**
- A rerun could double the block. Marker removal before each append prevents it.

## Related ADRs

- 0000029 ADR-001 - extends (boot files are disposable build outputs)

## Supersedes

- none

## Superseded By

- none
