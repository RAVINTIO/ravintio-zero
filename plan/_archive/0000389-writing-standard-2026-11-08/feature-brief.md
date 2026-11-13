---
title: "Feature Brief - Writing standard"
summary: "Ship a writing standard and install it for each tool."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Writing standard

**Feature ID:** 0000389-writing-standard

## Business Goal

Every developer who installs Zero gets the same British English variant of the Google developer documentation style, in Claude Code and in Codex. Today the variant lives only in one person's settings. The shipped `formatting-standards.md` also conflicts with it on dates and semicolons. Source: backlog entry 0000300.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Writing standard | As a developer who installs Zero, I get `writing-standards.md`, so that my agent writes to one documented standard. | must-have | 1 |
| Standards agree | As a maintainer, I see `formatting-standards.md` and `writing-standards.md` agree on dates and semicolons, so that the agent gets no conflicting rule. | must-have | 1 |
| Claude Code output style | As a Claude Code user, I get an output style generated from the standard, so that the main session follows it. | must-have | 1 |
| Codex section | As a Codex user, I get a writing section in `AGENTS.md`, so that Codex follows the standard. | must-have | 1 |
| Opt out | As a developer with my own style, I can skip the install, so that Zero never overrides my choice. | must-have | 1 |
| Briefs name the standard | As a maintainer, I see every subagent and step-session brief name the standard, so that output styles reach subagents. | should-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Standards, setup scripts, hooks, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Pack files under `ravintio-zero/` | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `setup.sh`, `setup.ps1` | `scripts/writing-style.mjs` | node call | Prints the output style or the Codex section from the standard |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, and Node (ESM, no packages) |
| Testing | Pack shell and PowerShell suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `ravintio-zero/standards/writing-standards.md`
- A generator script that reads the standard and prints both outputs
- Setup for Claude Code (`.claude/output-styles/ravintio-writing.md` and `outputStyle`) and Codex (`AGENTS.md` section), in `setup.sh` and `setup.ps1`
- A `--no-writing-style` flag
- Agreement between `formatting-standards.md` and the standard on dates and semicolons
- The `em-dash-guard.mjs` suggestion
- The standard named in the subagent dispatch template and the step-session brief

### Out of Scope
- Rewriting existing pack prose to the standard (step 19)
- A prose linter (step 14)
- Rewriting dates in existing archived artifacts

### Deferred
- Archetype overrides of the standard (step 15)

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Drift | 0 differences between the standard and each generated output | A test regenerates and compares |
| Idempotence | A second setup run changes no file | A test runs setup twice |

## Constraints and Assumptions

### Constraints
- Setup never overwrites an existing `outputStyle` value.
- The orchestrator skill stays under its size cap.

### Assumptions
- Claude Code reads project-level output styles from `.claude/output-styles/` and `outputStyle` from `.claude/settings.json`. The plan phase confirms this in the Claude Code docs.

## Scenario Paths

**Happy path:** A developer runs setup for Claude Code. Setup writes the output style and sets `outputStyle`. The next session follows the standard.

> Same as above. For Codex, setup adds the writing section to `AGENTS.md`.

**First-run path:** A repo with no `.claude/settings.json` gets the file with `outputStyle` set.

> Setup creates the file with `outputStyle` set.

**Error / sad path:** `outputStyle` already names another style, or the settings file is not valid JSON.

> Setup leaves the value and prints that it did. Invalid JSON follows the existing fixed error line.

**Cross-session continuity:** A rerun with `--no-writing-style` after an earlier install.

> Setup writes no output style and leaves `outputStyle` as it finds it.

## Acceptance Criteria

- [ ] After a Claude Code install, `.claude/output-styles/ravintio-writing.md` exists and `outputStyle` names it.
- [ ] After a Codex install, `AGENTS.md` holds the writing section.
- [ ] Setup leaves an existing `outputStyle` value in place and says so.
- [ ] `--no-writing-style` installs neither output.
- [ ] `formatting-standards.md` and `writing-standards.md` agree on dates and semicolons.
- [ ] Each generated output matches a fresh generation from the standard.
