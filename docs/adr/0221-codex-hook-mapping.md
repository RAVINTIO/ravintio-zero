---
title: "ADR-0221 - Wire only hooks with a confirmed Codex contract"
status: "accepted"
component: "ravintio-zero"
feature: "0000207-codex-support"
---
# ADR-0221 - Wire only hooks with a confirmed Codex contract

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The Codex docs confirm the `hooks.json` shape, exit code 2 with a stderr reason, and `tool_input.command` for `Bash` and `apply_patch`. They don't state the `apply_patch` payload shape or the context format of prompt hooks. `gate-write` reads `tool_input.file_path`, which an `apply_patch` call may not hold.

## Decision

Wire `merge-guard` for `Bash`. State every other rule as an instruction in `AGENTS.md`, and list each as a fallback in the setup output.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Wire all hooks and hope the payloads match | Full enforcement on paper | A hook that never matches passes silently and gives false assurance | Hard Limit enforcement must not fail open unseen. |
| Wire no hook | No contract risk | Loses the one enforced merge rule | The `merge-guard` contract is confirmed. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Hook install and setup output for the Codex target |

## Consequences

**Positive:**
- Every wired hook has a confirmed contract. Users see what is enforced.

**Negative:**
- Codex enforces less than Claude Code until a later feature confirms more contracts.

**Risks:**
- The Codex contract changes. `AGENTS.md` repeats the rules.

## Related ADRs

- ADR-0220

## Supersedes

None.

## Superseded By

None.
