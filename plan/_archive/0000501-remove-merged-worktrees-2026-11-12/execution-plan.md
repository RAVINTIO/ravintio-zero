# Execution Plan - Driver removes merged step worktrees

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Version:** 0.107.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| none | plan | No capability skill applies |

## Functional Requirements Directory

Functional requirements are split into individual files, one user story per file, at `plan/current/requirements/`.

| File | Requirement |
|------|------------|
| [req-001-sweep-merged-worktrees.md](requirements/req-001-sweep-merged-worktrees.md) | The driver removes the safe worktree of each merged step at start |
| [req-002-keep-dirty-worktrees.md](requirements/req-002-keep-dirty-worktrees.md) | The driver keeps a worktree with uncommitted files or a git error |
| [req-003-keep-unpushed-and-live-worktrees.md](requirements/req-003-keep-unpushed-and-live-worktrees.md) | The driver keeps a worktree with unpushed commits or a live session |
| [req-004-docs-state-the-sweep.md](requirements/req-004-docs-state-the-sweep.md) | The driver header, the standards, and an ADR state the sweep |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Safety | The sweep never removes a worktree that holds an uncommitted file, an unpushed commit, a live session, or a git error | 0 removals in the tests for each case | The new test file |

## API Summary

No API changes.

## Data Model Summary

| Entity | Owner Component | Key Fields | Relationships |
|--------|----------------|------------|--------------|
| `plan/.initiative-worktrees/step-{n}` | ravintio-zero | one git worktree per step | Read by the step session and removed by the driver |

## Component Interactions

```mermaid
flowchart LR
    A[schedule start] --> B[sweepMergedWorktrees]
    B --> C{merged step with a worktree}
    C -->|live pid, dirty, off origin, git error| D[print Kept line]
    C -->|safe| E[git worktree remove]
```

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Backlog entry id 0000502 | `test-0000399-req-002-add-step.sh` reads the counter value 0000502, not the entry | U3 |
| New test file | `test-0000164-req-008-no-process-substitution-loops.sh` | U1 |
| Reference file edit | none found | U3 |
| Skill-text budget | none found | U3 |
| Fixture-pinned line | none found | U3 |

## Branch-point reads

| File | Commit read | Unit |
|------|-------------|------|
| `src/ravintio-zero/scripts/initiative-run.mjs` | f99c48a4 | U2 |
| `src/ravintio-zero/standards/roadmap-standards.md` | f99c48a4 | U3 |
| `docs/decisions-index.md` | f99c48a4 | U3 |
| `docs/adr/0326-driver-sweeps-merged-worktrees.md` | new | U3 |
| `src/ravintio-zero/tests/test-0000501-req-001-004-sweep.sh` | new | U1 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason | Shared resources |
|------|-----------|--------|-------|-------------------|------------------|
| U1 | none | `src/ravintio-zero/tests/test-0000501-req-001-004-sweep.sh` | 1 | Tests first: the tests fail before U2 starts | none |
| U2 | U1 | `src/ravintio-zero/scripts/initiative-run.mjs` | 2 | none | none |
| U3 | U1 | `src/ravintio-zero/standards/roadmap-standards.md`, `docs/adr/0326-driver-sweeps-merged-worktrees.md`, `docs/decisions-index.md` | 2 | none | none |
| U4 | U2, U3 | `ravintio-zero/` | 3 | It copies the files that U2 and U3 write | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | A squash merge with `--delete-branch` removes `origin/feat/{id}` | The driver keeps a worktree that could go, and the `Kept:` line says why |
| A-002 | `git status --porcelain` lists every uncommitted file | A file could be lost, and the test pins the listing |

## Open Questions

None.
