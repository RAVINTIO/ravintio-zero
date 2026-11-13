---
title: "ADR 0342: Step sessions receive the clock"
summary: "The driver records hook events in each step log, and a check fails a log that shows no clock."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0342 - Step sessions receive the clock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Component:** ravintio-zero
**File:** `docs/adr/0342-step-sessions-receive-the-clock.md`
**Date:** 2026-11-13

## Context

Step 51 (ADR-0319) added the `clock-context.mjs` hook. On 2026-11-11 step 48 wrote the reply time 20:12, and the human read 21:12. The step log held no `Local time:` line, so nothing showed whether the session received the hook output.

The agent ran a short `claude -p` session with the driver's flags and `--include-hook-events`. The `PostToolUse` hook returned `Local time: 04:20` and the model reported 04:20. A headless session receives the hook output and reads it.

The step log could not show this. The driver did not pass `--include-hook-events`, so stream-json held only `SessionStart` hook events. Step 48 started at 2026-11-11T20:12:40Z, and the machine zone is `Europe/London`. The reply time 20:12 matched the machine clock.

## Decision

The driver adds `--include-hook-events` to every step session, so the step log holds each hook response. A new script, `step-clock-check.mjs {log}`, exits 1 when a log holds tool calls and no `PostToolUse` response with `Local time: hh:mm`. It exits 0 for a log with clock output or with no tool calls, and 2 for a usage error. The check reads one file and prints counts, never log text.

The step adds no time zone setting. If the human's clock differs from the machine zone, the human sets `TZ` for the driver.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Put the time in the driver prompt | The model reads it at once | The value goes stale in a long step, which is the original fault | The hook already supplies a fresh value |
| Run a real `claude` session in CI | Tests the whole chain | Needs credentials and costs money on every run | CI holds no credentials |
| Set a time zone for the step | Matches the human's clock | The machine zone is the source of truth for every other time | The zone is the human's setting |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` gains one flag. `step-clock-check.mjs` is new. `roadmap-standards.md` states both. |

## Consequences

**Positive:**
- The step log shows what each hook returned, so a missing clock has evidence.
- The check finds a silent step in one command.

**Negative:**
- Each tool call adds hook events to the log, so logs grow.

**Risks:**
- A later CLI renames the flag. The check fails on a real log with no hook events.

## Related ADRs

- ADR-0319 - related-to: the clock hook that the check looks for.

## Supersedes

None.

## Superseded By

None.
