---
title: "ADR 004: Setup turns off host attribution when unset"
summary: "Setup writes empty commit and pr attribution strings to .claude/settings.json only when the key is absent."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000169-release-hygiene"
---
# ADR-0176 - Setup turns off host attribution when unset

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

Claude Code asks the agent to add attribution lines unless its `attribution` setting says otherwise. Empty `commit` and `pr` strings hide both. Checks catch the lines after the agent writes them. The setting stops them at the source.

## Decision

For the claude-code tool, `setup.sh` and `setup.ps1` add `"attribution": {"commit": "", "pr": ""}` to `.claude/settings.json` when the key is absent. They use the existing atomic settings writer. A present key, with any value, stays as it is.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Always overwrite the key | One known state | Discards a human choice | Setup never overrides a human setting |
| Set the older `includeCoAuthoredBy` flag | Older hosts read it | Deprecated, and it does not cover PR text | The current key covers both |
| No setting, checks only | No settings change | The agent keeps writing lines that checks then reject | Wastes a fix cycle on every PR |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Both setup scripts and their parity tests |

## Consequences

**Positive:**
- The host stops asking for the lines in a set-up repo.

**Negative:**
- Settings gain one more key that setup manages.

**Risks:**
- A host version that ignores the key. The check and the hook still catch the lines.

## Related ADRs

- ADR-0175 - complements (checks catch what the setting misses)

## Supersedes

- None

## Superseded By

- None
