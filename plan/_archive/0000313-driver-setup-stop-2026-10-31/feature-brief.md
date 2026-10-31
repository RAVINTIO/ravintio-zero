---
title: "Feature Brief - driver setup stop"
summary: "The driver stops after a merged step that changes installed pack files, so the next step runs on current copies."
status: "approved"
version: "0.1.0"
---
# Feature Brief - driver setup stop

**Feature ID:** 0000313-driver-setup-stop

> Built from backlog entry 0000311 by initiative 0000312 step 1.

## Business Goal

Step sessions load the installed copies in `.claude/`. A merged step that changes a skill, a hook, or setup leaves later steps on stale copies, and the driver cannot pause for a setup rerun. The driver stops after such a step, and the initiative skill reruns setup before it starts a new driver.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Setup stop in the driver | As an initiative owner, I want the driver to stop after a merged step that changes installed pack files, so that the next step runs on copies that match the pack. | must-have | 1 |
| Setup stop in the initiative skill | As an initiative owner, I want the initiative skill to treat the `Setup:` line as a planned stop and rerun setup, so that I don't rerun it by hand. | must-have | 1 |
| Setup stop in the roadmap standards | As a pack maintainer, I want the stop documented, so that the driver, the skill, and the standards agree. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All three | The tests pass and the standards name the stop. |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The driver script, the initiative skill, and the roadmap standards |

### Data Ownership

No data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `initiative-run.mjs` | initiative skill | Stop line on stdout, exit 1 | `I-D Advance: Setup: step {n} changed {files}. Rerun setup, then start a new driver.` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ESM), Bash |
| Runtime | Node |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash test scripts with `helpers/assert.sh` |
| IaC | none |
| Cloud | none |
| Compute | local |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Watch `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, and `ravintio-zero/setup/` in the driver.
- Print the `Setup:` line, release the lock, and exit 1 after a merged step changes a watched file.
- Print one line that names both stops when a step triggers `Restart:` and `Setup:`.
- Teach the initiative skill the `Setup:` stop: command source, exact-command check, hook check, new driver and watcher.
- Document the stop in `roadmap-standards.md`.

### Out of Scope
- Changing any hook or `setup.sh`.
- Running setup from the driver.

### Deferred
- Hook-resolution fixes from a subfolder (step 4, entries 0000287 and 0000288).

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | The stop fires on every change to a watched file and on no test-only change | Bash test with a stub `claude` |
| Security | Setup runs only when the command equals the one a `Confirmation:` row names | Skill text, checked by a test |

## Constraints and Assumptions

### Constraints
- The driver has no dependencies beyond Node.
- The driver never edits the working tree.

### Assumptions
- Step 1 runs on the old driver, so it ends with a `Restart:` stop and not a combined stop.

## Scenario Paths

**Happy path:** A merged step changes `ravintio-zero/skills/x/SKILL.md`. The driver prints the `Setup:` line, releases the lock, and exits 1. The initiative skill runs the approved setup command, checks the hooks, and starts a new driver and watcher.

> See above.

**First-run path:** A new initiative has no earlier merged step. The driver compares the branch head before and after each step, so no stop fires until a step changes a watched file.

> See above.

**Error / sad path:** If git or the branch ref is unreadable, the driver skips the check, as it does for `Restart:`. If no `Confirmation:` row names the setup command, or the command differs, the skill stops and asks the human. If a hook fails to run, the skill stops and reports it.

> See above.

**Cross-session continuity:** The driver holds no state across the stop. The new driver reads `position` from the branch ref. An interrupted setup rerun is safe to repeat.

> See above.

## Acceptance Criteria

- [ ] A step that changes a file under `ravintio-zero/skills/` makes the driver print a `Setup:` line and exit 1.
- [ ] A step that changes only tests makes no `Setup:` line.
- [ ] A step that changes both a `Restart:` file and a `Setup:` file prints one line that names both.
- [ ] The initiative skill names the `Setup:` stop, the command source, and the hook check.
- [ ] `roadmap-standards.md` documents the stop.
