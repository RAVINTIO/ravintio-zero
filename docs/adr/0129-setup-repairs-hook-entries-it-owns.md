---
title: "ADR 003: Setup repairs the hook entries it owns"
summary: "setup.sh removes Planifest PreToolUse entries by module name on any matcher. Both scripts warn on a non-array PreToolUse or UserPromptSubmit value, print it, replace it with the Planifest entries, and exit 0."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000037-self-host-on-planifest-zero"
---
# ADR-0129 - Setup repairs the hook entries it owns

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

Both setup scripts merge six enforcement hooks into `.claude/settings.json`. Two gaps remain from 0000035 (backlog 0000106 and 0000107).

1. Before 0000035, `setup.ps1` wired `gate-write` as one `PreToolUse` entry with matcher `Write|Edit`. The `setup.sh` filter removes an entry only when its matcher is `Write` or `Edit`. The old entry survives a `setup.sh` run, so `gate-write` runs twice on each write. `setup.ps1` already removes entries by module name on any matcher.
2. Both scripts assume `hooks.PreToolUse` and `hooks.UserPromptSubmit` hold arrays. In `setup.sh`, `.filter` throws on an object or a string, and setup fails. In `setup.ps1`, `@(...)` wraps the value and keeps it as an entry. The two scripts disagree, and neither leaves working hooks.

ADR-0118 set the precedent that setup warns and continues on input it can't use. ADR-0121 requires the two scripts to write the same entries.

## Decision

1. The `setup.sh` `PreToolUse` filter identifies a Planifest entry by module name, on any matcher. It uses the `setup.ps1` rule: `gate-write.mjs`, `ratchet-check.mjs`, or `em-dash-guard.mjs` at a path boundary, case-sensitive. It removes each match and writes its own `Write` and `Edit` entries, so `gate-write` appears once per tool.
2. The `UserPromptSubmit` filter in `setup.sh` already ignores the matcher. It keeps that behaviour.
3. In both scripts, a `PreToolUse` or `UserPromptSubmit` value that is present, not null, and not an array is non-array. An object, a string, a number, and a boolean all count.
4. On a non-array value, the script prints a warning on stderr. The warning names the event and the settings file, and it prints the old value as compact JSON. The script then sets the event to the Planifest entries alone and continues.
5. Setup exits 0 after the warning. Other events and other top-level keys stay as they were.
6. An absent or null value keeps today's behaviour: setup writes the Planifest entries with no warning.
7. `setup.ps1` behaves the same on Windows PowerShell 5.1 and PowerShell 7. It reads the property directly with an `-is [array]` test, never through the pipeline, so 5.1 can't unwrap or wrap the value first (ADR-0122).

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Fail with exit 1 on a non-array value | Never discards a hand-written value. Forces the human to look | Setup stops with no hooks wired, and the human must edit JSON by hand. It breaks the warn-and-continue precedent of ADR-0118 | A broken install is worse than a replaced value the warning prints |
| Keep the value and skip the event | Discards nothing | The event gets no Planifest hooks, so `gate-write` or `check-design` doesn't run. Claude Code may still reject the invalid value | Leaves the install without its enforcement |
| Warn and replace (chosen) | Setup always ends with working hooks. Both scripts give the same result | A hand-written non-array value leaves `settings.json` | Chosen. The warning prints the old value, so the human can recover it |
| Keep the `setup.sh` matcher check and add `Write|Edit` to its list | Smallest change | Misses any other matcher a human or tool wrote. Differs from `setup.ps1` | The module-name rule already exists in `setup.ps1` and covers every matcher |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` change their enforcement hook merge. The hook parity suite gains a planted `Write\|Edit` case, and each script gains a non-array case |

## Consequences

**Positive:**
- After `setup.sh` runs on settings from an older `setup.ps1`, `gate-write` runs once per write.
- A hand-edited, non-array hook event no longer stops setup, and setup leaves working hooks.
- Both scripts follow one rule for both gaps, so the parity suite can compare their output.

**Negative:**
- Setup discards a hand-written non-array `PreToolUse` or `UserPromptSubmit` value from `settings.json`. Setup keeps no backup file. The value survives only in the stderr warning, so a human who misses the warning loses it.
- A non-Planifest hook whose command names one of the three modules at a path boundary now goes on any matcher, not only on `Write` or `Edit`.

**Risks:**
- Windows PowerShell 5.1 and PowerShell 7 can differ in how `ConvertFrom-Json` returns a one-element or empty array. A wrong test would warn on a valid array. The per-script suite runs on both hosts in CI to catch it.
- A very large non-array value makes a long warning. That is cosmetic.

## Related ADRs

- ADR-0121 - extends (`setup.sh` now matches `setup.ps1` in how it finds old entries)
- ADR-0122 - depends-on (the PowerShell 5.1 rules apply to the new type test)
- ADR-0118 - related-to (same warn-and-continue rule)
- ADR-0119 - related-to (the replaced settings still go through the atomic write)

## Supersedes

- None

## Superseded By

- ADR-0144 - supersedes decision item 4 only (printing the old value). The rest stands.
