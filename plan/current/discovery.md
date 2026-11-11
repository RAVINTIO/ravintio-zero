---
title: "Discovery - 0000495-driver-clears-dead-lock"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000495-driver-clears-dead-lock

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds the component. This is the only signal. |
| Git pre-flight | Branch `feat/0000495-driver-clears-dead-lock`, cut by the driver from the initiative branch. Clean tree. |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.105.0`
- Prior features (`plan/_archive/`): step 48 (0000493, driver keeps starting steps after a Restart) is the latest.
- Constraining ADRs: ADR-0323 (handoff writes the successor pid into the lock). ADR-0322 (chain order). Neither forbids a dead-lock rule.
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`. The installed copy `ravintio-zero/` comes from `sync-installed.mjs`.

## Findings for this step

- Backlog entry 0000496 states the problem. A driver left `plan/.initiative-runner.lock` holding the pid of a process that no longer ran. The next driver refused to start.
- `main()` in `src/ravintio-zero/scripts/initiative-run.mjs` writes the lock with flag `wx`. On `EEXIST` it stops with `another driver may be running`.
- The `alive(pid)` helper already exists in the same file (0000493). It returns true for a live pid and for `EPERM`.
- The existing test `test-0000043-req-007-roadmap-driver.sh` writes `other-driver` into the lock and expects a refusal. An unreadable lock must still refuse.
- Docs that describe the refusal: the header comment of `initiative-run.mjs` and `roadmap-standards.md` (in `ravintio-zero/standards/`).
- Retrospectives: the newest records (0000499, 0000519, 0000521) file no open change on the driver lock.
- Schema, dependency, and guard checks: the step changes no schema, adds no dependency, and widens no hook guard.
