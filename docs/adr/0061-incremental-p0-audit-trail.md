---
title: "ADR-0061: Incremental P0 Audit Trail Writes"
summary: "P0 coaching log entries are written to the build log after each question-answer exchange, not accumulated and written at P0 close."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000014-improve-adoption-mode-selection"
---
# ADR-0061 - Incremental P0 Audit Trail Writes

**Skill:** planifest-adr-agent
**Tool:** Claude Code
**Model:** claude-sonnet-4-6
**Feature:** 0000014-improve-adoption-mode-selection
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-05-19

---

## Context

REQ-011 requires a structured P0 audit trail in the build log recording questions asked, answers given, and items deferred. Two write strategies are possible. One accumulates all entries and writes them as a batch when P0 closes. The other writes each entry immediately after the question-answer exchange completes.

P0 coaching often spans multiple turns and occasionally multiple sessions (resumed via pause file). A batch write at P0 close risks losing entries if something interrupts the session before close.

---

## Decision

**Write each audit trail entry immediately after the question-answer exchange completes.** The orchestrator appends to the build log after each turn where the human answered a coaching question. This means the audit trail is always up to date regardless of session state.

Each entry follows a fixed structure:
```
- Q: {question asked}
  A: {answer summary}
  Outcome: accepted | overridden | deferred
```

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Batch write at P0 close | Single write operation; clean | Entries lost if session interrupts before P0 closes | Rejected — data loss risk in a session-spanning coaching conversation |
| Incremental write per exchange (this decision) | No data loss on interruption; audit trail always current | More write operations; slightly noisier git history if P0 spans commits | Chosen — resilience outweighs the minor cost |
| Separate audit file (not build log) | Dedicated file easier to read in isolation | Another file to manage; P8 already reads build log | Rejected — P8 reads build log; consolidating there is simpler |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-orchestrator skill | Writes to build log after each coaching exchange |
| planifest-build-assessment-agent skill | Reads P0 coaching log section at P8 |

---

## Consequences

**Positive:**
- Audit trail survives session interruptions
- P8 build-assessment-agent can assess coaching quality from a complete log
- Deferred items are traceable to the specific exchange that produced them

**Negative:**
- Each coaching turn that includes a question now requires a build log write, adding latency to the coaching conversation
- Build log grows incrementally during P0 rather than in a single append

**Risks:**
- If the build log write itself fails (unlikely, because docs/ is always-permitted), the coaching exchange succeeded but the build log lost the record. This is acceptable given the low probability

---

## Related ADRs

- ADR-0060: depends-on (one-question rule creates discrete exchanges that map 1:1 to audit trail entries)

---

## Supersedes

- None

## Superseded By

- None
