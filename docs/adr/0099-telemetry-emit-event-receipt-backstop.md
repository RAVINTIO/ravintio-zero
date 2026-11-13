---
title: "ADR 001: Telemetry emit_event receipt backstop"
summary: "Extends the existing check-telemetry-failures.mjs hook family with a PostToolUse receipt writer for emit_event, closing the remaining half of backlog 0000044 (agent-driven emit_event calls verified, not just claimed)."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000027-backlog-batch-governance-tooling-fixes"
---
# ADR-0099 - Telemetry emit_event receipt backstop

**Skill:** [adr-agent](../skills/adr-agent-SKILL.md)
**Feature:** 0000027-backlog-batch-governance-tooling-fixes
**Component:** planifest-framework
**Date:** 2026-08-08

## Context

Backlog `0000044` (this feature's req-004) reported two related findings from feature `0000025`'s own P0-P2 self-audit. First, the orchestrator missed an unacknowledged `plan/.telemetry-failures/` marker at a phase boundary. Second, agent-driven `emit_event` calls (`spec_gap`, `adr_decision`, etc.) never ran, although build-log recorded `Telemetry: emitted`. Each phase skill's own `## Telemetry` section specifies those calls. Feature `0000026` (folded in from the same backlog entry) already shipped `check-telemetry-failures.mjs`. That read-only `UserPromptSubmit` hook surfaces an `additionalContext` reminder when an unacknowledged failure marker exists, which closes finding 1. Finding 2 remains open. Nothing today verifies that a phase's claimed `emitted` status corresponds to an actual tool call. This is consistent with `ADR-0073`'s "deterministic caps/budgets/ratchets, never skill prose alone" precedent.

## Decision

Add a `PostToolUse` hook matched on the `emit_event` MCP tool call (`mcp__structured-telemetry-mcp__emit_event`, per the tool's actual invocation name). On a successful call, the hook writes a durable local receipt file under `plan/.telemetry-receipts/{phase}-{event_type}-{ISO-8601-timestamp}.marker`. The file contains the event envelope's `phase_name`/`event_type` fields. Extend `check-telemetry-failures.mjs` to cross-reference, at each `UserPromptSubmit`, the current phase's expected agent-driven event types against receipts present for that phase. Alternatively, add a narrowly-scoped sibling hook in the same family. The implementer chooses at P3 based on what keeps the diff smallest. The expected event types come from the invoking phase skill's own `## Telemetry` section, or from a small static table derived from it. Inject an `additionalContext` reminder if an expected event type has no corresponding receipt once the phase has otherwise completed its build-log entry. This hook is read-only and advisory like its sibling, per the existing hook family's design: it never blocks, never decides, and only surfaces.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A new standalone verification hook unrelated to `check-telemetry-failures.mjs` | Clean separation of concerns | Duplicates the existing `UserPromptSubmit` reminder-injection plumbing; two near-identical hooks to maintain | Extending the existing hook reuses proven plumbing and keeps the telemetry-backstop surface in one family |
| Rely on P8 build assessment to audit `emit_event` compliance after the fact | No new hook code | Backward-looking only; a whole pipeline run could complete non-compliant before anyone notices, same failure mode this ADR exists to close | Contradicts the "deterministic, not after-the-fact" requirement in req-004 |
| Require the orchestrator to self-report emit_event calls in build-log only (status quo, strengthened by prose) | No implementation cost | This is exactly the mechanism that already failed once (0000025's own self-audit) — prose reminders don't survive task pressure | Rejected per `ADR-0073`'s explicit precedent against prose-only enforcement |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework | New `PostToolUse` receipt-writing hook; `check-telemetry-failures.mjs` (or sibling) gains a second check mode; `.claude/settings.json` hook registration gains one entry |
| setup-hook-integration | `setup.sh`/`setup.ps1` must install and register the new receipt-writing hook alongside the existing telemetry hooks, gated by the same unified telemetry signal |

## Consequences

**Positive:**
- Closes the second half of backlog `0000044` without introducing a new hook family. The orchestrator's `Telemetry: emitted` claim becomes independently checkable rather than self-attested.

**Negative:**
- One more hook entry to install, register, and keep in parity across `setup.sh`/`setup.ps1`. This is a small addition to the surface `req-001` already touches in this same feature.

**Risks:**
- If the receipt-writing hook itself fails silently (e.g. the MCP tool name changes), the cross-reference check would have nothing to compare against. It could then produce false-negative reminders (looks compliant when it isn't). Mitigate by routing the receipt hook's own failure through the existing `plan/.telemetry-failures/` marker mechanism, consistent with how other telemetry hooks already report their own failures.

## Related ADRs

- ADR-0073 - depends-on (deterministic enforcement precedent)
- ADR-0080 - extends (telemetry failure detection and interactive recovery)

## Supersedes

- None

## Superseded By

- None
