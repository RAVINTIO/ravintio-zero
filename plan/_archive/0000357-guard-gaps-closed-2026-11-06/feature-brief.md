---
title: "Feature Brief - Guard gaps closed"
summary: "A missing guard launcher blocks the call, the forced-add guard covers more forms and Codex, and the prefix-misses log is ignored in every clone."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Guard gaps closed

**Feature ID:** 0000357-guard-gaps-closed

## Business Goal

Three guard gaps from initiative 0000312 stay open. A missing `guard-run.mjs` lets every guarded call through. The forced-add guard misses `git stage -f`, subshells, and flags held in variables, and Codex has no forced-add guard. A fresh clone does not ignore `plan/.prefix-misses.log`. Pulled in from entries 0000340, 0000341, and 0000342.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Fail closed with no launcher | As a maintainer, I find that a guard hook blocks the call when `guard-run.mjs` is missing, so that no file removal turns every guard off. | must-have | 1 |
| Wider forced-add guard | As a maintainer, I find `git stage -f`, a subshell, and a flag in a variable blocked, so that an ignored file stays out of the index. | must-have | 1 |
| Forced-add guard in Codex | As a Codex user, I get the forced-add guard from setup, so that Codex sessions block the same forms. | should-have | 1 |
| Ignore the prefix-misses log | As a developer, I find `plan/.prefix-misses.log` ignored in a fresh clone and in CI, so that the ignored-file check sees a forced add of it. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero pack | component-pack | existing | Hooks, setup, tests, and standards |

### Data Ownership

None. No data store changes.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| Claude Code | `guard-run.mjs` | PreToolUse hook command | Exit 2 blocks the call. Exit 1 does not. |
| Codex | `block-forced-add.mjs` | PreToolUse group for Bash | Exit 2 blocks the call, reason on stderr |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Node (`.mjs`), PowerShell |
| Testing | Bash test suites in `ravintio-zero/tests/`, run by `run-tests.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- A guard-mode hook command in `setup.sh` and `setup.ps1` that exits 2 when `guard-run.mjs` is missing, and for the Codex command too.
- `block-forced-add.mjs` blocks `git stage`, subshells, a flag in a variable, and a segment it can't parse.
- The forced-add guard in the Codex adapter, in `setup.sh` and `setup.ps1`.
- `plan/.prefix-misses.log` in `ravintio-zero/.gitignore` and in this repo's `.gitignore`.
- A test for each form, and updates to `hook-enforcement.md`.

### Out of Scope
- Advisory hooks. A missing launcher keeps its non-blocking behaviour, because exit 2 on a Stop or UserPromptSubmit hook would block the session.
- A change to `merge-guard.mjs`.
- Adding the ignore rule to a consumer repo that already holds a `.gitignore`. Setup keeps an existing file.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Security | A guard never passes a call it cannot run or parse | Hook tests with the launcher removed and with each form |
| Compatibility | Existing hook entries and their filters keep working | The hook filter suites |

## Constraints and Assumptions

### Constraints
- Widening a guard needs a test case for each form.
- If the Codex hook model can't express the forced-add guard, the step files a backlog entry and carries on.

### Assumptions
- Claude Code runs hook commands through a POSIX shell, so `||` and `exit 2` work. On Windows it uses Git Bash.

## Scenario Paths

**Happy path:** A guard hook blocks a call when `guard-run.mjs` is missing, and `git stage -f x` is blocked in Claude Code and in Codex.

> A maintainer runs setup. The hook command wraps the launcher. A call to `(git add -f plan/x)` exits 2.

**First-run path:**

> A new install gets the wrapped commands, the Codex forced-add group, and a `.gitignore` that holds the log rule.

**Error / sad path:**

> If `node` or the launcher is missing, the guard command exits 2 with a message. A segment with `git add $FLAGS x` exits 2.

**Cross-session continuity:**

> Nothing is stateful. Each hook call is independent.

## Acceptance Criteria

- [ ] With `guard-run.mjs` removed, each guard hook command exits 2.
- [ ] `git stage -f x`, `(git add -f x)`, and `F=-f; git add $F x` each exit 2 from `block-forced-add.mjs`.
- [ ] Setup wires `block-forced-add` into Codex, in both setup scripts.
- [ ] `ravintio-zero/.gitignore` and `.gitignore` hold `plan/.prefix-misses.log`.
