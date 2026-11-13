---
title: "ADR 003: Ship clears sentinels before the PR"
summary: "Ship renumbers to Step 7 tag, Step 8 clear sentinels, Step 9 PR, Step 10 final gate. The tag is pushed with the branch when the agent raises the PR."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0158 - Ship clears sentinels before the PR

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

Ship leaves the `plan/.orchestrator-active` and related sentinel files in place when it pushes the branch. The files then reach `main` through the merged PR. Roadmap steps already clear them in a commit before the push, through the R-D Advance behaviour.

Custom instruction `custom-004` says to push the branch and the tag, then raise the PR. Step 10 needs the run mode, so the clear step must not erase that value before the gate reads it.

## Decision

Renumber the ship steps and clear the sentinels in a commit before the push.

1. **Step 7:** create the tag locally.
2. **Step 8:** read the run mode, then clear the sentinels in a commit.
3. **Step 9:** push the branch and the tag, then raise the PR (option [1]).
4. **Step 10:** the final gate, using the run mode read in Step 8.

The agent pushes the tag with the branch when it raises the PR. This overrides the earlier placement of the tag push in `custom-004`. Roadmap steps keep their R-D Advance behaviour and do not run the new Step 8 twice.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Push again after Step 9 | Keeps the old order | Adds a second push and leaves the sentinels in the PR diff until it lands | The PR still shows the sentinel files, and the extra push can fail on its own |
| Leave the sentinels and ask the human to delete them | No change to ship | Relies on memory, and the files reach `main` when the human forgets | This is the defect the requirement fixes |
| Add the sentinels to `.gitignore` | Git never tracks them | Edits the user's `.gitignore`, and hooks read the files from disk, so ignoring them hides state | The pack avoids touching user ignore files (see ADR-0160) |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `planifest-ship` gains new step numbers. Tests for 0000023, 0000042, and 0000043 update to the new order |

## Consequences

**Positive:**
- The merged PR carries no sentinel files.
- Ship and roadmap steps now clear the sentinels in the same way.

**Negative:**
- Several order tests must change, and they are a known source of churn.
- A reader must learn the new step numbers.

**Risks:**
- If Step 10 reads the run mode after the clear, it takes the wrong gate. The order of Step 8 guards this and a test pins it.
- A failed push after the tag exists leaves a local tag. The ship skill reports the exact error and stops.

## Related ADRs

- ADR-0152 - related-to (roadmap steps clear sentinels in R-D Advance)

## Supersedes

- None

## Superseded By

- None
