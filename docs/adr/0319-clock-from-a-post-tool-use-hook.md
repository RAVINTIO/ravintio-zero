---
title: "ADR 0319: The clock comes from a PostToolUse hook"
summary: "A PostToolUse hook gives agents the local time after every tool call, so no reply or log line holds an estimated time."
status: "accepted"
component: "ravintio-zero"
feature: "0000499-reply-times-match-clock"
version: "0.1.0"
---
# ADR-0319 - The clock comes from a PostToolUse hook

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Component:** ravintio-zero
**File:** `docs/adr/0319-clock-from-a-post-tool-use-hook.md`
**Date:** 2026-11-11

## Context

On 2026-11-11 step 27 printed reply times 10 to 13 minutes ahead of the clock. Step 43 read `date +%H:%M` once and estimated every later time. A step session is one long turn. The Stop hook runs once at the end of it, so it never sees the progress lines that drift.

## Decision

A `PostToolUse` hook, `clock-context.mjs`, returns the local `hh:mm` in `additionalContext` after every tool call. The agent then holds a fresh time. Rule `reply-time-form` requires every timestamp to come from a clock read at that moment. The reply Stop hook now warns at a 2 minute gap and on a status outside the allowed list. The watcher stamps each activity line with its own clock. All three only warn or add context, and none blocks a turn (0000200 ADR-002).

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Text rule only | No code | Agents already estimate despite the rule | The rule has failed twice |
| Block a reply with a wrong time | The time is always right | A Stop hook cannot undo earlier lines. It widens hook power | Warn only, as ADR-002 sets |
| Stamp every log line in the driver | One source of truth | Needs a wider driver change and hides the agent's error | The watcher stamp covers the feed |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New hook, setup wiring, rule text, a tighter reply check, and a stamped watcher feed |

## Consequences

**Positive:**
- The agent always holds a fresh time.
- The activity feed stays right when an agent's time is wrong.

**Negative:**
- Every tool call adds one short line of context.
- The 2 minute margin warns on a reply that follows a long tool call.

**Risks:**
- Claude Code might not pass `additionalContext` for `PostToolUse`. The rule text then remains the only control.

## Related ADRs

- 0305 - extends: the clock check of the reply hook.
- 0318 - related-to: the Question check in the same hook.
- 0000200 ADR-002 - extends: hooks warn and never block.

## Supersedes

- None.

## Superseded By

- None.
