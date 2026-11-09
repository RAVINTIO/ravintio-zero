---
title: "ADR 003: setup.ps1 flags are case-sensitive"
summary: "The setup.ps1 flag switch matches case, as setup.sh does, and leftover temporary files go at the start of each run."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000035-powershell-setup-parity"
---
# ADR-0123 - setup.ps1 flags are case-sensitive

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

PowerShell `switch` ignores case by default, so `setup.ps1` accepts `--Strict-Orchestrator`. `setup.sh` rejects it. The retired-flag check in `setup.ps1` already matches case (ADR-0118). Separately, a hard stop can leave `.claude/settings.json.planifest-tmp` behind (backlog 0000104).

## Decision

1. The argument loop uses `switch -CaseSensitive`. A flag in the wrong case reaches the unknown-flag branch and exits 1.
2. Both scripts remove `.claude/settings.json.planifest-tmp` early in each run, before any settings write. The removal deletes a file or a link, never a folder, and never follows a link. `setup.sh` does it with `rm -f`, so it needs no `node`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Make `setup.sh` ignore case instead | No break for Windows users | Bash `case` would need every flag spelled twice | Case-sensitive is the documented contract |
| Add the temporary file to the shipped `.gitignore` | Stops a commit of it | The shipped `.gitignore` already ignores `.claude/`, and setup never overwrites a project's own | It doesn't reach the projects at risk |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.ps1` argument loop, start of both scripts' runs |

## Consequences

**Positive:**
- Both scripts accept and reject the same flags.
- A leftover lasts only until the next run.

**Negative:**
- A Windows user who typed a flag in another case now gets `Unknown flag`.

**Risks:**
- R-003 and R-005.

## Related ADRs

- ADR-0118 - related-to (retired flags already match case)
- ADR-0119 - related-to (it names the temporary file)

## Supersedes

- None

## Superseded By

- None
