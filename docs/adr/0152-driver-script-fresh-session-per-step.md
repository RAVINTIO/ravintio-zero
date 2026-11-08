---
title: "ADR 004: Driver script runs each step in a fresh session"
summary: "A Node driver, roadmap-run.mjs, runs each roadmap step as its own claude -p session with auto permission mode. A lock file stops a second driver. R-B Activate offers to start it in the background."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000043-autonomous-roadmaps"
---
# ADR-0152 - Driver script runs each step in a fresh session

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

A roadmap chains several features. Each step runs P0 to P4 and fills a context window with its own plan, code, and test output. If one session ran the whole chain, step four would carry the residue of steps one to three. This breaks the Context Hygiene rule that each phase starts from files, not from memory.

The P0 research checked the Claude Code docs and the CLI help for a way to clear a session. The model has no way to clear or compact its own session. No tool, skill, or hook does it on the model's request. The `/loop` skill and `ScheduleWakeup` wake the same session, so they keep the same context.

A fresh session per step therefore needs a process outside Claude. The human asked for a driver script and chose `--permission-mode auto` so a step can finish without a prompt.

## Decision

Add `planifest-zero/scripts/roadmap-run.mjs`. The driver runs each step as its own child process:

```
claude -p --permission-mode auto "Run roadmap step {position}"
```

**Fresh session.** The driver never passes `--continue` or `--resume`. Each step reads its state from `plan/current-roadmap/roadmap.md`, `plan/current/`, and the build log.

**Lock file.** The driver creates `plan/.roadmap-runner.lock` before the first step and refuses to start if the file exists. It removes the lock when the chain ends or stops.

**Stop rules.** The driver waits for each child to exit. It stops if the build log ends on a `Blocked:` line with no later `Resolved:` line. It also stops if `position` did not move, and it names the step.

**Launch.** R-B Activate offers to start the driver as a background task in the charting session. A foreground Bash call times out after 10 minutes, so the session must use a background task. The driver prints one line per stage, so the session can stream it with Monitor. The session must not edit the working tree while the driver runs.

The driver runs only on a roadmap with `status: active`. The merge-guard hook still applies inside every child session, because each child loads the repo's hooks.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| One long session runs every step | No outer script. No launch method to test | Context grows across steps and the model cannot clear it | Breaks Context Hygiene. Later steps work from the residue of earlier ones |
| One subagent per step from a parent session | Each step gets a clean context. No script to maintain | Subagents cannot start nested subagents, so P0 to P4 loses its own decomposition. Subagents run no session hooks | The step needs the hooks and the decomposition rule. A subagent drops both |
| Scheduled cloud routine | Runs while the machine is off. No local process | Timer gaps between steps. Each run needs sandbox setup and repo access | The chain would idle between steps. Setup cost repeats for every step |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Gains `scripts/roadmap-run.mjs` and a stub-`claude` test. The orchestrator's R-B Activate stage gains the background-launch offer |

## Consequences

**Positive:**
- Every step starts with a clean context, so a late step does not inherit earlier noise.
- The driver is a small Node script. A stub `claude` on the path tests it with no real model calls.
- The lock file stops two drivers from running one working tree.

**Negative:**
- A step that needs a permission prompt stops, because `-p` has no one to answer it.
- The machine must stay on and awake until the chain ends.
- The human cannot watch a step in an interactive session. The build log and the driver's stage lines are the only view.

**Risks:**
- A child session might not inherit the repo's hooks or the user's auth (R-006). The acceptance run in the throwaway repo shows this before ship.
- `--permission-mode auto` might not clear every prompt (R-002, R-007). The stalled-`position` check turns this into a named stop.
- A parent session might edit the working tree during a run (R-003). The lock file and the Activate instructions reduce this risk.

## Related ADRs

- ADR-0150 - related-to (the driver reads the roadmap state that ADR-0150 defines)
- ADR-0151 - related-to (each child session squash-merges into the roadmap branch)
- ADR-0154 - related-to (the driver relies on steps that self-confirm, so no step waits for a human)

## Supersedes

- None

## Superseded By

- None
