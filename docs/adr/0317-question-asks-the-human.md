---
title: "ADR 0317: Question asks the human something"
summary: "A Question line asks the human a question and ends with a question mark. The Stop hook warns on one that does not."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0317 - Question asks the human something

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000489-question-only-for-questions
**Component:** ravintio-zero
**File:** `docs/adr/0317-question-asks-the-human.md`
**Date:** 2026-11-11

## Context

On 2026-11-10 step 31 ended its turn with `I-C Run: Question: step 31 is partway through` while it waited for its suites. The driver stops on any open `Question:` line, so the line read as a stop that needs the human. The orchestrator text called `Question:` a routine question and listed it as a valid end of turn. Nothing told a step that waiting on its own work is not a question.

## Decision

A `Question:` line asks the human something and ends with a question mark. A step that waits for its suites, CI, or a background task keeps working. The text lives in rule `icrun-question-real` of `roadmap-standards.md`, with a short pointer in `SKILL.md` and `pipeline-reference.md`. The `check-reply-prefix.mjs` Stop hook warns when a final reply has a `Question:` status line with no question mark. It logs one line to `plan/.prefix-misses.log`, blocks nothing, and still exits 0 (0000200 ADR-002).

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Text only | No code | Nothing shows a false question after the fact | A second signal costs little |
| Block the turn on a false question | The step cannot stop falsely | The hook cannot tell a false question from a real one with certainty. It would widen the hook's power | The rule is warn only, as ADR-002 sets |
| Teach the driver to ignore a question with no mark | The run goes on | A real question without a mark would pass unseen. It changes a stop guard | Out of scope, and it weakens a stop |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New rule text, and a second check in the reply Stop hook |

## Consequences

**Positive:**
- A step has a stated rule for waiting on its own work.
- A false question shows up as a warning and a log line.

**Negative:**
- A real question that ends without a question mark draws a warning.
- A false question that holds a question mark passes the check.

**Risks:**
- The orchestrator `SKILL.md` has 48 bytes left under its cap, so later edits there need the text to move to a standard.

## Related ADRs

- 0000200 ADR-002 - extends: the hook warns and never blocks.
- 0000377 - related-to: the driver stops on a `Question:` line.

## Supersedes

- None.

## Superseded By

- None.
