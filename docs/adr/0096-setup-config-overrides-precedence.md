---
title: "ADR 002: Setup config overrides precedence"
summary: "planifest-overrides/setup-config/{tool}.md becomes the tracked source of truth for active setup flags/backend-url; the gitignored .planifest-setup-flags marker is retained as a local cache reconciled to match it. .orchestrator-strict is explicitly out of scope for this ADR."
status: "proposed"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000025-pipeline-gate-and-config-fixes-and-ship-agent-fixes"
---
# ADR-0096 - Setup config overrides precedence

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000025-pipeline-gate-and-config-fixes-and-ship-agent-fixes
**Component:** planifest-framework
**Date:** 2026-08-03

## Context

req-004 (setup config relocation) requires `setup.sh`/`setup.ps1` to write two things to a new tracked file, `planifest-overrides/setup-config/{tool}.md` (one per AI tool). They are the active setup flags (`--context-mode-mcp`, `--structured-telemetry-mcp`, `--strict-orchestrator`, etc.) and `backendUrl`. This is in addition to the existing gitignored `{tool-dir}/.planifest-setup-flags` marker (e.g. `.claude/.planifest-setup-flags`). Both req-004 and the originating backlog entry (`plan/backlog/0000037-relocate-setup-config-to-overrides/entry.md`) frame this as additive. The change does not remove the marker, and both files continue to exist after it.

Today the marker is the only record of intent and is machine-local. `planifest-refresh-setup` Step 3 reconstructs it by inference whenever it's missing. Writing to `planifest-overrides/setup-config/` introduces a second copy of the same information. That directory is read-only from `setup.sh`'s perspective today (ADR-0096, `0000005-framework-governance`). With two copies, a human can now edit one without the other. For example, they might hand-edit the tracked `setup-config/claude-code.md` after a `git pull` that brought in a teammate's flag change, before re-running setup locally. The two files can then disagree. req-004 explicitly defers two points to this ADR. The first is the exact precedence/reconciliation when the committed file and the gitignored marker disagree. The second is whether this extends to `.orchestrator-strict`. This ADR resolves both open questions.

## Decision

1. **Source of truth:** `planifest-overrides/setup-config/{tool}.md` is authoritative for the flags/backendUrl in effect for that tool. It is git-versioned, human-reviewable in diffs, and survives fresh clones. These are the same properties that motivate every other file under `planifest-overrides/`, and they are the reason this feature exists at all.
2. **Marker role:** This ADR downgrades `{tool-dir}/.planifest-setup-flags` (e.g. `.claude/.planifest-setup-flags`) to a local completion-status cache. `writtenAt` and `attemptStatus` remain meaningful there. Setup no longer trusts `flags`/`backendUrl` as intent when they diverge from `planifest-overrides/setup-config/{tool}.md`.
3. **Reconciliation trigger:** on every `setup.sh`/`setup.ps1` run and every `planifest-refresh-setup` invocation, if both files exist and their `flags`/`backendUrl` disagree, the tracked file wins. Setup proceeds using the tracked file's values and overwrites the gitignored marker to match (updating `writtenAt`/`attemptStatus` accordingly). No merge and no interactive prompt for this specific disagreement. The tracked file already represents a deliberate, reviewable decision (a commit), so re-deriving from it is correct without asking the human again.
4. **Bootstrap/failure paths (unchanged from req-004):** if `planifest-overrides/setup-config/{tool}.md` doesn't exist yet, setup creates it from the CLI-supplied or inferred flags (first-run case, no precedence conflict). If the write to `planifest-overrides/setup-config/` fails, setup falls back to marker-only behavior for that run and surfaces a warning rather than aborting. This follows req-004's acceptance criteria. Setup does not treat the marker as authoritative in this failure case, only as a stopgap for that single run.
5. **`.orchestrator-strict` is explicitly out of scope for this ADR.** `.orchestrator-strict` toggles orchestrator strict-mode behavior. It is a session/behavior switch, not setup configuration in the `flags`/`backendUrl` sense this ADR governs. `feature-brief.md`'s scope boundaries for 0000025 do not include `.orchestrator-strict`. This is a deliberate boundary decision, not an oversight. Extending the tracked-file/marker precedence rule to `.orchestrator-strict` would require its own requirement. It would also need its own review of how strict-mode toggling interacts with `plan/.orchestrator-active` and loop state. That interaction has nothing to do with the durability of setup flags.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Marker (`.planifest-setup-flags`) remains source of truth; tracked file is a passive mirror | No change to existing `planifest-refresh-setup` inference logic | Defeats the purpose of req-004 — the whole point is that intent should live in a reviewable, versioned file, not a gitignored local artifact | Contradicts req-004's stated goal ("setup configuration is tracked and survives like the rest of overrides") |
| Interactive prompt on every disagreement, asking the human which file wins | Never silently overwrites either file | Adds a confirmation round-trip to every setup/refresh run, most of which involve no real conflict (e.g. routine re-run after a clean pull); noisy for a case with an obvious correct answer | The tracked file is already a reviewed, committed artifact — asking again duplicates review that already happened at commit time |
| Extend this ADR's precedence rule to also cover `.orchestrator-strict` | One less future ADR; keeps all "setup-adjacent local vs. tracked state" rules in one place | Conflates two different concerns (setup flag durability vs. strict-mode session toggle); expands this ADR beyond req-004's and feature-brief.md's declared scope | Out of scope per `feature-brief.md`; needs its own requirement if pursued |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework (`setup.sh`, `setup.ps1`) | Must write `planifest-overrides/setup-config/{tool}.md` as authoritative, reconcile the gitignored marker to match on disagreement, and preserve the existing fallback-and-warn behavior on write failure |
| planifest-framework (`planifest-refresh-setup` skill) | Step 2/3 flag-inference logic gains a fast path: read `planifest-overrides/setup-config/{tool}.md` directly at high confidence instead of inferring from hook wiring, falling back to inference only when the tracked file is absent |

## Consequences

**Positive:**
- The flags/backend-url actually in effect for a repo become visible in `git log`/`git diff`/code review. This closes the exact gap the backlog entry (0000037) identified. A repo-level decision like "this repo uses strict-orchestrator mode" is no longer invisible to anyone but the machine that ran setup.

**Negative:**
- Setup and refresh logic must now handle a two-file reconciliation step (detect disagreement, overwrite the marker, log the overwrite) that didn't exist before. This is a small but permanent increase in setup-script complexity, and it adds a new failure mode to test (tracked file present but malformed).

**Risks:**
- A human hand-editing `planifest-overrides/setup-config/{tool}.md` without understanding it's now authoritative could silently change another teammate's local `.orchestrator-strict`-adjacent flags (e.g. `--strict-orchestrator`) on their next setup/refresh run. The file being a reviewable commit mitigates this, but only if reviewers actually read setup-config diffs.

## Related ADRs

- ADR-0096 (0000005-framework-governance) - depends-on (establishes the `planifest-overrides/` read-only-from-setup.sh convention that this ADR carves a narrow, additive write exception into)

## Supersedes

- None

## Superseded By

- None
