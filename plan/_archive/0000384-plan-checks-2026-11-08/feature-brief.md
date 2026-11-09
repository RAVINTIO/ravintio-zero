---
title: "Feature Brief - Plan checks"
summary: "Six plan-phase checks and one ADR home, built from backlog entries 0000255, 0000263, 0000333, 0000347, 0000280, and 0000364."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Plan checks

**Feature ID:** 0000384-plan-checks

> Built by the initiative step from its chart row. Backlog entries pulled in: 0000255, 0000263, 0000333, 0000347, 0000280, 0000364.

## Business Goal

Seven retrospectives found plan-phase gaps that cost a rework cycle or a lost round trip each. This feature moves each gap into a check that fails before P2. It also gives every ADR one permanent home in `docs/adr/`.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Shell version check (0000255) | As a pack maintainer, I want the plan check to flag a shell feature that Bash 3.2 lacks, so that P2 does not rework the design. | should-have | 1 |
| Component Paths in the design (0000263) | As an orchestrator, I want the design template to hold `## Component Paths`, so that `gate-write` passes a subagent's first write. | should-have | 1 |
| Commit limit and living docs unit (0000333) | As a dispatching agent, I want the dispatch template to state the 72-character subject limit and the plan to hold a living docs unit, so that no subagent retries a commit and ship writes no living docs. | should-have | 1 |
| Shared resources in the concurrency plan (0000347) | As a planner, I want the concurrency plan to name shared runtime resources, so that two units with one port or build folder never share a batch. | should-have | 1 |
| ADRs in `docs/adr/` (0000280) | As a maintainer, I want every ADR in `docs/adr/` under a repo-wide number, so that no archive pass loses a decision and no number repeats. | should-have | 1 |
| Human-only settings check (0000364) | As an initiative step, I want P1 to read each human-only setting that the chart names, so that a wrong setting blocks before P2. | should-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The pack: skills, templates, standards, scripts, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `docs/adr/` and `docs/adr/.next-id` | ravintio-zero | none |

### Integration Points

None. All changes are files inside the pack and the repo docs.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM, built-ins only) and Bash, with PowerShell twins where the pack has them |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions (`ravintio.yml`) |
| Build target | local |

## Scope Boundaries

### In Scope
- Checks and template changes for entries 0000255, 0000263, 0000333, 0000347, and 0000364.
- `docs/adr/` as the ADR home, with the plan and ship changes, a migration, and the restore of ADRs from features 0000001 to 0000029.

### Out of Scope
- Per-component ADR folders.
- Any hook change that widens a guard.
- Light discovery (step 11), which waits for this step.

### Deferred
- The installed copy under `.claude/skills/` refreshes at the driver `Setup:` stop after merge.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Migration idempotence | A second run changes zero files | Suite compares the tree before and after |
| Check cost | `consistency-check.mjs` finishes in under 2 s on a 50-file plan | Suite timing |

## Constraints and Assumptions

### Constraints
- Hard Limits 1 to 7 of this repo apply. No hook gains an allowed form.

### Assumptions
- Git history holds the ADRs of features 0000001 to 0000029.

## Scenario Paths

**Happy path:** A planner writes an ADR with a reserved number into `docs/adr/`, and the consistency check passes.

> The plan skill reserves a number, writes the ADR, and the check resolves every reference.

**First-run path:** A repo has no `docs/adr/`.

> The migration creates the folder and the counter, and moves the archived ADRs.

**Error / sad path:** An ADR names a Bash 4 feature with no oldest-shell line, or a human-only setting is wrong.

> The check prints a finding or a `Blocked:` line before P2.

**Cross-session continuity:** The migration stops half-way.

> It writes files by path and a rerun skips what exists, so a rerun finishes the move.

## Acceptance Criteria

- [ ] A fixture ADR with a Bash 4 feature fails the consistency check until it names the older shell.
- [ ] A design written from the template lets `gate-write` pass a path under a listed folder.
- [ ] The dispatch template states the 72-character limit, and a plan with no living docs unit fails the check.
- [ ] Two units in one batch that share a resource fail check 8.
- [ ] Every ADR lives in `docs/adr/` under a unique number, and the index lists all of them.
- [ ] P1 prints a `Blocked:` line for a human-only setting that reads wrong.
