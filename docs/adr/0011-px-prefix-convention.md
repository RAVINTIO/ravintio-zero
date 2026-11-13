---
title: "ADR-0011: Px prefix convention for pipeline phase indicators"
summary: "Every Planifest pipeline agent response begins with Px: where x is the phase number (0–7). PC: is used by the change-agent. This is a UX convention embedded in all agent SKILL.md files — costly to reverse once deployed."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000003-hook-based-enforcement"
---
# ADR-0011 - Px prefix convention for pipeline phase indicators

**Skill:** [adr-agent](../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Tool:** claude-code
**Model:** claude-sonnet-4-5
**Feature:** 0000003-hook-based-enforcement
**Component:** planifest-framework/skills/
**Status:** accepted
**Date:** 18 Apr 2026

---

## Context

Planifest pipeline runs involve multiple agents across 8 phases (P0–P7) plus a Change Pipeline route. Humans working on a feature may lose track of which phase they are in, particularly after context resets, multi-day sessions, or phase skips. There is no ambient UI indicator of the current phase. The agent's text response is the only channel available.

Multi-agent pipelines compound the problem because different SKILL.md files load at different phases. The human cannot tell from the response alone whether they are talking to the spec-agent, codegen-agent, or ship-agent.

---

## Decision

Every Planifest pipeline agent response begins with `Px:` where x is the phase number (0–7):

| Agent | Prefix |
|-------|--------|
| planifest-orchestrator | P0: (during Phase 0), P1: (when facilitating Phase 1), etc. |
| planifest-spec-agent | P1: |
| planifest-adr-agent | P2: |
| planifest-codegen-agent | P3: |
| planifest-validate-agent | P4: |
| planifest-security-agent | P5: |
| planifest-docs-agent | P6: |
| planifest-ship-agent | P7: |
| planifest-change-agent | PC: (Change Pipeline — not a numbered phase) |

Standard formats:
- Phase open: `Px: Starting {phase-name} — {one-liner description}`
- Phase close: `Px: {phase-name} complete. Artefacts: {list}. Next: {next-phase-name}.`
- Escalation: `Px: ⚠ {escalation message requiring human input}`
- Skip: `Px: Skipped by human direction.`
- Resume: `Px: Resuming {feature-id} — {phase-name} in progress.`

Every agent SKILL.md specifies the convention, and `getting-started.md` documents it.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| No prefix (agent names itself in prose) | Natural language, flexible | Inconsistent; easy to omit; hard to scan quickly; not grep-able | Unreliable; LLMs vary in how they identify themselves |
| Tool-level UI indicator (e.g. session title) | Not in agent response; ambient | Requires tool-level customisation per tool; not portable across 9 tools | Cannot guarantee it works on all supported tools |
| Structured JSON metadata header per response | Machine-readable; unambiguous | Degrades human readability; not conversational | This is a human-in-the-loop system; readability matters |
| Emoji-only prefix (🔵 P1, 🟢 P2 …) | Visually distinct | Accessibility concerns; not keyboard-searchable; emoji rendering varies by terminal | Text `Px:` is universally renderable and grep-able |
| Phase name only (e.g. `[SPEC]:`) | Readable | Longer; inconsistent casing and format risk; change-agent naming ambiguous | Numeric `Px` is shorter, unambiguous, and sortable |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| All 8 phase SKILL.md files | Must specify Px prefix rule and standard formats |
| `planifest-framework/skills/planifest-change-agent/SKILL.md` | Must specify `PC:` prefix |
| `planifest-framework/getting-started.md` | Must document Px convention with phase table |
| `planifest-framework/skills/planifest-orchestrator/SKILL.md` | Must specify the phase it is in when facilitating each downstream agent |

---

## Consequences

**Positive:**
- Humans can immediately identify which phase they are in from any response
- Phase open/close formats provide a consistent rhythm to pipeline execution
- `Px: ⚠` escalations are visually distinct and searchable in session history
- Convention is self-documenting: seeing `P3:` tells the human "codegen is running"

**Negative:**
- Every SKILL.md file needs updating and must stay in sync. If someone adds a new agent without the prefix rule, the convention breaks down
- The convention still depends on LLM instruction compliance, because no hook forces the prefix. A non-compliant response has no deterministic catch mechanism
- Once humans become accustomed to the convention, removing or changing it is disruptive

**Risks:**
- Claude Code may occasionally omit the prefix on short conversational responses. The SKILL.md should require the prefix on **every** response, including single-line acknowledgements.

---

## Related ADRs

- ADR-0010 - related-to (ship-agent resume detection uses phase state that Px communicates)

---

## Supersedes

- None

## Superseded By

- None

---

*Generated by adr-agent. Path: `plan/current/adr/ADR-0011-px-prefix-convention.md`*
