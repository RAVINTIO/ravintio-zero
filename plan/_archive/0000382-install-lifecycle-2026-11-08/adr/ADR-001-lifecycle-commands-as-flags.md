---
title: "ADR 001: Lifecycle commands as flags"
summary: "Update, doctor, and uninstall are flags on the tool argument."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Lifecycle commands as flags

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

The initiative chart requires an explicit `--uninstall` flag. Update and doctor need the same shape so that one parser handles all three.

## Decision

Each command is a flag that follows the tool: `--doctor`, `--update {source}`, and `--uninstall`. Setup accepts one of them per run. A lifecycle flag with a strict flag is an error. Doctor and uninstall make no clean-tree check. Update commits the pack and then runs the normal path.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Subcommands (`setup.sh update`) | Reads well | A second parser form beside the flags | The chart names `--uninstall` |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `setup.sh`, `setup.ps1`, docs, and tests change |

## Consequences

**Positive:**
- One parser form.

**Negative:**
- A flag named `--update` takes a value, unlike the other flags.

**Risks:**
- See the risk register.

## Related ADRs

- ADR-002 - related-to

## Supersedes

- None

## Superseded By

- None
