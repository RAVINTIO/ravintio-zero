---
title: "Feature Brief - Setup safety"
summary: "Four setup fixes: confine manifest removal, copy whole capability skill folders, keep a developer's CLAUDE.md, and prune retired commands."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Setup safety

**Feature ID:** 0000381-setup-safety

## Business Goal

Setup must never delete or overwrite files a developer owns, and it must install everything a developer ships. Backlog entries 0000262, 0000289, 0000290, and 0000293 each break that rule today. Step 5 of initiative 0000360 fixes all four in `setup.sh` and `setup.ps1`.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Manifest confinement (0000262) | As a developer, I re-run setup, so that it removes only skill folders inside my tool's skills directory. | must-have | 1 |
| Whole capability skill folders (0000289) | As a developer, I keep a skill with `references/` in `ravintio-overrides/capability-skills/`, so that setup installs every file of it. | must-have | 1 |
| Keep own CLAUDE.md (0000290) | As a developer, I install the pack into a repo that has a `CLAUDE.md`, so that my content moves to `ravintio-overrides/instructions/` instead of vanishing. | must-have | 1 |
| Prune retired commands (0000293) | As a developer, I re-run setup, so that `.claude/commands/` holds only commands the pack ships and my own. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All four | Tests for `setup.sh` and `setup.ps1` pass |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack source, setup scripts, migrations, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `.claude/skills/.ravintio-manifest` | ravintio-zero | none |
| `.claude/commands/.ravintio-manifest` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, Node (migration ledger only) |
| Testing | Bash and PowerShell suites under `ravintio-zero/tests/regression/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Relative manifest paths and a confinement check in `setup.sh` and `setup.ps1`.
- Whole-folder capability skill copy in both scripts.
- First-install `CLAUDE.md` preservation in both scripts.
- A command manifest, a retired-command prune, and migration 0008.
- A test that proves no suite changes `.claude/skills/` in the real repo.

### Out of Scope
- Uninstall, strict-mode persistence, and update commands (step 6).
- Finding the original cause of the 2026-10-28 emptied skills beyond the manifest hypothesis.

### Deferred
- Nothing.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | No removal outside `$PROJECT_ROOT/$TOOL_SKILLS_DIR` | Test with absolute, `..`, and symlink manifest lines |
| Parity | `setup.sh` and `setup.ps1` install the same files | Paired tests |

## Constraints and Assumptions

### Constraints
- Hard Limit 6 and the guard rules: no change may widen a guard.
- Pack prose follows the writing standard.

### Assumptions
- A legacy manifest holds absolute paths. Setup reads both forms during the transition.

## Scenario Paths

**Happy path:** A re-run reads a relative manifest, removes only listed folders inside the skills directory, copies capability skill folders whole, and prunes retired commands.

**First-run path:** With no manifest and a developer `CLAUDE.md`, setup moves its content to `ravintio-overrides/instructions/` and prints the path.

**Error / sad path:** A manifest line that resolves outside the skills directory is skipped with a warning. A folder with no `SKILL.md` warns and installs nothing.

**Cross-session continuity:** Setup is idempotent. A re-run after an interrupt reaches the same state, and the preserved instructions file is never overwritten.

## Acceptance Criteria

- [ ] Setup ignores a manifest line that points outside `$PROJECT_ROOT/$TOOL_SKILLS_DIR`, and writes manifest paths relative to the repo root.
- [ ] No suite changes `.claude/skills/` in the real repo, checked by a listing before and after the full run.
- [ ] A capability skill with a `references/` file installs with that file, and a folder with no `SKILL.md` still warns and installs nothing.
- [ ] A first install over a custom `CLAUDE.md` moves its content to `ravintio-overrides/instructions/`, names the file, and the new `CLAUDE.md` includes it.
- [ ] After setup, `.claude/commands/` has no `fast-path.md`, `change-pipeline.md`, or `retrofit.md`, and a developer's own command survives a re-run.
- [ ] `setup.sh` and `setup.ps1` behave the same for all of the above.
