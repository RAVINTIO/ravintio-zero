---
title: "ADR 001: Replay with git merge-tree, not a working tree"
summary: "The script replays commits with git merge-tree and commit-tree so it never touches a working tree."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Replay with git merge-tree, not a working tree

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Component:** ravintio-zero
**Date:** 2026-11-06

## Context

The reshape replays each step diff onto a new tip. A cherry-pick needs a working tree and an index, so a failed run could leave the caller's tree dirty. The coordinator runs the script in the repo it also uses for delivery.

## Decision

The script uses `git merge-tree --write-tree --merge-base={commit}^ {tip} {commit}` for each replay and `git commit-tree` to write each commit. A conflict exits the merge with status 1, and the script exits 1 and names the commit. The script writes only objects and, at the end, one new branch ref. The caller's working tree and index stay as they were.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Cherry-pick in a temporary clone | Familiar commands | Copies the repo and leaves a clone to clean up | More moving parts |
| Cherry-pick in the working tree | No new plumbing | Dirties the caller's tree on a conflict | Breaks the clean-tree rule |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | A new script. |

## Consequences

**Positive:**
- No working tree writes, so a failed run leaves nothing to clean.
- A conflict is a clean exit code.

**Negative:**
- Needs git 2.38 or later for `merge-tree --write-tree`.

**Risks:**
- See R-001 to R-005 in the risk register.

## Related ADRs

- ADR-002 - related

## Supersedes

- None.

## Superseded By

- None.
