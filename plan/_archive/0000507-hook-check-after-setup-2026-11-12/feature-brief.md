---
title: "Feature Brief - Check every hook after setup"
summary: "A script that runs every hook in .claude/settings.json after setup and reports a failure."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Check every hook after setup

**Feature ID:** 0000507-hook-check-after-setup

> Built from backlog entry 0000508. Planned bump: minor, 0.109.0 to 0.110.0.

## Business Goal

After setup, the coordinator needs to know that every hook loads and runs. No command does this today. On 2026-11-11 the first ad hoc check failed for every hook because it did not set `CLAUDE_PROJECT_DIR`.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Hook check script | As the coordinator, I run one command after setup, so that I know every installed hook loads and runs. | must-have | 1 |
| Driver wiring | As the driver, I run the check after setup and stop on a failure, so that a broken hook never reaches a step. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Adds `scripts/hook-check.mjs`, its test, and the driver call |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| driver | hook-check.mjs | process call | exit 0 on pass, non-zero on a failure |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (`.mjs`) |
| Testing | pack shell and Node tests under `tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `ravintio-zero/scripts/hook-check.mjs` and a test beside the other script tests.
- One fixed sample input per hook event and matcher. A guard's exit 2 counts as a pass.
- Driver wiring that stops with a `Blocked:` line on a failure.

### Out of Scope
- Changing any hook's behaviour.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Security | The check runs only commands in `.claude/settings.json` | test |

## Constraints and Assumptions

### Constraints
- The check sets `CLAUDE_PROJECT_DIR` itself.

### Assumptions
- Every hook command accepts JSON on stdin.

## Scenario Paths

**Happy path:** The check runs each hook with a sample input. Every hook exits 0 or 2. The script exits 0.

> Every hook passes and the driver carries on.

**First-run path:** Right after setup, `.claude/settings.json` lists the installed hooks and the check finds each command.

> The check runs against a fresh install.

**Error / sad path:** A hook fails to load or exits with another code. The script names the hook and exits non-zero. The driver prints `Blocked:`.

> The driver stops.

**Cross-session continuity:** The check keeps no state. A rerun gives the same result.

> No state is at risk.

## Acceptance Criteria

- [ ] The script runs every hook in `.claude/settings.json` with `CLAUDE_PROJECT_DIR` set.
- [ ] The script names a hook that fails to load and exits non-zero.
- [ ] A guard's deliberate block (exit 2) counts as a pass.
- [ ] The driver runs the check after setup and stops with a `Blocked:` line on a failure.
