---
title: "ADR-0046: Hook adapter architecture — delegating to shared enforcement scripts"
summary: "Hook adapters delegate to shared enforcement scripts (gate-write.mjs, check-design.mjs) via spawnSync rather than containing enforcement logic inline. This formalises the existing delegating pattern and deprecates self-contained adapters."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000011-setup-parity-and-consistency"
---
# ADR-0046 - Hook adapter architecture: delegating to shared enforcement scripts

**Skill:** adr-agent
**Tool:** Claude Code
**Model:** claude-sonnet-4-6
**Feature:** 0000011-setup-parity-and-consistency
**Status:** accepted
**Date:** 2026-05-16

---

## Context

Planifest has two patterns for hook adapters:

**Pattern A: Delegating** (Cursor, Windsurf, Codex adapters): The adapter translates the tool's native envelope into a Planifest common envelope. It then invokes a shared enforcement script (`gate-write.mjs` or `check-design.mjs`) via `spawnSync` and passes the common envelope on stdin. The enforcement script contains all enforcement logic. The adapter passes through the exit code (and for some tools, constructs a JSON response per ADR-0044).

**Pattern B: Self-contained** (Copilot adapter): The adapter contains the full enforcement logic inline, covering path checking, sentinel checking, and design.md reading. It has no dependency on shared enforcement scripts.

Pattern B emerged because the Copilot adapter predates the formalisation of the common envelope and the shared enforcement script architecture. All other adapters follow Pattern A.

This feature updates all four adapters. You must formalise the architecture to ensure consistency.

---

## Decision

**All hook adapters must use Pattern A (delegating).** Adapters translate the tool envelope and delegate enforcement to shared scripts. No adapter contains enforcement logic inline.

You must refactor the Copilot adapter (`copilot.mjs`) to follow Pattern A. Remove the inline enforcement logic and delegate to `gate-write.mjs` (for preToolUse) and `check-design.mjs` (for userPromptSubmitted). The adapter constructs the Copilot-specific JSON deny response from the enforcement script's exit code and stdout per ADR-0044.

**Rationale:** The enforcement logic (what constitutes a permitted write, what the design scope is, what the sentinel file means) must have a single authoritative implementation. Pattern B creates a second copy that will inevitably drift from the shared scripts as enforcement evolves. Every enforcement enhancement (new sentinel checks, new always-permitted paths, new scope rules) would need a separate change in each self-contained adapter. This is a maintenance hazard.

**Common envelope contract** (for reference):
```json
{
  "session_id": "<string>",
  "cwd": "<absolute path>",
  "tool_input": { "path": "<string>", ... },
  "event": "PreToolUse | UserPromptSubmit"
}
```
Adapters must produce this shape before invoking the enforcement script.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Self-contained adapters (Pattern B) for all tools | No inter-script dependency; each adapter ships as a single file | Enforcement logic duplicated N times; any change to gate-write logic requires N adapter edits; testing requires testing each adapter independently | Maintenance cost grows linearly with the number of supported tools |
| Shared enforcement logic as an importable module rather than a spawned process | No subprocess overhead; direct function call | Adapters would import from `../enforcement/gate-write.mjs` — coupling their execution context to the enforcement scripts' Node.js module graph; harder to test adapters in isolation | spawnSync keeps adapters and enforcement scripts independently testable and independently deployable |
| Hybrid: self-contained for simple adapters, delegating for complex ones | Less refactoring for simple tools | Inconsistency makes the architecture harder to reason about; "simple" adapters inevitably grow | Consistency is more valuable than avoiding the Copilot refactor |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| `hooks/adapters/copilot.mjs` | Refactored from Pattern B to Pattern A: remove inline enforcement logic; delegate to `gate-write.mjs` and `check-design.mjs`; construct Copilot JSON deny response per ADR-0044 |
| `hooks/adapters/cursor.mjs` | Already Pattern A; envelope extraction updated for current Cursor field names (REQ-018) |
| `hooks/adapters/windsurf.mjs` | Already Pattern A; updated for expanded event routing (REQ-016) |
| `hooks/adapters/codex.mjs` | Already Pattern A; envelope extraction updated and UserPromptSubmit routing added (REQ-019) |
| `hooks/enforcement/gate-write.mjs` | No change — remains the authoritative enforcement implementation |
| `hooks/enforcement/check-design.mjs` | No change |

---

## Consequences

**Positive:**
- Enforcement logic has exactly one implementation. A fix to `gate-write.mjs` automatically improves enforcement in all tools.
- Adding support for a new tool requires only a new adapter. Enforcement scripts stay unchanged.
- Each adapter and each enforcement script can be unit-tested independently.
- The common envelope contract is the only interface. Adapters do not need to know each other's formats.

**Negative:**
- Refactoring the Copilot adapter introduces risk. You must translate inline logic that works today to the delegating pattern without regression.
- `spawnSync` introduces a subprocess for every hook invocation. The performance cost is minor (typically <50ms) but non-zero.

**Risks:**
- The Copilot refactor may reveal edge cases in the inline logic that the common envelope contract does not capture. An example is a Copilot-specific context field that the inline adapter used and the common envelope does not carry.

---

## Related ADRs

- ADR-0044: extends (ADR-0044 defines how adapters translate the enforcement script's exit code into tool-specific deny responses, and that decision assumes the delegating architecture defined here)
- ADR-0045: related-to

---

## Supersedes

- None

## Superseded By

- None
