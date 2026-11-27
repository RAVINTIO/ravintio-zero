---
title: "ADR 0353: Delivery archives driver state in the git folder"
summary: "I-E Delivery moves the driver logs and control files to .git/ravintio-archive/ and removes the step worktrees."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000581-delivery-cleans-up-driver-state"
---
# ADR-0354 - Delivery archives driver state in the git folder

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Component:** ravintio-zero
**File:** `docs/adr/0354-delivery-archives-driver-state-in-the-git-folder.md`
**Date:** 2026-11-26T10:05:04Z

## Context

I-E Delivery leaves `plan/.initiative-control/` and `plan/.initiative-logs/` in place. The next initiative reuses step numbers. Its driver reads a stale `running` file as a step to resume, and the status script counts old steps. On 2026-11-14 the coordinator moved both folders by hand.

The logs still serve as stop evidence after delivery, so deleting them loses data. Ignored folders under `plan/` reach no commit, so a move into the git folder keeps them out of history.

## Decision

A new script, `initiative-cleanup.mjs`, runs after the human merges the initiative PR.

- It refuses while `plan/.initiative-runner.lock` exists.
- It moves both folders to `.git/ravintio-archive/{id}-{slug}/`. A numeric suffix keeps an existing target.
- It removes each worktree under `plan/.initiative-worktrees/` and prunes.
- It leaves `plan/.initiative-queue/` in place and names each item.
- It removes no path outside the repo and refuses a symlink.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Delete both folders | No archive to manage | The logs no longer serve as stop evidence | The entry asks for readable logs |
| Move them to `plan/_archive/` | Visible in the tree | The folders are ignored and a commit would carry logs | Logs do not belong in history |
| Clean at the next driver start | No new script | The driver cannot tell a stale folder from a resume | A resume needs those files |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, new I-E Delivery step, new test suite |

## Consequences

**Positive:**
- A new chart starts at `merged 0, ready 0, running 0`.
- The coordinator no longer moves folders by hand.

**Negative:**
- The coordinator has one more delivery step to run.
- The archive grows in `.git/` until someone removes it.

**Risks:**
- A coordinator who runs the script early removes live worktrees. The lock check and the delivery order limit this.

## Related ADRs

- ADR-0326 - extends: a failed removal prints `Kept:` and never stops the run.
- ADR-0352 - related-to: no pack script deletes by name in a shared folder.

## Supersedes

- None.

## Superseded By

- None.
