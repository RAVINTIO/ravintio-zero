---
title: "Feature Brief - hooks fail closed"
summary: "Setup keeps Bash in the project root, wires hooks from the project root, and a guard that cannot run blocks."
status: "approved"
version: "0.1.0"
---
# Feature Brief - hooks fail closed

**Feature ID:** 0000316-hooks-fail-closed

> Built from backlog entries 0000287 and 0000288 by initiative 0000312 step 4.

## Business Goal

A `cd` in one Bash command moves the working directory for later commands and hooks. Every hook is wired with a path relative to that directory, so the next hook fails with `MODULE_NOT_FOUND` and exits 1. Claude Code treats exit 1 as non-blocking, so `gate-write`, `merge-guard`, `ratchet-check`, and `em-dash-guard` enforced nothing until the directory returned to the root. This happened on 2026-10-31 and in initiative 0000238. Hooks should run from any directory, and a guard that cannot run should block.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Bash stays in the project root | As a developer, I run any `cd` in a Bash command, so that later commands and hooks still run from the project root. | must-have | 1 |
| Hooks resolve from the project root | As a developer, I start a session from a subfolder, so that every hook still finds its script. | must-have | 1 |
| Guards fail closed | As a maintainer, I want a guard whose script is missing or crashes to block and name the script, so that the guard never silently allows. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All three | Each hook command in `.claude/settings.json` runs from a subfolder and a missing guard script exits 2. |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Setup scripts, enforcement hooks, tests, standards |

### Data Ownership

No data store.

### Integration Points

Claude Code settings (`env`, `hooks`) and the Codex `hooks.json`. Both are written by setup.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, Node.js (ES modules), Markdown |
| Runtime | Node.js, Bash |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash and PowerShell test scripts with `helpers/assert.sh` |
| IaC | none |
| Cloud | none |
| Compute | local |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `setup.sh` and `setup.ps1` write `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` under `env` in `.claude/settings.json`, keep other `env` entries, and leave one copy after a rerun.
- Setup wires every Claude Code hook command with `${CLAUDE_PROJECT_DIR}` in place of a relative path. Setup wires the Codex hook command with the absolute project path.
- A launcher, `guard-run.mjs`, runs each PreToolUse guard. A missing or crashing guard script makes the launcher exit 2 and name the script. Every case a guard blocks today stays blocked.
- Advisory hooks stay non-blocking and report a missing script once.
- Tests for each change, and docs that match.

### Out of Scope
- Changes to what any guard blocks.
- New guards.
- Hooks for tools other than Claude Code and Codex.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Strictness | No case blocked today becomes allowed | Existing guard tests pass unchanged |
| Latency | Launcher adds under 200 ms to a guard call | Timed test run |

## Constraints and Assumptions

### Constraints
- Code and docs land together.
- No change may let anything pass that a guard blocks today.

### Assumptions
- Claude Code substitutes `${CLAUDE_PROJECT_DIR}` in a hook `command` string. The docs confirm this on 2026-10-31.

## Scenario Paths

**Happy path:** After a setup rerun, a hook started from a subfolder runs its script, and a `cd` in a Bash command leaves later commands in the project root.

> See above.

**First-run path:** On a fresh install, setup writes the `env` setting and the new hook commands in one pass.

> See above.

**Error / sad path:** A guard whose script is missing or crashes exits 2 and names the script, so the tool call is blocked.

> See above.

**Cross-session continuity:** A setup rerun replaces old relative hook commands and leaves one copy of each hook and of the `env` setting.

> See above.

## Acceptance Criteria

- [ ] Each hook in `.claude/settings.json` runs from a subfolder.
- [ ] A guard with a missing script exits 2 and names it.
- [ ] Every case a guard blocks today stays blocked.
- [ ] `.claude/settings.json` holds `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` set to `1` under `env`, other `env` entries survive, and a rerun leaves one copy.
- [ ] `setup.ps1` writes the same settings.
