---
title: "ADR-0060: One-Question-at-a-Time as Framework-Wide Instruction"
summary: "All Planifest phase skills enforce a single question per response and a recommend-then-confirm pattern, rather than leaving interaction style to individual skill authors."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000014-improve-adoption-mode-selection"
---
# ADR-0060 - One-Question-at-a-Time as Framework-Wide Instruction

**Skill:** planifest-adr-agent
**Tool:** Claude Code
**Model:** claude-sonnet-4-6
**Feature:** 0000014-improve-adoption-mode-selection
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-05-19

---

## Context

Agent interactions that present multiple questions in a single response create cognitive load for the human. The load grows in sessions that run long or involve context-switching. Analysis of prior pipeline runs showed inconsistency. The orchestrator skill stated the one-question principle but did not enforce it. Phase skills (spec-agent, adr-agent, etc.) had no equivalent instruction. For users with ADHD specifically, multiple simultaneous open questions are difficult to track. Saving items up for later loses context, and answering partially creates ambiguity about what the human addressed.

The principle "ask one question, wait for the answer, ask the next" is well-established in UX and therapeutic communication. P0 coaching for this feature identified it as a requirement that should apply across all phases, not only P0.

---

## Decision

**One-question-at-a-time is a named, explicit instruction in every phase skill.** Each of the 9 skills states the rule in these words:

> **One-question rule:** Never ask more than one question per response. Wait for the answer before proceeding. Frame every question as a recommendation with a confirmation request, not an open-ended "what do you want to do?"

The recommend-then-confirm pattern is a companion: the agent assesses and recommends, then asks the human to confirm or override. This replaces open-ended questions ("Which adoption mode?") with directed ones ("I recommend Standard Iterative based on `docs/about.md`. Does that work?").

Exception: informational multi-item output (lists, tables, summaries) is not a question, so the rule permits it.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Instruction in orchestrator only | Small change surface | Phase skills remain inconsistent; P1–P6 agents may still multi-question | Rejected — inconsistency across phases undermines trust |
| Guidance document (not in skill files) | Centralised reference | Agents don't reliably read peripheral docs; must be in-context | Rejected — instruction must be in the skill file to be in-context |
| Framework-wide instruction in all 9 skills (this decision) | Consistent behaviour across all phases | Requires editing 9 skill files; future skill authors must remember the rule | Chosen — the only approach that reliably produces consistent behaviour |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-orchestrator skill | One-question rule added |
| planifest-spec-agent skill | One-question rule added |
| planifest-adr-agent skill | One-question rule added |
| planifest-codegen-agent skill | One-question rule added |
| planifest-validate-agent skill | One-question rule added |
| planifest-security-agent skill | One-question rule added |
| planifest-docs-agent skill | One-question rule added |
| planifest-ship-agent skill | One-question rule added |
| planifest-change-agent skill | One-question rule added |

---

## Consequences

**Positive:**
- Human always knows exactly what is being asked and can give a clean, unambiguous answer
- Each question-answer exchange is a discrete, auditable event in the P0 audit trail
- Reduces session fatigue for long pipeline runs

**Negative:**
- More turns required for complex coaching conversations
- Future skill authors must be aware of the rule. Tooling does not enforce it

**Risks:**
- New skills written without the rule create inconsistency that is invisible until a user notices. Including the rule in the skill creation checklist mitigates this

---

## Related ADRs

- ADR-0059: related-to (Scope Lock Challenge applies this rule throughout)
- ADR-0061: extends (incremental audit trail depends on discrete question-answer events this rule creates)

---

## Supersedes

- None

## Superseded By

- None
