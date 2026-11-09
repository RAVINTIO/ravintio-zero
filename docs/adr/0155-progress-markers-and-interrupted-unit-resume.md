---
title: "ADR 007: Progress markers and interrupted-unit resume"
summary: "Each dispatched unit logs an In progress: line before it starts and a Done: line with its work. On resume, an unmatched In progress: line marks an interrupted unit. The session stashes left-over changes and reruns the unit from its start."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000043-autonomous-roadmaps"
---
# ADR-0155 - Progress markers and interrupted-unit resume

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

The roadmap driver runs each step in a fresh session. A driver stop, a crash, or a closed laptop can end a step partway through a unit of work. The next session remembers nothing and must restart from the repo alone.

The commit rule leaves every finished unit committed. The build log records a TDD cycle only when the cycle finishes. So nothing in `plan/current/` names the unit in flight, and its files sit uncommitted in the working tree. `pause.md` records the exact point only after a deliberate pause.

In the live acceptance run's stop-and-restart test, the driver received SIGTERM during step 1's P2. The resumed session found the test-writer's uncommitted files and committed them as the red test without checking them. That worked only because the file happened to be complete. The archived build log has no trace of the stop.

## Decision

**Progress markers.** Before each dispatched unit starts, the phase appends `- In progress: {unit} ({ISO-8601 timestamp})` to the build log and commits it. The unit's work lands with `- Done: {unit} ({ISO-8601 timestamp})` in the same commit. A unit is a TDD subagent in P2, a self-correct cycle in P3, or any subagent dispatched under the agent dispatch standards. `{unit}` names the requirement and stage, for example `REQ-001 test-writer`.

**Interrupted-unit resume.** On resume, an `In progress:` line with no later matching `Done:` line marks an interrupted unit. The session stashes any uncommitted changes with `git stash push --include-untracked -m "interrupted {unit}"`. It reruns the unit from its start and logs `- Resumed after interruption: {unit}`. It never commits files an interrupted unit left behind without rerunning the unit.

**Placement.** The rules live in `planifest-zero/standards/agent-dispatch-standards.md`. The orchestrator's Resume Detection gains an interrupted-unit step before Open. The implement and validate skills point to the standard.

The roadmap driver reads only `Blocked:` and `Resolved:` lines, so the markers never stop it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Trust uncommitted files on resume | No extra commits | A stop can cut a file off partway, and nothing says whether it finished | The acceptance run showed the session commits such files unchecked |
| Discard uncommitted files on resume | Exact restart | Loses work the human may want to inspect | A named stash restarts exactly and stays reversible |
| Write a `pause.md` on every stop | Reuses the pause model | A signal handler in a child session can't write it reliably, and a crash writes nothing | A marker written before the unit starts survives any stop |
| Record progress only in the driver | No phase skill change | Covers roadmap steps only, and the driver can't see inside a step | Interrupted units happen in any long run, not only roadmaps |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | New section in the agent dispatch standard. One Resume Detection step in the orchestrator. Pointer clauses in the implement and validate skills. Build-log template documents the lines. |

## Consequences

**Positive:**
- A resumed session knows exactly which unit to rerun, from the build log alone.
- Resume is reversible. Left-over changes stay in a named stash for the human to inspect.
- The build log records every interruption.

**Negative:**
- Each unit adds one extra commit for its `In progress:` line.
- The build log grows by two lines per unit.

**Risks:**
- A session may forget to write a marker. Then resume falls back to today's behaviour for that unit.
- Stashes from many interruptions can pile up. The resume line names each stash so the human can clear them.

## Related ADRs

- ADR-0152 - related-to: the driver runs each step in a fresh session, so a stop loses all session memory.
- ADR-0154 - related-to: roadmap steps run with no human present to explain a stop.

## Supersedes

- None

## Superseded By

- None
