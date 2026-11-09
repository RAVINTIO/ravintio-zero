---
title: "ADR-0040: Pause and resume via plan/current/pause.md file"
summary: "The orchestrator's pause/resume mechanism uses a single file at plan/current/pause.md containing phase, active task, last artifact, and in-progress state. Presence of the file signals a paused session; its content is the resume instruction."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000009-framework-rail-tightening"
---
# ADR-0040 - Pause and resume via plan/current/pause.md file

**Skill:** planifest-adr-agent
**Tool:** Claude Code
**Model:** claude-sonnet-4-6
**Feature:** 0000009-framework-rail-tightening
**Component:** planifest-framework
**Status:** accepted
**Date:** 09 May 2026

---

## Context

REQ-006 requires the orchestrator to support a pause/resume command. When the human issues a pause command, the orchestrator must snapshot the current pipeline state. A future session can then resume from exactly the same point without re-coaching or re-running completed phases.

Several questions needed answering:
- What state must be captured to enable exact-point resume?
- Where does that state live (in-memory only, a new file, appended to an existing file)?
- How does the resume detection logic discover and consume it?
- What happens to the pause record after the session resumes?

The existing resume detection in the orchestrator checks `plan/current/` for artifact presence. Any resume mechanism must integrate with this existing logic without requiring a separate detection pass.

---

## Decision

The orchestrator writes a file `plan/current/pause.md` when the human issues a pause command. The file contains:

- **phase**: the current phase identifier (e.g. `P3`)
- **active_task**: the task in progress at pause time (e.g. "implementing REQ-003 subagent decomposition")
- **last_artifact**: the last file written or action completed before pause
- **in_progress_state**: a free-text description of what the session partially completed and what remains, sufficient for the orchestrator to reconstruct the execution context

The file is YAML frontmatter plus a Markdown body. The frontmatter carries machine-readable fields (phase, active_task, last_artifact). The body carries the human-readable in-progress state narrative.

On resume, the orchestrator's existing `plan/current/` scan detects `pause.md`. If found, it opens with `Px: Resuming — {active_task}` and reads the in-progress state to restore context. After the session fully resumes and re-engages the interrupted task, the orchestrator deletes `pause.md`.

The ADR adds `pause.md` to `ALWAYS_PERMITTED_FILES` in `gate-write.mjs`. The orchestrator can then write it at any pipeline phase, including phases where `design.md` may not yet exist or has been cleared.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Append pause state to `build-log.md` | No new file; build log is already the pipeline record | Build log is append-only telemetry — not read by the orchestrator for control flow; pause state would not be discovered by resume detection | Wrong artifact type; not read at resume |
| In-memory only (no file) | No file writes | Lost on session end; resume impossible across session boundaries | Violates the persistence requirement in REQ-006 |
| Separate `plan/current/session-state.md` with full pipeline state | Comprehensive; enables rich resume | Over-engineered for the use case; the existing artifact scan already reconstructs most state; only the interrupted task context needs capturing | Complexity without benefit |
| Append to `.orchestrator-active` | Already a session sentinel | `.orchestrator-active` is a boolean sentinel (presence = active); adding structured state conflates the sentinel's purpose; existing consumers expect no content | Conflates two concerns |
| Use a `plan/pauses/` directory with timestamped files | Supports multiple pauses history | Resume logic must pick the latest; adds directory; history is already in build-log | Over-engineered; build log provides history |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework | Orchestrator SKILL.md updated with pause command handler and resume detection for `pause.md`; `gate-write.mjs` updated to add `pause.md` to `ALWAYS_PERMITTED_FILES`; `pause.md` template added to `templates/` |

---

## Consequences

**Positive:**
- Pause state survives session boundaries. The human can close the tool, reopen, and resume exactly.
- Resume detection reuses the existing `plan/current/` scan, so it needs no new detection logic
- `pause.md` is self-documenting: the human can read it directly to understand where the session paused
- The resume handler deletes it, so no stale state accumulates

**Negative:**
- If the session ends ungracefully (crash, forced stop) without writing `pause.md`, resume falls back to the standard artifact-scan resume (phase re-detection from artifacts). This is slightly less precise but still functional.
- You must add `pause.md` to `ALWAYS_PERMITTED_FILES` in gate-write. This is a mechanical change but you must not forget it.

**Risks:**
- If the resume handler does not delete `pause.md` and the pipeline completes, P7 will archive it alongside other `plan/current/` artifacts. This is harmless but slightly noisy. Explicit deletion in the resume handler mitigates it.

---

## Related ADRs

- ADR-0039: the gate-write always-permitted list is the mechanism that lets the orchestrator write `pause.md` at any phase

---

## Supersedes

- None

## Superseded By

- None

---

*Generated by planifest-adr-agent.*
