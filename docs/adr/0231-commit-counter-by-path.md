---
title: "ADR 001: reserve-id commits the counter by path"
summary: "reserve-id.mjs --commit runs git commit with the counter path after a double dash, so the commit holds that file alone."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000247-git-state-hygiene"
---
# ADR-0231 - reserve-id commits the counter by path

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

Entry 0000224 records an id reservation left uncommitted. A session on another branch reused the id. The lock in `reserve-id.mjs` covers one working tree only.

## Decision

Add a `--commit` flag. After the script writes the counter, it runs `git add -- {counter}` and `git commit -m {message} -- {counter}`. The path after the double dash limits the commit to that file, whatever else is staged. The skills that reserve ids pass the flag.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Skills run `git commit` after the script | No script change | Each skill repeats the commit and can stage more than the counter | The rule drifts across skills |
| Commit inside the lock | The counter and the commit stay atomic | A slow commit holds the lock | The lock covers the file write, and the commit follows it |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script, three skills, one test |

## Consequences

**Positive:**
- Every reservation sits in a commit that other branches see after a merge.

**Negative:**
- The flag adds a git dependency to a script that had none.

**Risks:**
- A commit hook rejects the message. The message follows `commit-standards.md`.

## Related ADRs

- none

## Supersedes

- none

## Superseded By

- none
