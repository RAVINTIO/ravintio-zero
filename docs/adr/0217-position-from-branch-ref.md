---
title: "ADR-0217 - Read position from the initiative branch ref"
status: "accepted"
component: "ravintio-zero"
feature: "0000205-initiative-skill"
---
# ADR-0217 - Read position from the initiative branch ref

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

I-D Advance updates `initiative.md` on the step's feature branch, then raises the PR. The driver read `position` from the working tree, so it saw the new position before the merge. Roadmap 0000168 step 1 failed CI after the update, and the driver started step 2 on an unmerged step.

## Decision

After each step the driver reads `position` and `status` from `git show {initiative-branch}:plan/current-initiative/initiative.md`. A step that did not merge leaves the branch file unchanged, so the driver stops with a not-merged line. Outside a git work tree the driver reads the working tree. The driver also checks the newest archived build log for a `Blocked:` line, because ship archives `plan/current/` before CI.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Move the `position` update after the merge | Matches the word "advance" | The update would need a second commit on the initiative branch from a session with no PR | The squash must carry the update. |
| Call `gh pr view` for the merge state | Direct evidence | Needs the network and an auth token in the driver | The branch ref needs neither. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` and its tests |

## Consequences

**Positive:**
- The driver advances only on a merge that exists in git.

**Negative:**
- The driver needs the initiative branch to exist as a local ref.

**Risks:**
- A rebase that rewrites the branch changes the ref. The driver reads the ref fresh each time.

## Related ADRs

- ADR-0216

## Supersedes

None.

## Superseded By

None.
