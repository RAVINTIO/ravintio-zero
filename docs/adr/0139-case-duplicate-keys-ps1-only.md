---
title: "ADR 003: Only setup.ps1 rejects case-duplicate keys"
summary: "setup.ps1 rejects case-duplicate keys with the shared line because ConvertFrom-Json cannot read them. setup.sh accepts them because node reads them. The difference is deliberate."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000040-setup-json-checks-and-park"
---
# ADR-0139 - Only setup.ps1 rejects case-duplicate keys

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Component:** planifest-zero
**Date:** 2026-10-21

## Context

A JSON object can hold keys that differ only in case, such as `hooks` and `Hooks`. `ConvertFrom-Json` in PowerShell 5.1 and 7 throws on such an object. Node's `JSON.parse` reads it and keeps both keys. The PowerShell error would otherwise surface as the wrong message (backlog 0000120).

## Decision

`setup.ps1` rejects a file with case-duplicate keys. It prints the shared line from ADR-0138 and exits 1 with the file unchanged. `setup.sh` accepts such a file, because node reads it. The two scripts differ on this input on purpose. The design lists `setup.sh` rejection as out of scope.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add a strict parity scan to `setup.sh` | Both scripts reject the same files | A new scanner to build and test for a file node reads without error | The human chose against it at P1 |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.ps1` gains a case-duplicate check. `setup.sh` is unchanged. A test records the difference |

## Consequences

**Positive:**
- `setup.ps1` names the real fault instead of a parser error.
- `setup.sh` gains no new code and rejects no file that node reads.

**Negative:**
- The same file installs on one platform and fails on the other.
- A reader of the scripts must learn this difference from this ADR.

**Risks:**
- PowerShell 7 or 5.1 might accept case-duplicate keys. The 0000120 test then needs a version guard.

## Related ADRs

- ADR-0138 - extends (it uses the same shared line)
- ADR-0134 - related-to (invalid JSON keeps its message)

## Supersedes

- None

## Superseded By

- None
