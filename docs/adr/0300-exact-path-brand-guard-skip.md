---
title: "ADR 300: Exact-path skip for the brand guard allowlist files"
summary: "The brand guard skips its two allowlist files by exact path in code, so the allowlist holds no row that widens the guard."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000460-narrow-brand-guard-self-entry"
---
# ADR-0300 - Exact-path skip for the brand guard allowlist files

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000460-narrow-brand-guard-self-entry
**Component:** ravintio-zero
**File:** `docs/adr/0300-exact-path-brand-guard-skip.md`
**Date:** 2026-11-10

## Context

The allowlist file names the retired word in its own header and rows. A self-entry row let every line of that file pass. The row widened a fail-closed guard, and no decision approved it. The human asked on 2026-11-08 for an exact-path skip in code in its place.

## Decision

`brand-guard.sh` defines `brand_guard_skips_path`. It returns 0 for `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt`, compared as whole strings. The script and the CI test both call it. The allowlist holds no row for these files. The human chose on 2026-11-10 that the skip covers both copies.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the self-entry row | No code change | The row passes any line of the file, and the guard cannot tell a pattern from a skip | The human did not approve the widening |
| Skip any file with the allowlist base name | Covers copies | A look-alike such as `brand-guard-allowlist.txt.bak` or a copy in another folder would pass | It widens the guard |
| Skip only the `src/` copy | Narrowest | The installed copy then fails | The human chose both copies |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One function in `brand-guard.sh`, one removed allowlist row, and test edits |

## Consequences

**Positive:**
- No allowlist pattern can skip a file.
- The hook and CI apply one rule.

**Negative:**
- A move or rename of the allowlist file needs an edit to the function.

**Risks:**
- The function and the file drift apart. A test names both paths and checks them.

## Related ADRs

- ADR-0281 - extends. The allowlist stays one file read by the hook and CI.

## Supersedes

- None

## Superseded By

- None
