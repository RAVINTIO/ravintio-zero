---
title: "ADR 001: setup.ps1 writes the same hook entries as setup.sh"
summary: "setup.ps1 wires all six enforcement hooks in the setup.sh entry shape, and a static suite checks the match."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000035-powershell-setup-parity"
---
# ADR-0121 - setup.ps1 writes the same hook entries as setup.sh

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

`setup.sh` wires six enforcement hooks. Each `PreToolUse` hook gets one `Write` entry and one `Edit` entry. `setup.ps1` wires four hooks and puts `gate-write` in a single `Write|Edit` entry. Nothing checks the two scripts against each other, so the gap went unseen (backlog 0000090).

## Decision

1. `Merge-EnforcementHookSettings` writes the same entries as `setup.sh`, in the same order. The design lists them.
2. Before it adds entries, it removes every `PreToolUse` entry whose command names one of the three `PreToolUse` modules, on any matcher. This also clears the old `Write|Edit` entry.
3. A static suite reads both scripts, lists the modules wired per event, and fails on any difference.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep `Write|Edit` and add the two hooks to it | Smaller change | A project set up from both scripts gets two different shapes, and `setup.sh` keeps the other one | Parity is the goal |
| Generate both scripts' hook lists from one shared file | One source of truth | A new build step for a patch release | The parity suite catches drift at lower cost |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.ps1` hook wiring, new parity suite |

## Consequences

**Positive:**
- Windows installs gain ratchet protection and the em-dash guard.
- The next omission fails a suite on its first run.

**Negative:**
- The parity suite parses script text, so a refactor of either script's hook block may need a suite update.

**Risks:**
- R-002: an old `Write|Edit` entry survives a re-run. Decision 2 and a suite cover it.

## Related ADRs

- ADR-0119 - related-to (every write still goes through `Write-SettingsAtomic`)

## Supersedes

- None

## Superseded By

- None
