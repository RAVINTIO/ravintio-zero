---
title: "Feature Brief - Prose checks"
summary: "Check new prose against the writing standard with a linter, a P3 edit pass, and an advisory reply check."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Prose checks

**Feature ID:** 0000390-prose-checks

## Business Goal

New prose in a Zero repo stops adding breaches of the writing standard, and the count of old breaches only falls. Today only the em dash has a check. Sentence length, banned words, semicolons, and passive voice go unchecked. Sources: backlog entries 0000301, 0000303, and 0000304.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Prose linter | As a maintainer, I see a script check Markdown and commit messages against the writing standard, so that new breaches fail the check. | must-have | 1 |
| Baseline ratchet | As a maintainer, I see old breaches recorded per file, so that only new or raised counts fail and the baseline only shrinks. | must-have | 1 |
| Enforcement points | As a maintainer, I see the linter run in pre-commit, CI, and `commit-msg`, so that breaches stop at commit time. | must-have | 1 |
| P3 edit pass | As a maintainer, I see a fresh-context subagent review changed user-facing docs at P3, so that the problems a script misses get fixed before ship. | must-have | 1 |
| Advisory reply check | As a developer, I get a short note when a reply drifts from the standard, so that I can see the drift without a block. | should-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Standards, scripts, hooks, skills, setup, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Pack files under `ravintio-zero/` | ravintio-zero | none |
| `plan/state/prose-baseline.json` | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|----|--------|----------|
| `scripts/prose-check.mjs`, `hooks/enforcement/check-reply-writing.mjs` | `hooks/enforcement/prose-rules.mjs` | ES import | Returns the breaches of a text |
| `pre-commit`, `commit-msg`, CI | `scripts/prose-check.mjs` | process call | Exits 1 on a new breach |
| `ravintio-validate-and-accept` | `scripts/prose-check.mjs` | process call | Pass condition of the edit loop |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, and Node (ESM, no packages) |
| Testing | Pack shell and PowerShell suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A shared rules module and a linter script with `check`, `update`, and `diff` commands
- A per-file baseline at `plan/state/prose-baseline.json`
- Pre-commit, CI, and `commit-msg` wiring, in the hooks and in the workflow template
- A P3 edit pass in the validate skill, scoped to `docs/`, READMEs, and the changelog
- An advisory Stop hook, wired by `setup.sh` and `setup.ps1`
- Docs for the new script and hook

### Out of Scope
- Rewriting existing pack prose (step 19)
- Archetype overrides of the standard (step 15)
- Any change to a guard hook

### Deferred
- Baseline path handling for the pack source move (step 20)

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Pre-commit time | Checks staged files only | Test with one staged file |
| Hook safety | The Stop hook exits 0 in every case | Test with bad input |

## Constraints and Assumptions

### Constraints
- Node with no packages. Hooks install as one file beside `read-stdin.mjs`.
- No new guard. The Stop hook never blocks.

### Assumptions
- The passive-voice check is a heuristic. A false positive is a baseline entry, not a stop.

## Scenario Paths

**Happy path:** A maintainer adds a doc. Pre-commit runs the linter on the staged files and passes. CI passes.

> A staged file with no new breach passes.

**First-run path:** A repo with no baseline file gets one from `update --init`. A missing baseline counts as empty.

> `check` on a repo with no baseline fails on any breach and names it.

**Error / sad path:** A 26-word sentence in `docs/` fails with the file and line. A raised baseline fails the diff check.

> The script exits 1 and prints `file:line rule`.

**Cross-session continuity:** The baseline lives in git. A rerun reads the same file.

> No session state is kept.

## Acceptance Criteria

- [ ] A new 26-word sentence in `docs/` fails the check and names the file and line.
- [ ] A sentence inside a code block passes.
- [ ] An existing baselined breach passes until someone fixes it.
- [ ] A change that raises a file's baseline fails.
- [ ] The validate skill names the edit pass and its scope, and the pass ends only when the linter passes on the changed docs.
- [ ] A reply with a 30-word sentence produces a note that quotes its first words, and the hook exits 0 in every case.
