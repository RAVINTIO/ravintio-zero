---
title: "ADR 005: Relabel the rename release as 0.12.0"
summary: "0000160 shipped as 1.0.0 without a separate version decision. It becomes 0.12.0, this release is 0.13.0, and the legacy fallbacks go at 1.0.0."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000164-hardening-and-backlog-skill"
---
# ADR-0172 - Relabel the rename release as 0.12.0

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000164-hardening-and-backlog-skill
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

0000160 renamed the pack to RAVINTIO and shipped as 1.0.0. Its discovery bundled the major bump into the rename-depth question. The human asked for the rename, not for a major version. 0000151 shipped as 0.11.0, so the minor bump for 0000160 was 0.12.0.

ADR-0164 chose 1.0.0 because the rename breaks consumer paths. Semantic versioning allows a breaking change in any 0.x release, so 0.x does not hide the break. ADR-0165 tied the `PLANIFEST_*` fallbacks to the 1.x line.

## Decision

- 0000160 is relabelled 0.12.0. Ship tags `v0.12.0` on the commit that `v1.0.0` points at, then deletes `v1.0.0` from `origin`.
- This release is 0.13.0.
- The legacy fallbacks from ADR-0165 stay through 0.x and go at 1.0.0.
- The orchestrator's downgrade block does not apply. The human overrode it on 2026-10-25, and the build log records the override.
- `plan/_archive/` and `plan/changelog/` stay as written. The 0.13.0 change record explains the relabel.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Stay on 1.x and ship 1.1.0 | No tag change | Keeps a major version the human never asked for | The human chose to re-version |
| Ship 0.13.0 and keep the `v1.0.0` tag | Keeps the published tag | Tag sorting still shows 1.0.0 as newest | Tooling would pick the wrong release |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Version fields, comments, docs, and one test change. No behaviour change. |

## Consequences

**Positive:**
- The version line matches the minor bumps the human asked for.
- The 0.x line leaves room to declare a stable interface later, on purpose.

**Negative:**
- A consumer who pinned `v1.0.0` loses that tag and must move to `v0.12.0` or later.
- Semantic-version tools see 0.13.0 as lower than the 1.0.0 already published.

**Risks:**
- An archived record still names 1.0.0, which can confuse a reader. The 0.13.0 change record points to this ADR.

## Related ADRs

- ADR-0164 - superseded for its version decision only
- ADR-0165 - the removal point moves from 2.0.0 to 1.0.0

## Supersedes

- The version decision in ADR-0164

## Superseded By

- None
