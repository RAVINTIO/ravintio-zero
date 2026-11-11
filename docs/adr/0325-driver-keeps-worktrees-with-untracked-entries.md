---
title: "ADR 0325: Driver keeps worktrees with untracked entries"
summary: "Before the driver removes a step worktree, it lists untracked files under plan/backlog/. If any exist, or git cannot list them, it keeps the worktree and stops the queue for that step."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0325 - Driver keeps worktrees with untracked entries

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Component:** ravintio-zero
**File:** `docs/adr/0325-driver-keeps-worktrees-with-untracked-entries.md`
**Date:** 2026-11-11

## Context

The queue removes a step worktree with `git worktree remove --force`. That command deletes untracked files. On 2026-11-10 step 40 filed backlog entry 0000480 in its worktree and did not commit it. The coordinator saved a copy by hand.

A step may file an entry and forget to stage it. The driver can see that case before it deletes anything.

## Decision

`removeWorktree()` in `initiative-run.mjs` runs `git ls-files --others --exclude-standard -- plan/backlog` in the worktree before it removes the worktree.

1. If the command lists one or more files, the driver keeps the worktree and stops the queue for that step. The stop line names up to five files and the count of the rest.
2. If the command fails, the driver keeps the worktree and stops the queue. The stop line carries the last line of the git error.
3. If the command lists nothing, the driver removes the worktree as before.

The ship skill adds a matching rule. A step lists untracked files under `plan/backlog/` and stages each one it filed by explicit path before the PR.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Move the entries to the main tree's queue | The queue keeps merging | The driver would write queue items and invent a destination for each entry | A refusal is smaller and loses nothing |
| Drop `--force` from the removal | No new code | Git then refuses for any untracked or modified file, including files that hold no entry | It stops the queue on files that need no care |
| Rely on the ship rule alone | One place to change | A step that skips the rule still loses the entry | The driver check covers a step that forgets |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` changes in `removeWorktree()`. The ship skill and `roadmap-standards.md` change. |

## Consequences

**Positive:**
- A filed entry survives a step that forgets to commit it.
- The stop line tells the coordinator which files to commit.

**Negative:**
- A forgotten entry stops the merge of an otherwise ready step until the coordinator commits it.

**Risks:**
- Git lists ignored files differently on another platform. The test pins the listing on the CI platforms.

## Related ADRs

- ADR-0323 - related-to: the driver also hands over steps after a Restart.

## Supersedes

None.

## Superseded By

None.
