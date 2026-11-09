---
title: "ADR 001: Retired setup flags warn and continue"
summary: "Setup accepts four retired flags, prints one warning for each, skips it, and continues. Any other unknown flag still exits 1. This supersedes the no-op rejection in ADR-0107."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000034-setup-hardening"
---
# ADR-0118 - Retired setup flags warn and continue

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Component:** planifest-zero
**Date:** 2026-10-16

## Context

Two releases removed setup flags. Feature 0000030 removed `--context-mode-mcp` and `--include-full-skill-library`. Feature 0000033 removed `--structured-telemetry-mcp` and `--backend-url`. Both setup scripts now reject all four with `Unknown flag` and exit 1.

The flags marker of an older install still lists those flags. `planifest-refresh-setup` replays the marker into setup, so a refresh of any older install fails (backlog 0000092). The person can't fix it without editing the marker by hand.

ADR-0107 considered keeping removed flags as no-ops and rejected it. Its reason was that "a flag that silently installs nothing is exactly the defect context-mode became". That reasoning is about silence. It didn't weigh the refresh failure, because the refresh skill then replayed only current flags.

The human chose on 2026-10-16 to fix 0000092 in setup, not in the refresh skill.

## Decision

1. Setup recognises exactly four retired flags: `--structured-telemetry-mcp`, `--backend-url`, `--context-mode-mcp`, and `--include-full-skill-library`.
2. For each one, setup prints one warning that names the flag and says setup ignores it. Setup then continues.
3. After `--backend-url`, setup also skips the next argument, unless it starts with `--`. Setup never runs, prints, or writes that value. With no value, setup warns and continues.
4. Any other argument starting with `-` still prints `Unknown flag` and exits 1.
5. The usage text doesn't list retired flags.
6. Both `setup.sh` and `setup.ps1` behave the same way.

This supersedes the "Keep the flags as no-ops" rejection in ADR-0107. The rest of that ADR stands.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Refresh skill drops retired flags before replay | Setup's flag contract stays strict | Only the refresh skill is fixed. A person or script replaying an old command still fails | The human chose the setup fix, which covers every caller |
| Silent no-ops | Old commands keep working | Repeats the defect ADR-0107 named: a flag that silently does nothing | A warning keeps the signal |
| Keep the `Unknown flag` error | No code change | Every refresh of an older install fails with no clear fix | The failure is the defect this feature exists to remove |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero (`setup.sh`) | Argument parsing gains a retired-flag branch and the `--backend-url` value rule |
| planifest-zero (`setup.ps1`) | The same branch and rule in its manual argument loop |
| planifest-zero (tests) | New suite for warnings, value skipping, and the unknown-flag error |

## Consequences

**Positive:**
- A refresh of any install from 0000030 onwards completes.
- One successful run rewrites the marker with current flags only, so later refreshes print no warning.

**Negative:**
- The retired list is code that setup carries for as long as old markers exist.
- A person who passes a retired flag on purpose gets a warning, not an error. A script that relied on the exit 1 now passes.

**Risks:**
- The value rule skips a real value that happens to start with `--`. No current flag takes a value, so this can't occur today.

## Related ADRs

- ADR-0119 - related-to (both make setup safe to re-run)
- ADR-0107 - supersedes in part (the no-op rejection only)
- ADR-0115 - depends-on (the removal of the telemetry flags)

## Supersedes

- ADR-0107, alternative "Keep the flags as no-ops" only

## Superseded By

- None
