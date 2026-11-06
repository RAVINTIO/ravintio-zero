---
title: "ADR 002: A guard command exits 2 when the launcher fails"
summary: "Setup appends || exit 2 to each guard-mode hook command, so a missing launcher blocks the call."
status: "accepted"
version: "0.1.0"
---
# ADR-002 - A guard command exits 2 when the launcher fails

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Date:** 2026-11-06

## Context

Every guard runs through `guard-run.mjs`. If that file is missing, `node` exits 1. Claude Code treats exit 1 as a non-blocking error, so the call goes through and every guard fails open at once. `guard-run.mjs` already maps its own failures to exit 2, so only a missing launcher or a missing `node` reaches exit 1 or 127.

## Decision

Append ` || exit 2` to each guard-mode command in `setup.sh`, in `setup.ps1`, and in both Codex commands. Exit 0 passes. Exit 2 from the launcher stays 2. Any other status becomes 2. Advisory commands keep their form, because exit 2 on a Stop or UserPromptSubmit hook blocks the session. The prefix of the command stays the same, so the filters that match `guard-run.mjs` still work.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `test -f` before `node` | Prints a clear message | Longer command that the hook filters and tests must match | The suffix is shorter and covers a missing `node` too |
| Wrap advisory hooks too | One rule | Exit 2 on Stop blocks the session | Out of scope, and unsafe |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `setup.sh`, `setup.ps1`, and the tests that pin the command text |

## Consequences

**Positive:**
- A missing launcher blocks the call.

**Negative:**
- A damaged install blocks every guarded call until the human reruns setup.
- The hook command needs a POSIX shell. Claude Code on Windows uses Git Bash, which has one.

**Risks:**
- A test pins the old command text. The suite run finds it.

## Related ADRs

- ADR-001 - related-to
- 0000316 ADR-001 - extends

## Supersedes

None.

## Superseded By

None.
