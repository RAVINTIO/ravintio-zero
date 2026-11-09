---
title: "ADR 002: Invalid JSON exits 1 with a fixed message"
summary: "The hook install step in both setup scripts catches invalid JSON, prints one fixed message that names the file, leaves the file unchanged, and exits 1."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000039-setup-hardening-release-sizing"
---
# ADR-0134 - Invalid JSON exits 1 with a fixed message

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Component:** planifest-zero
**Date:** 2026-10-19

## Context

When `settings.json` holds invalid JSON, the hook install step in setup can print the parse error. That error can include part of the file content. Setup must never log `settings.json` contents (0000033 req-004). The 0000038 security review found this path (backlog 0000113).

Setup cannot install enforcement hooks into a file it cannot read. If it continued, the user would think the hooks were in place when they were not.

The telemetry cleanup already warns and continues on a bad file. Its failure leaves no enforcement gap.

## Decision

In both scripts, the hook install step catches the parse error. It prints one fixed line that names the file only:

`! Error: {path} is not valid JSON. Fix it and rerun setup.`

The step leaves the file unchanged and exits 1. The line never includes the parse error text or any file content. The telemetry cleanup keeps its warn-and-continue behaviour.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Warn and continue, as the telemetry cleanup does | Setup finishes the other steps | The user believes enforcement hooks are installed when they are not | Hides a failed install |
| Overwrite the file with fresh settings | Setup always finishes | Destroys the user's settings | Loses user data |
| Print the parse error to help the user find the fault | Faster fix | Leaks file content to logs | Breaks 0000033 req-004 |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` change the hook install step. Both suites gain invalid-JSON and planted-value cases |

## Consequences

**Positive:**
- No byte of `settings.json` reaches stdout or stderr on this path.
- The user gets one clear error and a file they can still open and fix.
- Both scripts give the same result on the same input.

**Negative:**
- The user gets no hint about where the JSON fault is. They find it with their own editor or a linter.
- Setup stops before later steps run, so the user reruns the whole script after the fix.

**Risks:**
- A new error path prints file content (R-002). Planted-value cases check stdout and stderr in both suites.
- The write must stay atomic (ADR-0119). The error path writes nothing.

## Related ADRs

- 0000033 req-004 - depends-on (setup never logs `settings.json` contents)
- ADR-0119 - depends-on (settings writes stay atomic)
- ADR-0133 - related-to (the stack is unchanged)

## Supersedes

- None

## Superseded By

- None
