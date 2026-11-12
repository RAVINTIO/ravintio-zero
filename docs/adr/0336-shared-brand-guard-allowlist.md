---
title: "ADR 001: One brand guard allowlist file"
summary: "The CI test and pre-push read one allowlist file, and the guard runs only in the pack source."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000394-github-security-and-ci-lint"
---
# ADR-0336 - One brand guard allowlist file

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

The brand guard allowlist sits inside `test-0000160-req-006-brand-guard.sh`. A hook cannot read a Bash array in a test, so the two checks would drift.

## Decision

The allowlist moves to `ravintio-zero/tests/brand-guard-allowlist.txt`. Blank lines and lines that start with `#` are ignored. A line that starts with `!` names an excluded path prefix. Any other line holds a path regex, a tab, and a line regex. `ravintio-zero/scripts/brand-guard.sh` and the test both read it. `pre-push` runs the script only when `product.yml` declares the id `ravintio-zero`, because a consumer repo has no reason to ban the old name.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `pre-push` runs the whole test | No new script | Slow, and it scans every tracked file | A push should check changed files only |
| Copy the allowlist into the hook | No new file | Two lists drift | The entry asks for one list |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One data file, one script, and edits to `pre-push` and one test |

## Consequences

**Positive:**
- Local and CI checks cannot disagree.

**Negative:**
- The test loses its inline comments next to each entry unless the file keeps them.

**Risks:**
- A malformed entry breaks both checks. The test keeps its stale-entry check.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
