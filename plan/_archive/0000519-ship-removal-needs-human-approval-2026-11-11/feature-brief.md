---
title: "Feature Brief - Ship removal needs human approval"
summary: "Ship Step 4 removes plan/current with a command the safety check accepts, and P2 stops telling the agent to write docs while the suite runs."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Ship removal needs human approval

**Feature ID:** 0000519-ship-removal-needs-human-approval

Source: backlog entry 0000518-ship-removal-needs-human-approval, filed after step 57.

## Business Goal

On 2026-11-11 step 57 stopped at ship Step 4 because the Claude Code safety check refused to delete `plan/current/`. The stop cost about two hours, because the driver stayed stopped until the coordinator unblocked the step. Ship Step 4 now removes the folder with `git rm -r -q plan/current`. P2 tells the agent to write docs before the full suite starts or after it ends.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Ship removal command | As a step session, I remove `plan/current/` with `git rm -r -q plan/current`, so that the safety check accepts the removal and the step does not stop. | must-have | 1 |
| P2 docs timing | As an implementing agent, I write docs before the full suite starts or after it ends, so that the runner does not fail on a changed tree. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/current/` | ravintio-zero | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Bash |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions |

## Scope Boundaries

### In Scope
- Ship skill Step 4 text and the matching text in other pack files that name the removal.
- The P2 text in the implement skill and any file that repeats it.
- Tests, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- Guard or hook changes. No guard gains a new allowed form.
- Driver changes.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Pin accuracy | The ship skill names `git rm -r -q plan/current` and no `rm -r` of `plan/current/` | Test greps the skill |

## Constraints and Assumptions

### Constraints
- The command uses a literal path, with no `cd` and no glob.

### Assumptions
- The safety check accepts `git rm -r -q plan/current`. Evidence: the coordinator ran it on step 57. Impact if wrong: the step stops again at Step 4.

## Scenario Paths

**Happy path:** The ship step copies `plan/current/` to the archive, runs `git rm -r -q plan/current`, and continues.

**First-run path:** A step that has not shipped before reads the command from the skill text.

**Error / sad path:** If the removal command fails, the step prints `Blocked:` with the exact error and stops.

**Cross-session continuity:** The archive copy exists before the removal, so a resumed session restores `plan/current/` from the archive.

## Acceptance Criteria

- [ ] Ship Step 4 runs `git rm -r -q plan/current` from the repo root and names no `rm -r` of `plan/current/`.
- [ ] The P2 text tells the agent to write docs before the full suite starts or after it ends.
- [ ] A test checks both.
- [ ] The installed copies match the source.
