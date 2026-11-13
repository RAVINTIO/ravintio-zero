---
title: "ADR 001: Track commits by ancestry and stale by key"
summary: "The watcher decides new commits with git ancestry and prints each stale state once."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000241-watcher-false-events"
---
# ADR-0224 - Track commits by ancestry and stale by key

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

The watcher read the last 100 commits and treated an unknown last-seen commit as all new. It flagged a stale log on any newer commit and repeated the line every pass. The stack is Node ESM with no dependencies, per the design.

## Decision

The watcher runs `git merge-base --is-ancestor {last-seen} HEAD`. If true, it lists `git log {last-seen}..HEAD`. If false, it prints one branch-change line. A stale line needs the commit to be `STALE_MS` newer than the log. A stale key of log time and commit sha limits it to one line per state.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Compare commit counts | No new git call | Wrong after a rebase or switch | Misreports the cases in the entry |
| Persist state in a file | Survives a restart | The watcher must write no file | Breaks the read-only rule |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Watcher script, tests, standards text |

## Consequences

**Positive:**
- A branch switch gives one line.
- A stale state gives one line.

**Negative:**
- One more git call per pass.
- A restarted watcher forgets its stale key and may print a stale line again.

**Risks:**
- See R-001 and R-002.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
