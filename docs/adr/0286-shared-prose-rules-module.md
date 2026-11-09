---
title: "ADR 0286: Shared prose rules module"
summary: "One module in hooks/enforcement/ holds the prose rules. The linter script and the Stop hook both import it."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0286 - Shared prose rules module

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Component:** ravintio-zero
**File:** `docs/adr/0286-shared-prose-rules-module.md`
**Date:** 2026-11-09T15:01:20Z

## Context

The linter script and the Stop hook need the same rules. Hooks install as single files beside `read-stdin.mjs`, so a hook cannot import from `scripts/`. Two copies of the rules would drift.

## Decision

Put the rules in `hooks/enforcement/prose-rules.mjs`. The module has no dependencies and no side effects. `scripts/prose-check.mjs` imports it from `../hooks/enforcement/`. `check-reply-writing.mjs` imports it from its own folder. Setup copies the module with `read-stdin.mjs` and `guard-run.mjs`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Copy the rules into the hook and the script | No install change | Two copies drift | A parity test would carry the cost forever |
| Hook imports from `scripts/` | One copy | Consumer installs place the hook elsewhere | The import path breaks after install |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains one shared module and one entry in each install list |

## Consequences

**Positive:**
- The script and the hook always agree on what a breach is.

**Negative:**
- Setup must copy one more file, in both setup scripts.

**Risks:**
- A missing copy makes the hook exit 0 silently. A test checks the install lists.

## Related ADRs

- ADR-0287 - related-to
- ADR-0288 - related-to

## Supersedes

- None.

## Superseded By

- None.
