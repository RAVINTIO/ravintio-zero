---
title: "ADR 0324: Driver takes a dead lock"
summary: "When the driver lock names a process that no longer runs, the driver reports it and takes the lock. A live, unreadable, or symlinked lock still refuses."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0324 - Driver takes a dead lock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Component:** ravintio-zero
**File:** `docs/adr/0324-driver-takes-a-dead-lock.md`
**Date:** 2026-11-11

## Context

The driver writes `plan/.initiative-runner.lock` with the `wx` flag and refuses to start if the file exists. On 2026-11-10 at 19:05 a driver left the file with the pid of a process that no longer ran. The next driver refused, and the coordinator removed the file by hand.

The refusal protects a live driver. It does not need to protect a driver that no longer exists.

## Decision

When the `wx` write fails with `EEXIST`, the driver reads the lock.

1. If the lock is a symlink, or holds anything but a decimal pid and a newline, the driver refuses as before.
2. If the pid names a running process, the driver refuses as before. The existing `alive(pid)` helper decides, and it counts `EPERM` as alive.
3. Otherwise the driver prints `I-C Run: Starting: lock named process {pid}, which no longer runs. Taking the lock.`, removes the file, and writes its own pid with `wx`.
4. If that second write fails with `EEXIST`, another driver won the race, and the driver refuses.

The driver leaves the lock file alone whenever it refuses.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep removing the file by hand | No code | The coordinator loses time and may remove a live lock | This is the problem |
| Remove any lock older than a time limit | No pid check | A long step keeps a live driver past any limit | It could take a live lock |
| A `--force` flag | Human decides | Another flag and another step for the coordinator | The pid check decides with no human |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` changes in `main()`. The standards text and header comment change. |

## Consequences

**Positive:**
- A driver restart needs no manual cleanup after a crash.
- The refusal stays for every lock the driver cannot prove dead.

**Negative:**
- A reused pid keeps a dead lock in place. The coordinator removes it by hand, as today.

**Risks:**
- Two drivers race for one dead lock. The `wx` write decides, so only one wins.

## Related ADRs

- ADR-0323 - related-to: the handoff writes the successor pid into the lock.

## Supersedes

None.

## Superseded By

None.
