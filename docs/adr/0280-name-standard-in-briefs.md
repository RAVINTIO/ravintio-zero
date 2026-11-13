---
title: "ADR 0280: Briefs name the standard"
summary: "Output styles reach only the main session, so dispatch prompts and the driver name the standard."
status: "accepted"
component: "ravintio-zero"
feature: "0000389-writing-standard"
version: "0.1.0"
---
# ADR-0280 - Briefs name the standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

The Claude Code docs state that subagents run their own system prompt, so an output style does not reach them. A step session is a main session, but it uses fixed prompt text that tests pin.

## Decision

The Agent Dispatch Template names `ravintio-zero/standards/writing-standards.md` in its skeleton prompts. The driver adds `--append-system-prompt` with one line that names the standard, and leaves the `Run initiative step {n}` prompt unchanged.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Append to the step prompt | One argument | Changes a pinned prompt that resume detection reads | Risk to resume detection |
| Rely on the output style | No change | Subagents and Codex steps miss it | The entry names both |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Edits `agent-dispatch-standards.md` and `scripts/initiative-run.mjs`. |

## Consequences

**Positive:**
- Subagents and step sessions read the standard.

**Negative:**
- Each prompt grows by one sentence.

**Risks:**
- A future driver change drops the argument. A driver test pins it.

## Related ADRs

- ADR-001 - related-to

## Supersedes

- none

## Superseded By

- none
