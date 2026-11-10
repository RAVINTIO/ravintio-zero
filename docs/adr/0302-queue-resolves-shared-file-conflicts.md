---
title: "ADR 0302: The queue resolves shared-file conflicts"
summary: "A new module resolves a fixed allowlist of conflicted files after the queue's base merge and stops on anything else."
status: "accepted"
component: "ravintio-zero"
feature: "0000456-regenerate-shared-files-at-merge"
version: "0.1.0"
---
# ADR-0302 - The queue resolves shared-file conflicts

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000456-regenerate-shared-files-at-merge
**Component:** ravintio-zero
**File:** `docs/adr/0302-queue-resolves-shared-file-conflicts.md`
**Date:** 2026-11-10

## Context

Every merged step edits a few shared files. The next open step PR then conflicts on them, and the queue stops. Initiative 0000360 lost about six rounds of about an hour each.

## Decision

A new module `shared-files.mjs` resolves a fixed allowlist of conflicted paths after the queue's base merge. The queue calls it when `git merge` reports conflicts.

- `plan/backlog/.next-id` and `docs/adr/.next-id` take the higher number.
- `plan/backlog/index.md` is rebuilt with `backlog-index.mjs`.
- `docs/decisions-index.md` and `docs/architecture-overview.md` resolve `Last updated:` lines to the step side. They union the added table rows and drop exact duplicates.
- Any other conflicted path, or a hunk the module cannot read, aborts the merge. The queue stops as it does today.

`coordinator-pr-check.mjs` gains `--base <branch>`. It lists open PRs with `gh pr list`, skips its own branch, and ignores the allowlisted files. It prints `overlap: #{n} {path}` for each shared change and exits 1.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Git `merge=union` attribute | No code | Cannot take a maximum or regenerate an index | Wrong result for counters |
| Generate both docs from ADR files | No conflicts at all | No script exists and the overview is prose | Out of scope |
| Leave it to the coordinator | No change | Costs an hour for each round | Cause of the finding |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New module, queue hook-in, overlap option |

## Consequences

**Positive:**
- Step PRs merge with no manual conflict rounds on the listed files.

**Negative:**
- The queue now writes files during a merge, so the allowlist needs care.

**Risks:**
- A row union could keep a stale row. The module aborts when both sides change one existing row.

## Related ADRs

- ADR-0299 - extends

## Supersedes

- None

## Superseded By

- None
