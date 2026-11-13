---
title: "ADR 001: Ratchet-Approve: Agent Write on Explicit Instruction"
summary: "Reverses ADR-0070's human-only-write restriction: the agent may write plan/current/.ratchet-approve, but only when the human explicitly instructs it in the moment, removing hand-typing unreliability while keeping the approval single-use, auditable, and structurally separated from the weakening it authorizes."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000017-ratchet-forgery-detection-and-telemetry-schema-spec"
---
# ADR-0075 - Ratchet-Approve: Agent Write on Explicit Instruction

**Skill:** [adr-agent](../../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Tool:** claude-code
**Model:** claude-sonnet-5
**Feature:** 0000017-ratchet-forgery-detection-and-telemetry-schema-spec
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-07-25

---

## Context

0000016's ADR-0078 established `plan/current/.ratchet-approve` as a marker file. Only the human may create or edit it. It holds one repo-relative path per line and authorizes a ratchet weakening. In practice this creates a reliability problem. The human must hand-type the exact path from memory, with no assistance. The marker also captures no record of *why* the human approved the weakening, only that they did.

Walking this mechanism through in plain usage language during this session's Scope Lock Challenge (rather than abstract mechanism-talk) surfaced the gap directly. ADR-0078's original design never resolved "no way a human will reliably maintain this correctly by hand". The hard prohibition on agent writes solved forgery but not usability, and the design conflated the two.

---

## Decision

Reverse ADR-0078's core restriction. The agent MAY write `plan/current/.ratchet-approve`, but only when the human explicitly instructs it in the moment. The human states the path, the reason, and the go-ahead in the same turn. This removes the hand-typing reliability problem: the agent transcribes the human's exact words instead of the human hand-typing a path from memory.

The line format extends ADR-0078's "one path per line, optional trailing comment" to `path | reason | timestamp`, using the human's exact reason text verbatim and never paraphrased. The agent must commit the write immediately, in its own dedicated commit, before any further work (including the guarded weakening edit) proceeds. This makes the added trust in the agent safe. The process structurally forces the approval and the weakening it authorizes into separate, independently reviewable commits.

The decision keeps ADR-0078's same-uncommitted-changeset detection as a hook-level backstop at consumption time. The backstop now surfaces an explicit message to the approver, naming the pending path and instructing them to commit it first, rather than blocking silently. This catches the case where the agent skipped the immediate-commit step, as intentional defense-in-depth rather than upfront prevention alone.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep ADR-0078's human-only-write restriction; add external tooling to help humans type the marker correctly | No new trust extended to the agent | Doesn't fix the underlying problem — still requires the human to correctly operate a separate tool outside the chat session; adds a new dependency | Rejected — friction moved, not removed |
| Agent may write freely, without requiring an explicit human go-ahead in the same turn | Zero human friction | Reopens exactly the forgery risk ADR-0078 was created to close | Rejected — defeats the purpose of human-gated approval |
| Agent may write only on explicit in-the-moment instruction (this decision) | Removes hand-typing error while keeping a human speech-act as the trigger; reason captured in the human's own words | Requires trusting the agent to transcribe accurately and to write only when actually instructed | Chosen — commit-immediately + backstop bounds the residual risk |
| Structured approval command (e.g. a slash command) instead of free chat instruction | More rigid, less ambiguous parsing | Adds a new interface surface; doesn't match how approvals happen in this framework today (in conversation) | Rejected as unnecessary process overhead |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework (`ratchet-check.mjs`) | Marker-consumption logic extended: parses `path \| reason \| timestamp`, copies the full record to the permanent audit log, surfaces an explicit message on an uncommitted-approval block |
| `plan/current/.ratchet-approve` | Format changed from bare path list to `path \| reason \| timestamp`; agent-writable under the new instruction-gated condition |

---

## Consequences

**Positive:**
- Removes the single biggest usability failure mode in ADR-0078's original design (hand-typing unreliability) without reopening the forgery risk
- The reason is now captured in the human's own words in the audit trail, not only a bare path

**Negative:**
- The agent now has a code path capable of writing an enforcement-relevant file, which did not exist under ADR-0078's original prohibition. Even though explicit instruction gates it, this is more capability than before

**Risks:**
- An agent could misinterpret an ambiguous chat message as "explicit instruction" and write the marker prematurely. The decision mitigates this by requiring path, reason, and go-ahead in the same turn before it permits the write, plus the immediate-commit and backstop defense-in-depth

---

## Related ADRs

- ADR-0078 (0000016) - amends

---

## Supersedes

- ADR-0078-ratchet-approval-marker-file (0000016), specifically its `Agents are prohibited from creating or editing the marker` restriction and its one-path-per-line format. The decision retains the single-use, path-scoped, git-tracked, hook-consumed nature of the mechanism.

## Superseded By

- None

---

*Generated by adr-agent.*
