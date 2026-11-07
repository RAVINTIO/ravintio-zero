---
title: "ADR 001: Stack and approach"
summary: "Keep Node ESM scripts and shell tests. Move Context Hygiene to a reference file."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Stack and approach

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000377-driver-stops-and-headroom
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

The design declares Node ESM scripts with no packages, Bash and PowerShell tests, and a pack of skill text. The skill is 118 bytes under its cap.

## Decision

Change the driver and watcher in place with no new dependency. Treat `Question:` with the existing open-block logic. Move Context Hygiene to a reference file instead of raising the cap.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Raise the 9000 byte cap | No move | Lets the skill grow without limit | The cap keeps boot text small |
| Separate Question matcher | Clear split | Duplicate logic | One matcher handles both markers |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Skill, scripts, standards, and tests change |

## Consequences

**Positive:**
- Later steps gain about 1,000 bytes of skill headroom.

**Negative:**
- One more reference file for the orchestrator to read.

**Risks:**
- A test that reads `SKILL.md` for the moved text fails until updated.

## Related ADRs

- none

## Supersedes

- none

## Superseded By

- none
