---
title: "ADR 001: The repo self-hosts on planifest-zero"
summary: "Delete planifest-framework/ with git rm -r, so the repo runs on the planifest-zero/ it ships. Repoint core.hooksPath first, move the setup record to plan/state/, and defer the reinstall until after merge."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000037-self-host-on-planifest-zero"
---
# ADR-0127 - The repo self-hosts on planifest-zero

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

The repo ships `planifest-zero/`, but its own pipeline runs on the older `planifest-framework/` copy. The rename suite fails while that copy exists (backlog 0000097). Git reads its hooks from `planifest-framework/hooks`, so a plain deletion switches off `commit-msg` with no error (R-005). The setup record sits in `planifest-overrides/setup-config/`, where `planifest-zero/setup.sh` doesn't look. The installed skills that run this feature cite `planifest-framework/` paths.

## Decision

1. Point `core.hooksPath` at `planifest-zero/hooks` before the deletion (R-005).
2. Delete `planifest-framework/` with `git rm -r`, so the repo runs on the `planifest-zero/` it ships.
3. Move the setup record to `plan/state/claude-code.md`, with an empty `flags` array and no `backendUrl`. Remove `planifest-overrides/setup-config/`.
4. After the deletion, the rest of this run reads each `planifest-framework/{path}` from `planifest-zero/{path}`.
5. The human runs `planifest-zero/setup.sh claude-code` after merge. Setup prunes the old skills that this run uses, so the reinstall waits.

The stack stays as the design states: Bash, PowerShell, and Node.js scripts, with GitHub Actions CI.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep both copies | No disruption to the running pipeline | The rename suite keeps failing. Two copies drift apart | It leaves the problem this feature exists to fix |
| Delete and reinstall within the run | The repo ends the run on the new skills | Setup prunes the skills that run the later phases mid-run | The run can't finish on skills it has removed |
| Delete now and reinstall after merge | The rename suite passes. The run keeps its skills to the end | The installed hooks and skills cite a missing folder until the reinstall | Chosen |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Becomes the only framework copy. Its tests README drops the old folder name |
| repo-level files | `core.hooksPath`, `plan/state/`, and `planifest-overrides/` change. `planifest-framework/` goes |

## Consequences

**Positive:**
- The rename suite passes in full, and the full local run has 0 failing suites.
- The repo runs on the product it ships, so each change to `planifest-zero/` gets used here first.

**Negative:**
- The installed `auto-trigger-orchestrator` hook looks for `planifest-framework/` and stops firing (R-004). The human loads the `planifest-orchestrator` skill by name until the reinstall.
- `planifest-zero/` lacks four files that the old copy has:
  - `standards/telemetry-standards.md`
  - `templates/defect-report.template.md`
  - `workflows/change-pipeline.md`
  - `workflows/fast-path.md`

**Risks:**
- R-001, R-002, R-004, and R-005.

## Related ADRs

- ADR-0128 - related-to (the `bash-suites` job passes only after this deletion)

## Supersedes

- None

## Superseded By

- None
