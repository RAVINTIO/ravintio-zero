---
title: "Feature Brief - Initiative history checks"
summary: "Scripts and CI checks that stop an untitled or squashed initiative history reaching main."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Initiative history checks

**Feature ID:** 0000319-initiative-history-checks

## Business Goal

In initiative 0000238, PR #72 and PR #74 each carried 23 untitled direct commits to `main`, and PR #72 landed as a squash that hid the step history. No check flagged either. This feature adds a history script, CI triggers, and a main-branch check so each failure shows before or as it reaches `main`.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| History script | As a maintainer, I run a script that lists the first-parent commits of an `initiative/*` branch and fails on an untitled one, so that a direct commit shows before the PR to `main`. | must-have | 1 |
| CI history check | As a reviewer, I see CI run the script on each PR from `initiative/*` to `main`, so that a bad history fails the PR. | must-have | 1 |
| Delivery check | As a maintainer, I see I-E Delivery run the script and put the merge commit instruction in the PR title and body top, so that the landing button shows how to merge. | must-have | 1 |
| Push CI | As a maintainer, I see CI run on each push to `initiative/**`, so that a direct push runs the suite. `release-tag` stays on `main` and `master`. | must-have | 1 |
| Squash check | As a maintainer, I see CI fail a push to `main` whose newest commit came from an initiative PR and has one parent, and I find the repository ruleset in the setup docs, so that a squash is flagged at once. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Scripts, workflow templates, standards, and skills |

### Data Ownership

None.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| CI workflow | history script | `node` command | Exit 0 on pass, exit 1 on fail, one line per failing commit |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js, built-in modules only |
| Testing | Bash suites, PowerShell parity where a suite already has it |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `ravintio-zero/scripts/check-initiative-history.mjs` and `ravintio-zero/scripts/check-main-merge.mjs`.
- Both workflow copies: the `push` trigger, the history job, the main check, and the `release-tag` guard.
- I-E Delivery text in the standards and the initiative skill.
- A doc that names the `main` ruleset setting.
- Tests, docs, version, and changelog.

### Out of Scope
- Applying the GitHub ruleset. The human does that.
- A report of CI failures on the initiative branch by the driver (suggested in entry 0000277, not in its wanted outcome).
- Hook changes.

### Deferred
- The driver or initiative skill reporting a failed CI run on the initiative branch before the next step. It needs the driver to read CI state, which no entry in this initiative covers.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | The script gives the same result for the same history | Suite runs on fixture repos |
| Security | CI adds no token scope and no write permission | Workflow `permissions` stay `contents: read` |

## Constraints and Assumptions

### Constraints
- The script has no exception list.
- Code and docs land together.

### Assumptions
- GitHub writes `Merge pull request #n from owner/initiative/...` for a merge commit, and `{title} (#n)` for a squash.

## Scenario Paths

**Happy path:** A titled-squash history passes locally, in CI, and at I-E Delivery.

**First-run path:** A branch with no commits since its base passes. A missing base ref fails with a clear message.

**Error path:** One untitled first-parent commit fails and is named. A one-parent commit from an initiative PR fails the main check.

**Cross-session continuity:** The scripts keep no state and read git only.
