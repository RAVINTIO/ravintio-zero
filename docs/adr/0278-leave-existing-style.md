---
title: "ADR 0278: Setup leaves an existing output style"
summary: "Setup sets outputStyle only when absent, and a flag skips the install."
status: "accepted"
component: "ravintio-zero"
feature: "0000389-writing-standard"
version: "0.1.0"
---
# ADR-0278 - Setup leaves an existing output style

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

A developer may already pick an output style in the project `.claude/settings.json`. The Claude Code docs confirm that project output styles load from `.claude/output-styles/` and that `outputStyle` takes the style name. They also confirm that a project settings file beats the user value. Overwriting a chosen style would remove the developer's choice.

## Decision

Setup writes `outputStyle: ravintio-writing` only when the key is absent. If the key holds another value, setup leaves it and prints a line. `--no-writing-style` skips the output style file, the setting, and the Codex section. Setup records the flag in the setup record and the flags marker, and `ravintio-refresh-setup` accepts it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Always overwrite | Every repo follows the standard | Removes a developer's choice | Contradicts the backlog entry |
| Write to `settings.local.json` | Not committed | Each developer must install it | The standard should reach the team |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Adds a flag to both setup scripts and to the refresh skill's allowed set. |

## Consequences

**Positive:**
- A developer keeps their own style.
- The opt-out is explicit and recorded.

**Negative:**
- A repo with another style does not get the standard in its main session.

**Risks:**
- The user-level style is overridden by the project value after install. The docs state this precedence, and the opt-out covers it.

## Related ADRs

- ADR-001 - related-to

## Supersedes

- none

## Superseded By

- none
