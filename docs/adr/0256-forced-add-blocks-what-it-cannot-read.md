---
title: "ADR 003: The forced-add guard blocks what it cannot read"
summary: "block-forced-add.mjs adds git stage, splits on subshell characters, and blocks a variable in a git add segment. Codex gets the guard."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000357-guard-gaps-closed"
---
# ADR-0256 - The forced-add guard blocks what it cannot read

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Date:** 2026-11-06

## Context

Feature 0000317 blocks `git add -f` by reading each command segment. The security report rated three gaps medium: `git stage -f`, a subshell, and a flag held in a variable. Codex has no forced-add guard. The CI ignored-file check is the only backstop.

## Decision

Treat `stage` like `add`. Split the command on `(`, `)`, `{`, `}`, and the backtick as well as the current separators. Block a segment that holds `$` when its git subcommand is `add`, `stage`, or a variable. Also block a variable glued to `git`, because the guard can't read the value. A commit message that holds `$` passes. The chart row asks for this, as `merge-guard` blocks what it can't parse. Wire the same guard into Codex as a second Bash group, because the Codex hook model already runs `merge-guard` that way.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Resolve variables in the guard | No false positives | The guard would run shell text | It must never run the command text |
| Rely on the CI check | No hook change | Catches the file after the push | The chart rejects it |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `block-forced-add.mjs`, both setup scripts, and `hook-enforcement.md` |

## Consequences

**Positive:**
- Claude Code and Codex both block each form in entry 0000341.

**Negative:**
- The guard blocks a harmless `git add "$f"`. The caller names the path instead.

**Risks:**
- Text that mentions `git add` and `$` in a commit message trips the guard. The message points to the Write tool, as it does today.

## Related ADRs

- ADR-0255 - related-to
- ADR-0237 - extends

## Supersedes

None.

## Superseded By

None.
