---
title: "Feature Brief - plan rereads files at the branch point"
summary: "The plan skill rereads each file a unit edits at the branch point and records the commit it read."
status: "approved"
version: "0.1.0"
---
# Feature Brief - plan rereads files at the branch point

**Feature ID:** 0000470-plan-rereads-files-at-the-branch-point

Source: backlog entry 0000435, from the initiative 0000360 retrospective (evidence row 21).

## Business Goal

Parallel steps change shared scripts within minutes. A plan that reads a file early reads stale text. In step 16, a queue test fake matched the script from before another step merged. The first run sat in the CI wait. The plan skill now rereads each file a unit edits at the branch point and records the commit it read.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Branch-point reread | As a step session, I reread each file my plan edits at the branch point and note the commit, so that the plan never rests on stale text. | must-have | 1 |

## Wanted outcome

- The plan skill holds a step that rereads every file a unit edits against the tip of the branch the PR targets.
- The execution plan records each file with the commit it read.
- The step runs again if the target branch moves before the plan gate.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the plan skill and the execution plan template |

### Data Ownership

No data store.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown skill text and Bash tests already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A "Branch-point reread" section in the plan skill.
- A `## Branch-point reads` section in the execution plan template.
- A test, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- A script that automates the reread.
- A hook that blocks a plan with a stale read.
- P2 rereads before each edit.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill size | The plan skill stays within the skill-text line total of 1720 | `test-0000384-skill-text.sh` |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The change widens no guard.

### Assumptions
- The target branch is `origin/` plus the PR base. Impact if wrong: the reread reads a branch the PR does not target.

## Scenario Paths

**Happy path:** the plan lists the files a unit edits, rereads each at the target tip, and records the commit.

**Alternative path:** a unit creates a new file. The row records `new` in place of a commit.

**Error / sad path:** the target branch moves before the plan gate. The plan repeats the reread and updates the commits.

**Cross-session continuity:** not applicable.

## Acceptance Criteria

- [ ] The plan skill names the reread step and the commit note.
- [ ] The execution plan template holds a section for the reads.
- [ ] The step covers a moved target branch.
