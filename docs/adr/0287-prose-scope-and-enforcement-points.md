---
title: "ADR 0287: Prose scope and enforcement points"
summary: "The linter reads a fixed set of Markdown paths and runs in commit-msg, pre-commit, and CI."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0287 - Prose scope and enforcement points

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Component:** ravintio-zero
**File:** `docs/adr/0287-prose-scope-and-enforcement-points.md`
**Date:** 2026-11-09T15:01:20Z

## Context

Backlog entry 0000301 asks for the linter on `docs/`, `plan/`, and the pack, and on commit messages. Archived records are immutable, so a check on them adds only baseline size.

## Decision

The scope is Markdown under `docs/`, `ravintio-zero/`, `ravintio-overrides/`, `plan/`, `src/`, and the repo root. Three paths are out of scope: `plan/_archive/`, `ravintio-zero/tests/`, and generated boot files (`CLAUDE.md` and `AGENTS.md`). The `commit-msg` hook checks the message. The pre-commit hook checks staged files and runs `diff` against `HEAD`. CI checks every file and runs `diff` against the base branch. The pre-commit hook gains a blocking exit for prose only and keeps its advisory text for the other checks.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Check only in CI | No local friction | The agent learns of a breach after the push | The entry asks for commit-time checks |
| Include `plan/_archive/` | Full coverage | Large baseline for text nobody edits | No gain |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Edits `commit-msg`, `pre-commit`, `ravintio.yml`, and the repo workflow |

## Consequences

**Positive:**
- A breach stops at the commit, with the file and line.

**Negative:**
- The pre-commit hook is no longer advisory only.

**Risks:**
- A false positive blocks a commit. A developer uses `--no-verify`, and CI still checks the result.

## Related ADRs

- ADR-0285 - depends-on
- ADR-0286 - depends-on

## Supersedes

- None.

## Superseded By

- None.
