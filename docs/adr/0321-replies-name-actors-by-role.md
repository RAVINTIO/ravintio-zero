---
title: "ADR 0321: Replies name actors by role"
summary: "Replies name each actor by role, and the advisory reply hook flags I and you in a run reply."
status: "proposed"
component: "ravintio-zero"
feature: "0000521-replies-name-actors-by-role"
version: "0.1.0"
---
# ADR-0321 - Replies name actors by role

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000521-replies-name-actors-by-role
**Component:** ravintio-zero
**File:** `docs/adr/0321-replies-name-actors-by-role.md`
**Date:** 2026-11-11

## Context

Replies used "I" for the agent and "you" for the human. A coordinator report names a step session, the coordinator, the driver, and the human. On 2026-11-11 the human found the pronouns subjective and confusing, because each sentence left the reader to work out the actor.

## Decision

A reply names each actor by role. It says "the human" for a person and "the agent" for a model running a task. A narrower role, such as "the coordinator", "the driver", or "step 45", also works. The rule sits in the boot templates, the orchestrator skill, and the roadmap standards. The coordinator report heading becomes `Decisions for the human`.

`check-reply-writing.mjs` gains the rule `actor-pronoun`. It flags "I", "you", and "your" in a run reply. A run reply opens with `hh:mm` and a run prefix. The rule skips code and `>` lines, and the hook stays advisory (ADR-0285). The rule lives in the hook and not in `prose-rules.mjs`, because documents and commit messages keep the second person.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add the rule to `prose-rules.mjs` | One place for every prose rule | `prose-check.mjs` would flag "you" in every pack document | The Google style guide asks for second person in documents |
| Make the hook block the turn | Strong enforcement | A blocked turn on a pronoun costs more than the pronoun | ADR-0285 keeps the reply check advisory |
| Check every reply | No prefix test | Chat replies outside a run would get notes | The rule covers run replies only |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Boot templates, orchestrator skill, roadmap standards, initiative skill, reply hook, and two tests |

## Consequences

**Positive:**
- Each sentence in a run reply names its actor.
- The human gets a note when a reply slips.

**Negative:**
- Replies run slightly longer, because "the agent" and "the human" replace one-word pronouns.
- The hook flags a quoted "I" outside code and `>` lines.

**Risks:**
- A reply that skips the run prefix gets no check.

## Related ADRs

- ADR-0285 - extends: adds a rule to the advisory reply check.
- ADR-0288 - relates: the shared prose rules module stays unchanged.

## Supersedes

- None.

## Superseded By

- None.
