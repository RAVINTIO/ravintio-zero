---
title: "ADR 003: The non-array warning drops the old value"
summary: "Both setup scripts warn on a non-array hooks.PreToolUse or hooks.UserPromptSubmit with the event and file only. The warning no longer prints the old value, and setup keeps no backup."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000041-setup-cleanup-and-park-hardening"
---
# ADR-0144 - The non-array warning drops the old value

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Component:** planifest-zero
**Date:** 2026-10-22

## Context

ADR-0129 made both setup scripts warn on a non-array `hooks.PreToolUse` or `hooks.UserPromptSubmit`. Decision item 4 had the warning print the old value as compact JSON, so the human could recover it.

A hook command can embed a token or a secret. The printed value then reaches the terminal and any captured log, such as a CI log. Backlog 0000130 records this. Three reviews raised it first: 0000038 F-006, 0000039 F-001, and 0000040 F-009.

0000033 req-004 says setup never prints settings content. The old warning broke that rule.

## Decision

1. In both setup scripts, the warning for a non-array `hooks.PreToolUse` or `hooks.UserPromptSubmit` is exactly this line, with two leading spaces:
   `  ! Warning: hooks.{event} in {file} is not an array. Setup replaced it with the Planifest entries.`
2. The warning no longer prints the old value in any form. It drops `Old value:`, the `JSON.stringify` call in `setup.sh`, and the `ConvertTo-Json` call in `setup.ps1`.
3. Setup keeps no backup of the old value.
4. This supersedes decision item 4 of ADR-0129 only. The rest of that ADR stands. Setup still warns, replaces the value with the Planifest entries, and exits 0. An absent or null value still gets no warning.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep printing the old value | The human can recover a hand-written value from the warning. No change to either script | A secret in a hook command reaches the terminal and any captured log. It breaks 0000033 req-004 | Leaks secrets |
| Write the old value to a `0600` backup file and print its path | The human can recover the value. The secret stays off the terminal | Needs file creation, permission handling, and cleanup in both scripts. Both scripts need matching behaviour on Windows and POSIX | Rejected for now. It is out of scope for 0000041 and needs parity work in both scripts |
| Print a redacted value | The human sees the shape of the value | No reliable rule finds a secret inside an arbitrary hook command. A missed secret still leaks | No reliable redaction rule exists |
| Drop the value and keep no backup (chosen) | No setup output carries settings content. Both scripts print one fixed line that a parity test can compare | A hand-written non-array value is lost | Chosen |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` print the new warning line. Four existing tests change to assert the new line or the absence of the value. A parity test asserts the exact line in both scripts |

## Consequences

**Positive:**
- No setup output carries a hook value, so a secret in a hook command never reaches the terminal or a log.
- Setup follows 0000033 req-004 on this path.
- Both scripts print one fixed line, so the parity suite can compare them byte for byte.

**Negative:**
- The human can no longer recover a hand-written non-array value from the warning. The value is lost unless they have their own copy, such as git history.

**Risks:**
- The two scripts' warning text can drift apart. The parity test asserts the exact line in both to catch this.
- A human who relied on the printed value to recover a mistake loses that route. The warning still names the event and the file, so they know where to look in git history.

## Related ADRs

- ADR-0129 - extends (supersedes decision item 4 only, the rest stands)
- 0000033 req-004 - depends-on (setup never prints settings content)
- ADR-0138 - related-to (the shape check line is unchanged)

## Supersedes

- ADR-0129 - decision item 4 only (printing the old value as compact JSON)

## Superseded By

- None
