---
title: "ADR 001: One standard generates both outputs"
summary: "The standard holds marked regions, and one script prints the Claude Code and Codex outputs from them."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - One standard generates both outputs

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

The backlog entry asks for both outputs to come from the standard so they cannot drift. A Claude Code output style needs frontmatter. A Codex `AGENTS.md` section needs a short summary and markers.

## Decision

`standards/writing-standards.md` marks a `style-rules` region and a `summary` region with HTML comment markers. `scripts/writing-style.mjs <tool>` reads those regions and prints the output for `claude-code` or `codex`. Setup calls the script and writes the result. A test regenerates each output and compares it to the installed file.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Hand-copy the text into a template per tool | No script | The copies drift | The entry requires no drift |
| Copy the whole standard as the style | No regions | The style carries sections that only humans need | The prompt cost grows for no gain |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Adds a script and the regions to the standard. |

## Consequences

**Positive:**
- One edit to the standard reaches both tools.
- A test can prove there is no drift.

**Negative:**
- Setup needs node. `install_codex_hooks` already needs it, so the Claude Code path adds no new requirement and the Codex path skips with a warning if node is missing.

**Risks:**
- A maintainer edits text outside the regions and expects it to ship. The standard says so in a note above the first marker.

## Related ADRs

- ADR-002 - related-to

## Supersedes

- none

## Superseded By

- none
