---
title: "ADR 0327: Planned restart exits 75"
summary: "A driver stop whose line starts I-D Advance: Restart: exits 75. Every other stop exits 1, and a failure after a restart hit exits 1."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0327 - Planned restart exits 75

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000503-planned-restart-exit-code
**Component:** ravintio-zero
**File:** `docs/adr/0327-planned-restart-exits-75.md`
**Date:** 2026-11-12

## Context

`main()` in `initiative-run.mjs` exits 1 for every `Stop`. A `Restart:` line is a `Stop`, so the host reports the background task as failed after a planned restart. This happened at 00:29 on 2026-11-11, after step 27 merged.

## Decision

A `Restart` class extends `Stop` and carries `planned = true`. The serial path throws it for each stop line that starts `I-D Advance: Restart:`. That includes the combined `Restart: Setup:` line.

The concurrent path sets the flag when the first stop line starts the same way. A later failure in the same run clears it. `main()` exits 75 for a planned stop and 1 for every other stop. The handoff exit stays 0.

The code 75 is `EX_TEMPFAIL` in `sysexits.h`. It means a temporary condition that a retry clears.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Exit 0 after a restart | The host shows success | A script cannot tell a restart from a finished initiative | The coordinator needs the difference |
| Exit 75 for the bare `Setup:` stop too | One rule for all planned stops | The backlog entry asks only for the restart, and a setup stop needs the human to act | Out of scope |
| Keep exit 1 and add a marker file | No code change for the host | The host still reports a failure | It does not fix the report |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` gains the `Restart` class. `roadmap-standards.md` and the initiative skill state exit 75. |

## Consequences

**Positive:**
- The host stops reporting a planned restart as a failure.
- The coordinator reads the exit code to tell the two stops apart.

**Negative:**
- A tool that read exit 1 as the restart signal must read 75.

**Risks:**
- A failure exits 75 by mistake. A later stop line clears the flag, and a test pins the case.

## Related ADRs

- ADR-0323 - related-to: the handoff exits 0 and is not a stop.

## Supersedes

None.

## Superseded By

None.
