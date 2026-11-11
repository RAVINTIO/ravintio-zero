---
title: "ADR 0323: Driver hands over new starts after a Restart"
summary: "After a Restart-only merge, the old driver starts a successor that takes the lock, adopts running steps, and starts new ones, while the old driver supervises its own sessions."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0323 - Driver hands over new starts after a Restart

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Component:** ravintio-zero
**File:** `docs/adr/0323-driver-hands-over-new-starts-after-restart.md`
**Date:** 2026-11-11

## Context

A merged step can change the driver, the watcher, or the initiative skill. The driver then prints `Restart:` and starts no new step. It waits for every running step to end and exits 1. On 2026-11-10 step 26 waited from 20:01 to 21:43 for steps 36, 38, and 39.

The old driver cannot reload its code. It also owns the sessions it spawned, because it reads their output, applies the resume rule, and reads their blocks. A new driver can run the new code, but the old sessions stay with the old process.

## Decision

On a Restart-only hit, the concurrent driver hands over:

1. It fast-forwards the root to the merged ref. If that fails, it keeps the existing stop.
2. It spawns `node initiative-run.mjs --root {root} --handoff`, detached, with its own output and error handles.
3. It writes the successor pid into the lock file and never releases that lock.
4. It prints a `Restart:` line that says a new driver took over new starts.
5. It starts no step and runs no queue. It supervises its own sessions and exits 0 when they end.

The successor checks that the lock holds its pid. It reads the control folders. A step with `ready` goes to the queue. The successor adopts a step with a live `running` pid that is not its own. It starts no session for that step but counts it against the cap. A step with a dead `running` pid restarts in its worktree.

A handed-over step that blocks or fails gets a `stopped` file in its control folder. The successor reads it and stops new starts. A driver without `--handoff` removes stale `stopped` files.

A `Setup:` hit and a combined `Restart: Setup:` hit keep the existing stop, because they need setup to run first.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Reload the driver code in place | No second process | Node has no exec. The running state lives in closures of the old module. | A reload needs a rewrite of the scheduler state. |
| Exit at once and orphan the sessions | Fewest parts | The sessions lose their resume rule and their block read. | A block would go unseen. |
| Keep the stop and wait | No change | Costs the delay that the backlog entry reports. | It is the defect. |
| Successor takes over sessions by pid | One owner | Needs a session pid in the control folder and a new resume path. | Too much new state for one step. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The driver gains the handoff. The standards and the initiative skill describe it. |

## Consequences

**Positive:**
- A ready step starts within seconds of a Restart-only merge.
- No step waits for unrelated running steps.
- The coordinator starts a watcher only.

**Negative:**
- Two driver processes run for a while.
- The control folder gains a `stopped` file that the drivers must clean up.

**Risks:**
- A bug in the adoption check can start a duplicate session. Tests count session starts per step.
- The lock handoff leaves a gap if the successor dies at once. The successor then runs no steps until the coordinator starts a new driver.

## Related ADRs

- ADR-0310 - related-to (the approved setup command also fast-forwards the root)
- ADR-0322 - related-to (the successor uses the same start ranking)

## Supersedes

- None.

## Superseded By

- None.
