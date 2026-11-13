---
title: "ADR 003: Scope Lock Default-Drafted, Batch-Presented Answers"
summary: "The Scope Lock Challenge now dispatches planifest-scope-lock-agent for all four scenario-path questions in parallel by default and presents all four drafts together for one batch review pass, with per-item explicit accept/edit/reject still required and recorded immediately — narrowly scoped against ADR-0060, which remains in force everywhere else."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000025-pipeline-gate-and-config-fixes-and-ship-agent-fixes"
---
# ADR-0097 - Scope Lock Default-Drafted, Batch-Presented Answers

**Skill:** [adr-agent](../../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Tool:** claude-code
**Model:** claude-sonnet-5
**Feature:** 0000025-pipeline-gate-and-config-fixes-and-ship-agent-fixes
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-08-03

---

## Context

`ADR-0077` ("Scope Lock Suggested Answers via On-Demand Subagent") established that the orchestrator's Scope Lock Challenge always asks each scenario-path question one at a time. The four questions are happy path, first-run path, error/sad path, and cross-session continuity. It also always offers "want me to suggest an answer first?" in the same turn. It dispatches `planifest-scope-lock-agent` only on explicit human request, never pre-emptively. The decision guarded against passive rubber-stamping of unrequested drafts.

Two backlog entries subsequently reversed that judgment from lived experience:

- `plan/backlog/0000029-scope-lock-drafts-always-presented/entry.md` (filed from feature 0000022's own P0). The offer-then-opt-in flow adds a round trip per question. That means up to eight exchanges for four answers. The entry says the cost comes `with no governance benefit: the human's explicit per-item accept/edit/reject remains the only thing that counts either way`. The human directed that the draft should always be there when the orchestrator asks the question.
- `plan/backlog/0000040-scope-lock-default-to-drafted-answers/entry.md` (filed from feature 0000017's own P0): the human called the opt-in-only default "a bug". They separately asked the orchestrator to present all four drafts together in one batch. The alternative was one-at-a-time sequencing, which waits for a per-question answer before drafting or showing the next.

`req-007-scope-lock-default-drafted-batch.md` (this feature) merges both entries into a single requirement with four parts:

- Dispatch `planifest-scope-lock-agent` for all four scenario-path questions in parallel by default.
- Present all four together.
- Have the human complete one review pass while still giving a separate explicit accept/edit/reject per item.
- Write each item's `build-log.md` entry immediately on that item's own confirmation.

req-007 explicitly assigns authoring the superseding ADR to P2 (this ADR) as a hard dependency. It also explicitly calls out that the reversal must be scoped narrowly against `ADR-0060` (One-Question-at-a-Time as Framework-Wide Instruction). That keeps it from reading as a silent framework-wide reversal of that convention.

This ADR supersedes `ADR-0077` for the Scope Lock Challenge specifically.

---

## Decision

The Scope Lock Challenge changes from sequential, opt-in-per-question drafting to default-drafted, batch-presented drafting:

1. **Default parallel dispatch, no opt-in.** The orchestrator dispatches `planifest-scope-lock-agent` for all four scenario-path questions in parallel, by default. The four are happy path, first-run path, error/sad path, and cross-session continuity. The dispatch happens before the orchestrator presents any question to the human. The orchestrator no longer makes the per-question "want me to suggest an answer first? yes/no" offer. A human request no longer gates drafting. Each dispatch remains a fresh-context subagent scoped to exactly one question. It receives the same inputs as the prior on-request dispatch. These are the scenario-path question, the feature brief, and the requirements/ADRs confirmed so far. They also include the latest confirmed decisions to check against, if any exist yet. It does not receive the coaching conversation history.
2. **Batch presentation.** The orchestrator presents all four questions together with their labelled drafts in a single turn. It does not present one question at a time, waiting for an answer before drafting or showing the next.
3. **Per-item confirmation remains unchanged and non-negotiable.** The human reviews the batch in one pass but still gives a separate, explicit accept / edit / reject for each of the four items individually. The orchestrator never reads a blanket or implied confirmation across multiple items as approval for any of them. The moment the human gives that explicit affirmative for one item, the orchestrator records it to `plan/current/build-log.md` immediately. It uses the existing capture format and source labels (`agent-draft-accepted` / `agent-draft-edited` / `human`). It does not defer the write until the human confirms the whole batch.
4. **Partial-failure fallback.** If one of the four parallel dispatches fails, the orchestrator presents the three successful drafts plus a clear failure marker for the fourth. It falls back to the original blank-question, opt-in flow for that one item only. A single failed dispatch never blocks or discards the rest of the batch.
5. **`planifest-scope-lock-agent`'s invocation contract remains unchanged.** Fresh-context subagent, single-question scope, never self-confirms, never advances the Scope Lock sequence, never writes `build-log.md` itself. Only the trigger (automatic-by-default vs. on-explicit-request) and the batch cardinality (four dispatched together vs. one at a time) change. The five drafting rules in `planifest-scope-lock-agent/SKILL.md` stay as they were and remain fully authoritative. They are usage-only framing, outcome not action, N/A recognition, consistency check, and no implicit confirmation.

**Explicit scope bound against `ADR-0060`:** This change applies **only** to the Scope Lock Challenge's four scenario-path questions. `ADR-0060`'s one-question-at-a-time convention remains in force everywhere else in the framework. These points still ask one question at a time with recommend-then-confirm:

- Coaching Q&A.
- Clarifying questions raised when a Scope Lock answer reveals a gap.
- Phase gates.
- Every other human-interaction point in the pipeline.

The Scope Lock Challenge's four questions are a fixed, enumerable, non-branching set uniquely suited to batching. Open-ended coaching differs because its next question depends on the prior answer. Batching drafting and presentation does not weaken confirmation into a blanket approval. Per-item accept/edit/reject remains individually gated and individually recorded. This is a narrow, named exception, not a framework-wide reversal.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep on-demand, per-question opt-in (status quo, ADR-0077) | Minimal exchange when a draft isn't wanted; preserves active per-question engagement | Adds up to 8 exchanges for 4 answers; no governance benefit since accept/edit/reject already gates approval regardless of drafting cadence | Human explicitly called it "a bug" (backlog 0000040); the offer step protects nothing the per-item confirmation doesn't already protect |
| Always draft, but still present one question at a time | Removes the opt-in friction while keeping a la carte per-question attention | Retains up to 4 sequential round trips; leaves the second stated friction (wanting a single batch review) unresolved | Backlog 0000040 explicitly requests batch presentation together with default-drafting; a partial fix leaves the friction the human named unresolved |
| Always draft all four in parallel and batch-present, with a single blanket accept for all four | Fastest possible flow — one exchange total | Directly violates scope-lock-agent's "no implicit confirmation" rule and ADR-0077's core governance property (approval must be per-item and explicit) | req-007 explicitly requires a separate affirmative per item; batching approval itself would erode scope integrity, not just drafting cadence |
| Default-drafted, batch-presented, per-item explicit accept/edit/reject (chosen) | Eliminates both stated frictions (opt-in ask, sequential round-trips) while preserving the one governance property that actually matters — the human's explicit per-item decision | On partial dispatch failure, requires a defined fallback path for the failed item, adding one more branch to implement and test | Matches req-007's functional requirements and both backlog entries' explicit human direction exactly |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| `planifest-orchestrator` skill | Scope Lock Challenge section rewritten: removes the per-question opt-in offer, adds default parallel dispatch of all four `planifest-scope-lock-agent` calls, batch presentation, per-item confirmation/build-log capture unchanged, and the new partial-failure fallback path |
| `planifest-scope-lock-agent` skill | Description/Invocation Contract updated to reflect default, parallel, per-question dispatch (trigger and cardinality only) — drafting rules and output format untouched |

---

## Consequences

**Positive:**
- Eliminates up to eight sequential exchanges (offer, then possible request, times four) down to one dispatch batch plus one review pass. This directly resolves the friction the human called "a bug" in backlog 0000040. It also resolves the redundant round-trips backlog 0000029 flagged.
- This ADR fully preserves Scope Lock's per-item governance discipline: fresh-context subagent per question, usage-only framing, consistency-check flagging, explicit accept/edit/reject, and immediate build-log write. Only the drafting trigger and presentation cadence change, not the confirmation mechanism itself.

**Negative:**
- Four parallel subagent dispatches now happen on every Scope Lock Challenge run, unconditionally. This includes items where the human would have declined a draft under the old opt-in flow. That is a real, if small, increase in agent/token spend versus the zero-dispatches-unless-requested baseline.
- The new partial-failure fallback is a more complex failure mode to implement and test correctly than the uniform single-question flow it replaces. It shows three successful drafts plus a failure marker for the fourth. It reverts only that item to the blank-question opt-in flow.

**Risks:**
- The human or a future implementer could misread the single batch-review turn as inviting one blanket approval across all four items. If so, the "no implicit confirmation" rule could silently erode. req-007's explicit acceptance criterion mitigates this. So does rule 5 of `planifest-scope-lock-agent/SKILL.md`, which remains unchanged and fully authoritative.
- Without this ADR's explicit boundary, a future reader could misread the reversal as license to batch other one-question-at-a-time flows (coaching Q&A, phase gates). The Decision section above forecloses that reading by name.

---

## Related ADRs

- ADR-0077 (Scope Lock Suggested Answers via On-Demand Subagent) - conflicts-with (this decision reverses its never-pre-draft, offer-then-opt-in default for the Scope Lock Challenge specifically. See Supersedes below)
- ADR-0060 (One-Question-at-a-Time as Framework-Wide Instruction) - related-to (this ADR carves a narrow, explicitly bounded exception for the Scope Lock Challenge's four scenario-path questions only. ADR-008's convention remains in force everywhere else in the framework)
- ADR-0059 (Derived Scope Lock Scenarios over Fixed Checklist) - related-to (unaffected. This ADR changes only the drafting/presentation cadence of the four scenario questions, not how the framework derives them)

---

## Supersedes

- ADR-0077 - Scope Lock Suggested Answers via On-Demand Subagent (this ADR supersedes it for the Scope Lock Challenge specifically. See `docs/decisions-index.md` for the cross-feature status update)

## Superseded By

- None

---

*Generated by adr-agent.*
