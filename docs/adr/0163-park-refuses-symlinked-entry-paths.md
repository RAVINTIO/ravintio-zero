---
title: "ADR 008: Park refuses symlinked entry paths"
summary: "Park refuses any symlink in the entry path, checking each part with lstat and the result with realpath containment, before mkdir, write, and rm."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0163 - Park refuses symlinked entry paths

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

Park writes a backlog entry under `plan/backlog/` and removes it on cleanup. If a part of that path is a symlink, a write or a delete can land outside the repo. A symlinked `plan/backlog/` or entry folder could point at any directory the user can write to.

A check that refuses only an escape would still allow a symlink that stays inside the repo but redirects the write to an unexpected place.

## Decision

Park refuses any symlink in the entry path, not only one that escapes.

1. After the chore checkout, resolve the entry folder with `realpathSync`.
2. Call `lstat` on each part of the path. Refuse if any part is a symlink.
3. Refuse if the real path is outside the real `plan/backlog/`.
4. Run the checks before `mkdirSync`, before `writeFileSync`, and before the `rmSync` cleanup.

A refusal prints a fixed message and writes nothing.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Refuse only an escape | Allows harmless symlinks | A symlink inside the repo can still redirect a write or delete | A weaker guard leaves a gap in a security check |
| Check once before `mkdirSync` | One check | The path can change before the write or the delete | Each operation needs its own check |
| Rely on file permissions | No code | Writes still reach any directory the user owns | Does not meet the requirement |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | The park script gains the checks and tests for symlinked parts and escapes |

## Consequences

**Positive:**
- Park cannot write or delete outside the repo through a symlink.
- The rule is easy to state and test.

**Negative:**
- A user who symlinks `plan/backlog/` on purpose, such as to a shared folder, can no longer park.
- Each operation does extra filesystem calls.

**Risks:**
- A race could swap a path between the check and the operation. The check runs immediately before each operation to narrow the window.
- A legitimate setup may be refused. The message names the symlink so the user can fix it.

## Related ADRs

- ADR-0157 - related-to (both harden existing safeguards)

## Supersedes

- None

## Superseded By

- None
