---
title: "Feature Brief - Install lifecycle"
summary: "Six install-lifecycle changes: update and doctor commands, a clean-tree check, uninstall, strict-mode persistence, a clearer first run, and a generated pack facts file."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Install lifecycle

**Feature ID:** 0000382-install-lifecycle

## Business Goal

A developer must be able to install, update, check, and remove Zero with one command each. Backlog entries 0000283, 0000299, 0000292, 0000291, 0000298, and 0000286 cover the gaps. Step 6 of initiative 0000360 closes all six in `setup.sh` and `setup.ps1`.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Update and doctor (0000283) | As a developer, I run one command to update the pack and one to check the install, so that I know it is healthy. | must-have | 1 |
| Clean-tree check (0000299) | As a developer, I want setup to refuse uncommitted pack files, so that no unreviewed edit reaches `.claude/`. | must-have | 1 |
| Uninstall (0000292) | As a developer, I want one command that reverses setup, so that I keep my own work and drop Zero. | must-have | 1 |
| Strict mode and joining (0000291) | As a teammate who clones, I want one documented step that installs the guards. As a developer, I want the flags I pass to decide strict mode. | must-have | 1 |
| Clear first run (0000298) | As a new developer, I want `--help`, correct docs, and block messages that say what to do next. | must-have | 1 |
| Pack facts file (0000286) | As a writer, I want every pack fact in one generated file that CI keeps fresh. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All six | Tests for `setup.sh` and `setup.ps1` pass |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack source, setup scripts, hooks, docs, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `.claude/skills/.ravintio-manifest` and `.claude/commands/.ravintio-manifest` | ravintio-zero | none |
| `plan/state/{tool}.md` | ravintio-zero | none |
| `ravintio-zero/pack-facts.json` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, Node |
| Testing | Bash and PowerShell suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- `--update`, `--doctor`, and `--uninstall` in `setup.sh` and `setup.ps1`.
- A clean-tree and git-repo check before setup copies anything.
- Strict mode that follows the flags, and `--no-strict-orchestrator`.
- `--help`, the banner fix, and next-step wording in hook block messages.
- A joining section, a day-to-day commands table, and an override-skills pointer in the getting-started guide.
- A session-start check for missing hooks and a failing doctor.
- `plan/current/` created by setup.
- `scripts/pack-facts.mjs`, the committed facts file, and a CI freshness check.

### Out of Scope
- Downloading a release from the network. The update command reads a local folder.
- Paid services and the pack source move (steps 20 and 21).

### Deferred
- Nothing.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | Uninstall removes only what the manifest lists and never touches `plan/` | Tests with a developer-owned entry and a `plan/` record |
| Parity | `setup.sh` and `setup.ps1` behave the same | Paired tests |

## Constraints and Assumptions

### Constraints
- No guard gains an allowed form. Uninstall refuses while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists.
- The clean-tree check has no bypass flag.
- Pack prose follows the writing standard.

### Assumptions
- Test workspaces commit the pack before they run setup. This costs the existing suites one helper call each.

## Scenario Paths

**Happy path:** A developer commits the pack, runs setup, runs doctor, updates from a newer pack folder, and uninstalls with one command each.

**First-run path:** A teammate clones a repo with a pack and runs the documented setup command. The session-start check warns them first if no hooks are wired.

**Error / sad path:** Setup fails and names each uncommitted file, or fails outside a git repo. Doctor names a non-executable hook. Uninstall refuses during an active run.

**Cross-session continuity:** Setup, update, and uninstall are idempotent. The update keeps the flags in `plan/state/{tool}.md`.

## Acceptance Criteria

- [ ] An uncommitted change in `ravintio-zero/` or an untracked file in `ravintio-overrides/` makes setup exit non-zero, name the file, and copy nothing. An ignored file does not block setup. Setup outside a git repo exits non-zero.
- [ ] `--doctor` fails on a repo where the pack is copied but setup never ran, and fails on a non-executable hook and names it.
- [ ] `--update {source}` commits the new pack files, then keeps the flags from `plan/state/{tool}.md`.
- [ ] Setup creates `plan/current/`.
- [ ] After `--uninstall`, `core.hooksPath` is unset, `.claude/settings.json` holds no RAVINTIO hook, a developer's own entries survive, and nothing under `plan/` is deleted.
- [ ] A re-run with `--strict-orchestrator` keeps strict mode, a plain re-run keeps it, and `--no-strict-orchestrator` removes it and says so.
- [ ] `setup.sh --help` exits 0 and lists every flag, and `setup.sh` holds no invalid UTF-8.
- [ ] The getting-started guide has a joining section, a day-to-day commands table, and names `ravintio-overrides/capability-skills/`. Every hook block message names a next step.
- [ ] The facts file lists every flag `setup.sh` accepts and every hook setup wires, and CI fails when the committed file is stale.
- [ ] `setup.sh` and `setup.ps1` behave the same for all of the above.
