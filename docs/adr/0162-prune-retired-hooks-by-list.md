---
title: "ADR 007: Setup prunes retired hooks by list"
summary: "Setup deletes only hooks named on a retired-names list, which gains phase-enum, and never deletes a hook absent from that list."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0162 - Setup prunes retired hooks by list

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

When the pack retires a hook, installed projects keep the old file and its wiring in `.claude/settings.json`. The stale hook can block or confuse later sessions. `phase-enum` is the next hook to retire.

Projects also hold hooks that users added. Setup must not delete those.

## Decision

Setup, in `setup.sh` and `setup.ps1`, deletes an installed hook and its wiring only if the name appears on a retired-names list.

- The list lives in one place per script and starts with `phase-enum`.
- A hook that is absent from the list is never deleted.
- Retiring a future hook means adding its name to the list.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Prune from a manifest of installed hooks | Handles any retirement with no list edit | Needs a manifest file that setup writes and keeps current | Rejected for now. The list is smaller and safer |
| Delete every hook not shipped in the pack | No list to maintain | Deletes user-added hooks | This breaks user trust |
| Tell users to delete the file | No code | Users forget, and stale hooks persist | Leaves the defect in place |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` gain the same prune step, and tests cover both |

## Consequences

**Positive:**
- Retired hooks leave installed projects on the next setup.
- User-added hooks stay safe.

**Negative:**
- A maintainer must edit the list each time a hook retires.
- The two setup scripts must hold the same list.

**Risks:**
- A name on the list that matches a user hook would delete it. Hook names are specific, and a test pins the list.
- A manifest may serve better later. This decision does not block that.

## Related ADRs

- ADR-0157 - related-to (both change hook handling)

## Supersedes

- None

## Superseded By

- None
