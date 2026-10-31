---
title: "Feature Brief - block forced adds"
summary: "A hook blocks git add -f, the tracked gitignore lists the driver paths, and CI and ship fail on a committed ignored file."
status: "approved"
version: "0.1.0"
---
# Feature Brief - block forced adds

**Feature ID:** 0000317-block-forced-adds

> Built from backlog entry 0000276 by initiative 0000312 step 5.

## Business Goal

In initiative 0000238 step 6, `git add -f plan` committed 15 driver logs, the human ack, the runner lock, and a queued entry. The push was denied and the step stopped for about four hours until a history rewrite. No pack rule forbids `git add -f`, and no check finds an ignored file in a commit before the push. Most driver paths sit only in `.git/info/exclude`, which a fresh clone lacks, so CI would not see them as ignored. No step should commit an ignored file.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Rule against forced adds | As a maintainer, I want the orchestrator skill to forbid `git add -f`, so that a step never forces an ignored file into a commit. | must-have | 1 |
| Forced-add guard | As a maintainer, I want a hook that blocks a forced add, so that the rule holds when a step forgets it. | must-have | 1 |
| Tracked driver ignores | As a developer with a fresh clone, I want the driver paths in the tracked `.gitignore`, so that git and CI treat them as ignored. | must-have | 1 |
| Ignored-file check | As a maintainer, I want ship and CI to fail when a committed file matches an ignore rule, so that a forced add that slips past the hook never reaches `main`. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All four | The hook blocks `git add -f plan` and `git add --force plan`, allows `git add plan/current`, and CI fails a branch with a committed ignored file. |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Setup scripts, enforcement hooks, tests, standards, CI template |

### Data Ownership

No data store.

### Integration Points

Claude Code `.claude/settings.json` hooks, written by setup. The pack and tracked CI workflows.

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
- An orchestrator skill rule: a step never runs `git add -f` or `git add --force`.
- A PreToolUse Bash guard that blocks a forced add. It also blocks combined short flags such as `-fA` and the `git -C {dir} add -f` form. It allows `git add plan/current`.
- Setup wiring for the guard in `setup.sh` and `setup.ps1`, through `guard-run.mjs` in `guard` mode.
- `.gitignore` entries for `plan/.initiative-logs/`, `plan/.initiative-queue/`, and `plan/.initiative-runner.lock`.
- A check that fails when `git ls-files -ci --exclude-standard` lists a file, run by ship and by CI in the pack workflow and the tracked workflow.
- Tests and docs for each change.

### Out of Scope
- Changes to what any existing guard blocks.
- A Codex hook for the new guard. Codex wires `merge-guard` only.
- Blocking other ways to stage an ignored file, such as `git update-index --add`.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Strictness | No case blocked today becomes allowed | Existing guard tests pass unchanged |
| Latency | The guard adds under 200 ms to a Bash call | Timed test run |

## Constraints and Assumptions

### Constraints
- Code and docs land together.
- The new hook makes the guards stricter and lets nothing pass that a hook blocks today.

### Assumptions
- A tracked file that matches an ignore rule on purpose gets a negation rule in `.gitignore`, and the CI check stays.

## Scenario Paths

**Happy path:** A step runs `git add plan/current` and the hook allows it.

**First-run path:** A fresh clone with no `.git/info/exclude` entries treats the driver paths as ignored, because the tracked `.gitignore` lists them.

**Error / sad path:** A step runs `git add -f plan` and the hook blocks it with a message that names the rule.

**Cross-session continuity:** A setup rerun wires the guard once and leaves one copy of each hook.

## Acceptance Criteria

- [ ] The hook blocks `git add -f plan` and `git add --force plan`.
- [ ] The hook blocks `git add -fA plan` and `git -C plan add -f x`.
- [ ] The hook allows `git add plan/current`.
- [ ] `.gitignore` lists `plan/.initiative-logs/`, `plan/.initiative-queue/`, and `plan/.initiative-runner.lock`.
- [ ] The CI check fails a branch with a committed ignored file and passes a clean branch.
- [ ] `setup.ps1` wires the same hook.
