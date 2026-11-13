---
title: "ADR 003: Scope Lock Suggested Answers via On-Demand Subagent"
summary: "The orchestrator always offers a suggested-answer option at each Scope Lock Challenge question, but only dispatches the drafting subagent on explicit human request — never pre-emptively — keeping scope decisions human-owned while offering drafting help."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000017-ratchet-forgery-detection-and-telemetry-schema-spec"
---
# ADR-0077 - Scope Lock Suggested Answers via On-Demand Subagent

**Skill:** [adr-agent](../../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Tool:** claude-code
**Model:** claude-sonnet-5
**Feature:** 0000017-ratchet-forgery-detection-and-telemetry-schema-spec
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-07-25

---

## Context

During this session's own Scope Lock Challenge, the orchestrator initially answered scenario questions from a build/pipeline perspective rather than a feature-usage perspective. This required repeated human correction on four points:
- build-vs-usage framing
- outcome-vs-action framing for tooling/process items
- N/A recognition for static content with no runtime state
- a hard rule that no item is ever confirmed without an explicit human affirmative

The human wants this rigor available as drafting help for future features, but without it becoming a rubber stamp. Offering a suggested answer by default could push humans toward passive acceptance rather than active scope decisions.

---

## Decision

At each Scope Lock Challenge question, the orchestrator always asks the human first. It always offers a "want me to suggest an answer?" option and never skips it silently. It dispatches the drafting work (a new `planifest-scope-lock-agent` skill/subagent) only on explicit human request, never pre-emptively.

The rigor spec, hardened through this session's live corrections, governs the subagent's draft:
- Usage-only framing: describes only how the finished feature behaves for people using it, never the build/pipeline/implementation process
- Outcome, not action: for tooling/process items, describes the resulting state a user/reader/operator experiences, never the act of running a tool
- Explicit N/A recognition: when a scenario question doesn't meaningfully apply, says so with a reason rather than manufacturing an artificial narrative
- Consistency check: checks the suggestion against the latest confirmed decisions for that item. It explicitly flags any contradiction, unresolved concern, or gap the plain-usage phrasing exposes, and never smooths it over. It skips silently only when no confirmed decisions yet exist to check against
- No implicit confirmation: a draft never confirms itself. Only an explicit human affirmative per item counts, and the orchestrator never reads silence, no-objection, or topic-change as approval. The orchestrator writes every explicit confirmation to `build-log.md` immediately as the durable record

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Always pre-draft a suggested answer automatically | Faster for the human — no need to ask | Risks passive rubber-stamping of drafts the human didn't actually request; contradicts the human's explicit instruction this session | Rejected per direct human instruction |
| Never offer suggested answers — human must always answer from scratch | Guarantees active engagement, zero rubber-stamping risk | Loses the drafting assistance the human explicitly wants available | Rejected — the human wants the option, just not forced |
| Offer on every question, draft only on explicit request (this decision) | Assistance available without being pushed; the ask itself keeps the human in an active decision-making frame | Adds one extra exchange (offer, then possible request) per question when the human does want a draft | Chosen — matches the human's explicit instruction and preserves active engagement |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| `planifest-orchestrator` skill | Scope Lock Challenge section updated to always offer the suggested-answer option |
| `planifest-scope-lock-agent` (new skill) | Authored under req-005 to implement the rigor spec above |

---

## Consequences

**Positive:**
- Scope decisions stay human-owned even when drafting help is used
- The same rigor spec caught a real gap in this session's own dogfooding (the 0000008 hand-typing-reliability gap, surfaced by forcing plain-usage phrasing). It now becomes a repeatable mechanism for future features

**Negative:**
- Adds a new skill file to maintain. Also adds a new protocol step (the offer) to every Scope Lock Challenge question, even when the human never requests a draft

**Risks:**
- The consistency-check and confirmation-discipline rules depend on the agent reading `build-log.md` faithfully on resume. If the agent ever skips that durable-record convention, the "no implicit confirmation" guarantee weakens to trust alone. The decision mitigates this through req-005's explicit requirement that the agent writes every confirmation to `build-log.md` immediately

---

## Related ADRs

- ADR-007 (0000014) derived-scope-lock-scenarios - extends (adds a suggested-answer capability on top of the existing agent-derived-scenario mechanism)
- ADR-008 (0000014) one-question-at-a-time - related-to (the offer-then-draft flow still asks one question at a time)

---

## Supersedes

- None

## Superseded By

- None

---

*Generated by adr-agent.*
