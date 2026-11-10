---
title: "Feature Brief - Regenerate shared files at merge"
summary: "The merge queue resolves shared-file conflicts itself, and a coordinator PR checks for overlap with open step PRs."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Regenerate shared files at merge

**Feature ID:** 0000456-regenerate-shared-files-at-merge

## Business Goal

Every merged step edits a few shared files, and every other open step PR then conflicts on them. Initiative 0000360 lost about six rounds of about an hour each. The queue must resolve those conflicts itself, and a coordinator PR must warn about overlap before it opens.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Shared-file resolver | As the coordinator, I want the queue to resolve conflicts on counter files and index files after the base merge, so that a step PR does not stop on them. | must-have | 1 |
| Overlap check | As the coordinator, I want `coordinator-pr-check.mjs` to name open step PRs that touch the same files, so that I land admin work at a safe time. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack scripts, docs, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Repo files under `src/ravintio-zero/` | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| merge-queue.mjs | shared-files.mjs | module import | Resolve conflicts after `git merge` |
| coordinator-pr-check.mjs | gh CLI | `gh pr list` | Changed files of open PRs |

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ES modules) |
| Runtime | Node |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash test scripts in `tests/` |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- New `shared-files.mjs` resolver that the queue calls when the base merge conflicts.
- Counter files `plan/backlog/.next-id` and `docs/adr/.next-id`: keep the higher value.
- `plan/backlog/index.md`: regenerate with `backlog-index.mjs`.
- `docs/decisions-index.md` and `docs/architecture-overview.md`: resolve `Last updated:` lines and keep both sides' added table rows.
- Overlap check in `coordinator-pr-check.mjs`.
- Docs and tests for both.

### Out of Scope
- A generator for the prose of `architecture-overview.md`.
- Resolving conflicts in any other file.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | A conflict outside the listed files still stops the queue with no resolution | Test with a conflict in another file |

## Constraints and Assumptions

### Constraints
- The queue never rewrites pushed history.
- Edit `src/ravintio-zero/`, then sync to `ravintio-zero/`.

### Assumptions
- Conflicts on these files are mechanical. Any other conflict needs a human.

## Scenario Paths

**Happy path:** The queue merges the base. Git reports conflicts only in shared files. The resolver fixes each one, and the queue commits the merge.

> As stated.

**First-run path:** A repo without `docs/adr/.next-id` or `decisions-index.md` skips those rules.

> As stated.

**Error / sad path:** A conflict in any other file aborts the merge. So does a hunk the resolver cannot read. The queue then stops as it does today.

> As stated.

**Cross-session continuity:** The resolver writes only inside the merge in progress. A stop aborts the merge, so a rerun starts clean.

> As stated.

## Acceptance Criteria

- [ ] The queue resolves a `.next-id` conflict to the higher value.
- [ ] The queue regenerates `plan/backlog/index.md` after a conflict on it.
- [ ] The queue resolves a `Last updated:` conflict and unions added table rows.
- [ ] A conflict in any other file still stops the queue.
- [ ] `coordinator-pr-check.mjs` names open step PRs that touch the same files.
