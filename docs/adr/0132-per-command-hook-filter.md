---
title: "ADR 002: Setup filters hook entries one command at a time"
summary: "Both setup scripts remove only the Planifest commands from PreToolUse and UserPromptSubmit entries. They keep user commands, and setup.sh adopts the path-boundary match."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000038-setup-hook-filter-fixes"
---
# ADR-0132 - Setup filters hook entries one command at a time

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000038-setup-hook-filter-fixes
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

Rerunning setup drops a whole `PreToolUse` or `UserPromptSubmit` entry when any one of its commands is a Planifest command. If a user put their own command in the same entry, setup deletes it (backlog 0000112, security finding S-001 from 0000037).

The two scripts also disagree on `UserPromptSubmit`. `setup.sh` matches a bare substring, so it can remove a user command such as `./tools/check-design-notes.sh`. `setup.ps1` uses the case-sensitive path-boundary regex from 0000035 S-004 (backlog 0000111).

The telemetry cleanup in `planifest-zero/setup.sh` already filters per command. It is the working precedent.

## Decision

Both scripts filter `PreToolUse` and `UserPromptSubmit` one command at a time. The rule is the same for both events:

1. For each entry, remove each command that runs a Planifest module of that event at a path boundary.
2. If the entry had commands and none remain, drop the entry.
3. Otherwise keep the entry with its remaining commands, in their order.
4. Append the fresh Planifest entries, as today.

`setup.sh` replaces its `UserPromptSubmit` substring test with the case-sensitive path-boundary regex that `setup.ps1` already uses. Both scripts then match the same commands. This refines the 0000037 any-matcher decision, which decided how setup repairs entries it owns. It does not supersede that ADR.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the whole-entry drop and print a warning when it removes a user command | Smallest change. No risk to the array handling | The user still loses their command. A warning arrives after the loss | Does not fix 0000112 |
| Narrow the match to the hooks folder | Stops setup removing a user script with a Planifest basename elsewhere | Old setups wrote several folder shapes, so setup would miss stale Planifest commands | Deferred. Recorded in `design.md` under Deferred |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` change their hook merge. Their test suites gain planted-entry cases |

## Consequences

**Positive:**
- A user command that shares an entry with a Planifest command survives a rerun.
- Both scripts remove the same entries, so the platform no longer changes the result.
- `setup.sh` no longer removes a user command that only contains a module name as a substring.

**Negative:**
- An entry may now keep a stale user command that setup used to remove. The user removes it by hand.
- Per-command code is longer than the whole-entry filter in both scripts.

**Risks:**
- Windows PowerShell 5.1 unwraps a one-item array when it rebuilds `entry.hooks` (R-001). Build the array with `@()` and test on 5.1 in CI.
- A rerun could add a Planifest entry twice (R-002). A run-twice case in both suites covers this.

## Related ADRs

- The 0000037 any-matcher decision (`plan/_archive/0000037-self-host-on-planifest-zero-2026-10-17/adr/`) - extends. This ADR refines its repair rule and does not replace it.
- ADR-0119 - depends-on (settings writes stay atomic)
- ADR-0131 - related-to (the stack stays the same)

## Supersedes

- None

## Superseded By

- None
