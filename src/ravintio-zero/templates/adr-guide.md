# ADR - Guide

> How the plan phase writes Architecture Decision Records, and how to read them.

*Related: [Plan Skill](../skills/ravintio-plan/SKILL.md) | [design requirements Guide](design-spec-guide.md)*

---

## Purpose

An ADR captures a single architectural decision - the context that demanded it, the decision itself, the alternatives considered, and the consequences. ADRs are the institutional memory of WHY the system has its shape. Without them, the next agent (or human) making a change has no idea why someone chose the current design, and may undo a deliberate trade-off.

---

## Who Writes It

The **plan skill** produces ADRs during the plan phase (P1). It reads the Execution Plan and OpenAPI Specification (if applicable) as input. Each significant decision gets its own ADR.

---

## What Counts as "Significant"

A decision needs an ADR if:
- It affects more than one component
- It chooses between two or more viable alternatives
- It has consequences that constrain future decisions
- It involves a trade-off (performance vs. simplicity, cost vs. availability, etc.)

A decision does NOT need an ADR if:
- It's the only reasonable option (e.g., "use UTF-8 for text encoding")
- It's dictated by the stack declaration (the stack choice itself may need an ADR, but each consequence of it doesn't)

---

## Section-by-Section Guidance

### Context

State the question clearly. Not "we need a database". Write "the auth-service needs to persist user sessions across server restarts, with sub-10ms read latency for session validation and automatic expiry after 7 days."

### Decision

State what you decided and why. Be specific enough that someone reading this in 6 months understands the reasoning without needing to ask you.

### Alternatives Considered

At least 2 alternatives for every ADR. For each: pros, cons, and why you rejected it. This is the evidence that the decision was deliberate.

| âŒ Bad | ✅ Good |
|--------|---------|
| "We considered MySQL but chose PostgreSQL" | "MySQL: lower operational overhead (+), limited JSON support for our use case (-), no native row-level security (-). Rejected because the data contract requires JSONB columns and row-level access policies." |

### Consequences

What follows from this decision - both positive and negative. State the trade-offs plainly.

---

## Lifecycle

ADRs are **immutable once accepted**. If a decision changes:
1. The old ADR gets `status: superseded` and a `Superseded By: ADR-NNN` link
2. A new ADR records the new decision and references the old one
3. The old ADR is never deleted or modified

This preserves the decision history.

---

## Numbering

Repo-wide and never renumbered. Reserve each number with `node ravintio-zero/scripts/reserve-id.mjs --file docs/adr/.next-id`. Gaps are acceptable (an ADR abandoned before acceptance retires its number).

---

## File Location

`docs/adr/{NNNN}-{kebab-case-title}.md`

---

*Template: [adr.template.md](adr.template.md)*
