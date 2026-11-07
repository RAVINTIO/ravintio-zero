---
title: "Feature Brief - Safe parallel commits"
summary: "The step session never changes the shared tree under a running subagent, and each parallel unit commits only its own paths."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Safe parallel commits

**Feature ID:** 0000359-safe-parallel-commits

## Business Goal

Parallel units share one working tree and one index. A step session once stashed the tree under three running subagents, and a plain `git commit` once took another unit's staged files. Pulled in from entries 0000331 and 0000336.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| No tree-wide git under subagents | As a maintainer, I find the orchestrator and implement skills ban `git stash`, `git checkout -- {path}`, `git reset`, and `git clean` while a subagent runs, so that no step changes the tree under a running unit. | must-have | 1 |
| Scratch clone for a clean tree | As a maintainer, I find the implement skill names a scratch clone as the way to test a clean tree mid-phase, so that a unit needing one has a safe route. | must-have | 1 |
| Commit own paths only | As a maintainer, I find the dispatch standard tells each unit to run `git commit -m "{message}" -- {paths}` and bans `git commit --amend` in a batch, so that a unit's commit holds only its own paths. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero pack | component-pack | existing | Skills, standards, scripts, and tests |

### Data Ownership

None. No data store changes.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Bash |
| Testing | Bash test suites in `ravintio-zero/tests/`, run by `run-tests.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Add a rule to the orchestrator skill: while any subagent of the step runs, the step session never runs `git stash`, `git checkout -- {path}`, `git reset`, or `git clean`.
- Add a rule to the orchestrator and implement skills to record in the build log when the step waits for its subagents before a tree-wide git operation.
- Name the scratch clone in the implement skill as the way to test a clean tree mid-phase.
- In `agent-dispatch-standards.md` `## Fast batches`, tell each unit to commit with `git commit -m "{message}" -- {paths}` and forbid `git commit --amend` in a batch.
- Tests that check each rule.

### Out of Scope
- A hook that blocks these git commands. The rules are text, as the entries ask.
- Rules for subagent git use beyond the existing dispatch standard.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | Each new test gives the same result on every run | Local test suites |

## Constraints and Assumptions

### Constraints
- Chart decisions for step 8 apply. No schema or dependency change.
- Setup stop after this step, because it changes skills.

### Assumptions
- A skill rule in text is enough, because the entries ask for rules and not a guard.

## Scenario Paths

**Happy path:** Parallel units each commit with `-- {paths}`, and the step session waits for them before any tree-wide git command.

> The commits hold only each unit's own paths and no stash runs.

**First-run path:** A new install gets the rules from the installed skills and standard.

> Setup copies the updated skills and standard.

**Error / sad path:** A unit needs a clean tree, or needs to fix an earlier commit.

> The unit tests in a scratch clone, or makes a new commit and never amends.

**Cross-session continuity:** Nothing is stateful.

> A resumed step reads the same rules from the skills.

## Acceptance Criteria

- [ ] The orchestrator skill names the git commands a step never runs while subagents run.
- [ ] The implement skill names the scratch clone as the way to test a clean tree.
- [ ] The dispatch standard names the `-- {paths}` form and the amend ban.
