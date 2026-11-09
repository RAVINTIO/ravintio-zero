---
title: "ADR 002: Retired flags fail setup"
summary: "A retired flag exits 1 during argument parsing instead of printing a warning, which reverses ADR-0118."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000196-setup-argument-checks"
---
# ADR-0200 - Retired flags fail setup

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

Feature ADR-0118 chose a warning for retired flags, so that an old refresh command still ran. Users kept the flag and never learned it does nothing. Unknown flags already fail during parsing. A tool check that runs late also leaves repo changes behind on a rejected run.

## Decision

A retired flag exits 1 during argument parsing, before any other processing. The error names the flag only, says it was removed and does nothing, and tells the user to remove it. The tool check runs straight after parsing. The refresh skill reports a retired flag from a record or marker and omits it from its proposed command.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the warning | Old commands still run | The flag lingers and the user never learns | It is the behaviour that backlog entry 0000194 reverses |
| Fail after the install steps | No parser change | A rejected run leaves hooks and files behind | Violates the unchanged-repo outcome |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two setup scripts, the refresh skill, six tests, the manifest, and the docs |

## Consequences

**Positive:**
- A rejected run leaves the repo untouched.
- Users learn which flags to remove.

**Negative:**
- An old refresh command with a retired flag now fails until the user edits it.

**Risks:**
- A CI job that passes a retired flag breaks. The error text says what to remove.

## Related ADRs

- ADR-0199 - related-to
- ADR-0118 - conflicts-with

## Supersedes

- ADR-0118 (warn on retired flags)

## Superseded By

None.
