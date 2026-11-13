---
id: ADR-0014
title: Two-tier external skill storage with plan-scoped lifecycle
status: accepted
date: 2026-04-20
deciders: [human-on-the-loop]
component: "ravintio-zero"
feature: "0000003-hook-based-enforcement"
---
# ADR-0014 - Two-tier external skill storage with plan-scoped lifecycle

## Context

REQ-025 defines where the pipeline stores external skills and when it cleans them up. Skills installed for a feature should not accumulate indefinitely, but some skills are useful across features and should persist. The design needs two storage locations and a preservation mechanism.

## Decision

External skills use a **two-tier storage model**:

- **Plan-scoped (default):** `plan/current/external-skills/<name>/`, gitignored and removed at P7.
- **Preserved:** `planifest-framework/external-skills/<name>/`, committed. It survives P7 and persists across all future features.

A **single manifest** at `planifest-framework/external-skills.yml` tracks both tiers via a `scope: plan | preserved` field.

The ship-agent (P7) removes all `scope: plan` skills after prompting the human for any they want to preserve. It moves preserved skills to `planifest-framework/external-skills/`, where they remain available to future plans.

**The agent is the primary driver** of all install/remove/sync operations via `skill-sync.sh` (and `skill-sync.ps1` on Windows). `setup.sh add-skill` exists as a manual escape hatch only.

## Rationale

1. **Plan/current as the natural ephemeral boundary.** `plan/current/` is already cleared at P7. Plan-scoped skills follow the same lifecycle with no extra machinery.
2. **planifest-framework/ as the durable store.** The team commits and shares the framework directory. Preserved skills committed there are available to every team member and every future feature without re-fetching.
3. **Single manifest for observability.** One file shows all external skills regardless of tier. Scope field makes tier explicit without requiring two separate manifests.
4. **Agent-driven keeps humans out of the shell.** The human answers questions in the conversation. The agent handles filesystem operations. This is consistent with the broader Planifest model.
5. **Two scripts (sh + ps1) for cross-platform parity.** Same pattern established by setup.sh / setup.ps1.

## Alternatives considered

- **Single tier (all in planifest-framework/):** Rejected. Every skill would be committed and accumulate permanently, with no natural cleanup point.
- **Single tier (all in plan/current/):** Rejected. No persistence mechanism for skills valuable across features.
- **Human-run CLI only (no agent-driven path):** Rejected. Forces humans into the shell for routine operations the agent can handle.

## Consequences

- `plan/current/external-skills/` must be added to `.gitignore`.
- The team commits `planifest-framework/external-skills/` and `external-skills.yml`.
- The ship-agent P7 step must be extended to perform skill cleanup (REQ-025).
- `skill-sync.sh` and `skill-sync.ps1` must be aware of each tool's skills directory location, the same tool-config pattern used by `setup.sh` (REQ-024).
