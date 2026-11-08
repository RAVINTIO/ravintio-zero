---
title: "ADR 003: Consumer migration 0004"
summary: "Migration 0004 moves consumer overrides, workflow, and markers to the new names, using Bash and PowerShell helpers. Setup stops when old folders remain, and pruning removes old skill folders."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000160-ravintio-rebrand"
---
# ADR-0166 - Consumer migration 0004

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Component:** ravintio-zero
**Date:** 2026-10-24

## Context

Consumers copy the pack folder into their repo and run setup. No install command downloads it. The rename leaves four things in a consumer repo that setup does not handle:

- the old `planifest-zero/` folder
- the user content in `planifest-overrides/`
- the installed `.github/workflows/planifest.yml`, which setup never overwrites
- the old marker files

Setup already re-sets `core.hooksPath` on each run. `prune_retired_skills` and `Remove-RetiredSkills` already delete installed skill folders that the pack no longer ships. The migration mechanism is a file in `migrations/*.md` plus helper scripts, run by the migrator skill. Migration 0003 is the precedent.

A consumer who runs the new setup before the migration risks a half-moved install.

## Decision

### Migration 0004

Ship `migrations/0004-ravintio-rename.md` with two helpers: `migrate-ravintio-rename.sh` and `migrate-ravintio-rename.ps1`. The helpers do the same work.

1. Move `planifest-overrides/` to `ravintio-overrides/`. The markers live in the generated boot file, and setup rewrites it on every run, so the helper leaves them alone.
2. Move `.github/workflows/planifest.yml` to `.github/workflows/ravintio.yml`. Rewrite the `planifest-zero/` paths inside it, and the pack's own `PLANIFEST_` variables. A consumer's own `PLANIFEST_` names, such as secrets, stay as they are (S-010).
3. Remove the old marker files `.claude/.planifest-setup-flags` and `.claude/skills/.planifest-manifest`. No install writes a `.planifest-session` file, so the helper does not look for one.
4. Move the old `planifest-zero/` folder to `.ravintio-backup/planifest-zero/` after the consumer has copied in the new `ravintio-zero/` pack. The helper never deletes it. It first stops git tracking the folder, then renames it. It adds `.ravintio-backup/` to `.git/info/exclude`, and tells the human to delete the backup after checking it.
5. After a run that changes the repo, move `0004-ravintio-rename.md` to `migrations/_done/`.

### Applies when

Migration 0004 declares `Applies when:` `planifest-zero/` or `planifest-overrides/` exists. The orchestrator and `ravintio-migrator` skip a migration whose condition is false and leave it pending. The pack source repo has neither folder, so 0004 ships pending and never runs there.

### Backup instead of deletion

The first helpers deleted `planifest-zero/`. Each guard added to make that safe either missed a case or blocked a normal upgrade:

- S-001: Windows PowerShell 5.1 `Remove-Item -Recurse` follows a nested junction and deletes the files behind it.
- S-011: the dirty check missed ignored files, and skipped outside git.
- S-012: the git top-level check blocked a project below its git root.
- S-013: the parent-link refusal blocked a linked `ravintio-zero` or `.claude`.
- S-014: the dirty check blocked a pack that git never tracked, or a stray `.DS_Store`.
- S-015: the PowerShell tree walk could stop halfway on a reparse folder that is not a link.

A rename deletes nothing and never follows a nested link, so the helper needs none of those guards. Any custom file stays in the backup. The helpers drop the top-level check, the `setup.sh` check, the dirty check, and `Remove-TreeNoFollow`.

### Safety rules

- Each step is idempotent. A second run finds nothing to do and exits cleanly.
- If a step finds a conflict, the helper stops before it moves anything. A conflict is an existing target with different content.
- The helpers refuse a symlink, dangling or not, at `planifest-zero`, `planifest-overrides`, `ravintio-overrides`, `.ravintio-backup`, or either workflow file. They never follow a planted link, as setup does.
- The helpers stop when `.ravintio-backup/planifest-zero` already exists. They never overwrite an earlier backup.
- A symlinked parent folder skips only the step that would write through it, with a warning. A link at `.github` or `.github/workflows` skips the workflow step. A link at `.claude` or `.claude/skills` skips the marker under it. A link at `ravintio-zero` or `ravintio-zero/migrations` skips the archive step. The helpers only read a linked `ravintio-zero` otherwise.
- The helpers run from the folder that holds `ravintio-zero/`, which may sit below the git top level.
- The workflow rewrite goes to a temp file in the same folder, which then replaces the target. A write never follows a link.
- The old pack moves with a plain rename: `mv` in Bash and `System.IO.Directory.Move` in PowerShell. A rename moves a nested link as a link.
- Setup stops on a leftover old folder that is a link, dangling or not. Setup skips old markers under a symlinked `.claude` or `.claude/skills`.
- The helper reports each step it takes and each step it skips.

### Setup behaviour

If setup finds a `planifest-zero/` or `planifest-overrides/` folder, it stops. It tells the consumer to run migration 0004 first. Setup makes no changes in that case.

Once the pack ships only `ravintio-*` skills, `prune_retired_skills` and `Remove-RetiredSkills` remove the old `planifest-*` skill folders on the next clean setup run. Setup also removes any leftover old marker files that it finds.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Setup moves the folders itself | One step for the consumer | Setup would hold rename logic for good. A mistake moves user content | Migrations exist for one-off changes |
| Doc-only upgrade steps | No new scripts | Consumers make mistakes by hand. No idempotence | Overrides hold user content |
| Setup continues beside old folders | No forced order | Two packs and two hook sets run at once | Enforcement would split between names |
| Bash helper only | Less to maintain | Windows consumers have no path | The pack supports PowerShell 5.1 and 7 |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Adds migration 0004 and two helpers. Setup gains a leftover-folder check and marker cleanup |

## Consequences

**Positive:**
- A consumer runs one migration and keeps their overrides and workflow.
- A failed run leaves the repo in its starting state, because conflicts stop before any move.
- The upgrade deletes no file. A custom or ignored file in the old pack stays in `.ravintio-backup/`.

**Negative:**
- Consumers must run the migration before setup. Setup blocks until they do.
- Two helpers on two shells double the test work.
- The backup stays on disk until the human deletes it.

**Risks:**
- A consumer has a custom file inside `planifest-zero/`. It lands in `.ravintio-backup/planifest-zero/`. The helper and the migration text tell the consumer to check the backup before deleting it.

## Related ADRs

- ADR-0164 - depends-on: the rename map defines the targets
- 0000151 decision "Setup prunes retired hooks by list" - extends: the same prune-by-list approach
- ADR-0109 - related-to: the last folder rename

## Supersedes

- None

## Superseded By

- None
