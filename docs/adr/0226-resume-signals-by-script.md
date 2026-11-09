---
title: "ADR 001: Report resume signals with a script run by the session start hook"
summary: "A tested Node script reports the mechanical Resume Detection signals, and the hook injects them."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000243-session-start-detection"
---
# ADR-0226 - Report resume signals with a script run by the session start hook

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000243-session-start-detection
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

The orchestrator reads 12 Resume Detection checks from `SKILL.md` and carries them out by hand. Most only test whether a file or a build log line exists, and no test covers the agent's reading. The stack is Node.js hooks and Bash tests, per the design.

## Decision

`ravintio-zero/scripts/resume-detect.mjs` prints one fixed line per finding. `auto-trigger-orchestrator.mjs` runs it with a 2 second timeout and injects the lines with the load instruction. The script prints fixed text only. A failed run injects `resume detection did not run`. Checks that need judgement stay in `references/orchestrator-resume-detection.md`, and the script reports only their signal.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Run it as a separate hook | Isolated | Two hooks fire on one prompt and need ordering | The chart Decisions table picks the single hook |
| Keep the checks in `SKILL.md` | No code | 4,324 bytes loaded every session, no test | Entry 0000237 and step 6 need the space |
| Print file text in the findings | Richer context | A hostile commit can plant instructions in system context | Fixed text only |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, hook change, reference file, two skills |

## Consequences

**Positive:**
- A tested list replaces a manual reading.
- `SKILL.md` frees about 3,900 bytes.

**Negative:**
- The hook now starts a child process on the load prompt.

**Risks:**
- See R-001 and R-002.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
