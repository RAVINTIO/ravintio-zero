---
title: "ADR 004: P0 states standard-iterative mode without asking"
summary: "When standard-iterative is the only detected signal, the planifest-zero orchestrator states the mode and its signal at P0 and does not ask for confirmation. Every other mode, and any conflict, keeps the question."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000037-self-host-on-planifest-zero"
---
# ADR-0130 - P0 states standard-iterative mode without asking

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

At P0 step 7, the `planifest-zero` orchestrator detects the adoption mode, recommends it, and asks the human to confirm. It applies the highest-priority signal only. The Adoption Modes table lists four signals:

1. External Anchor: `planifest-overrides/instructions/external-versioning.md` exists.
2. Standard Iterative: `plan/_archive/` has a feature dir, or `docs/about.md` exists.
3. Retrofit: source exists in `src/` with no archive or overrides.
4. Greenfield: none of the above.

In a repo with prior runs, the answer is always standard-iterative. The question adds a round trip to every run and tells the human nothing new (backlog 0000103).

The other modes differ. External Anchor tells the orchestrator to ask the human per the external constraint, and never to suggest from run type alone. Retrofit asks the human to confirm a suggestion from project markers, and it starts a codebase scan. Greenfield sets the version to `0.1.0`. In each of these, the human holds facts the repo signal can't show.

## Decision

1. If signal 2 is present and signals 1 and 3 are absent, the orchestrator states the mode and the signal it found. It doesn't ask for confirmation.
2. The P0 briefing names the mode and the signal, for example ``standard-iterative (`plan/_archive/` has prior feature dirs)``.
3. The orchestrator records the mode and its signal in `discovery.md`, `design.md`, and the build log, as before.
4. The orchestrator still asks when signals conflict. A conflict means the human states a different mode, or discovery can't read a signal. Source code in `src/` beside an archive is the normal iterative case, not a conflict.
5. The orchestrator still asks for External Anchor, Retrofit, and Greenfield.
6. If the human states a different mode, the existing rule applies. The orchestrator warns once with the consequence, proceeds if they confirm, and records the confirmed mode.
7. The change covers `planifest-zero/skills/planifest-orchestrator/` only. The old `planifest-framework/` copy leaves the repo in req-004.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Always confirm (status quo) | The human checks every detection | One question per run with only one answer in a repo with history | The question gives the human no new fact |
| Never confirm any mode | Fewest questions | External Anchor needs the human's constraint. Retrofit and Greenfield set the version and starting point from guesses | A wrong guess there changes the version or skips the retrofit scan |
| Skip the question only for an unambiguous standard-iterative signal (chosen) | Removes the common, single-answer question. Keeps it where the human adds facts | Two P0 paths to maintain | Chosen. The repo's own history is the signal, so it needs no confirmation |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | The orchestrator `SKILL.md` changes P0 step 7 and the Adoption Modes text. A static suite checks the new wording |

## Consequences

**Positive:**
- P0 in a repo with prior runs asks one fewer question.
- The briefing still shows the mode and its signal, so the human can still correct it.

**Negative:**
- A wrong detection now costs a correction later in P0 or after, not a "no" at step 7. For example, a stray `docs/about.md` in a new repo yields standard-iterative and a minor bump.
- The human must read the briefing to catch the mode, because nothing prompts them to check it.

**Risks:**
- A human who skims the briefing misses a wrong mode until the version bump at step 12. Step 12 still asks for confirmation, so the version can't change without a reply.

## Related ADRs

- None in this feature

## Supersedes

- None

## Superseded By

- None
