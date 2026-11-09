---
title: "ADR 002: settings.json writes go through a temporary file and a rename"
summary: "Every settings.json write in both setup scripts writes settings.json.planifest-tmp in the same folder, then renames it over the target. Other files stay as they are."
status: "accepted"
version: "0.1.1"
component: "ravintio-zero"
feature: "0000034-setup-hardening"
---
# ADR-0119 - settings.json writes go through a temporary file and a rename

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Component:** planifest-zero
**Date:** 2026-10-16

## Context

`setup.sh` writes `.claude/settings.json` with `fs.writeFileSync` at three sites. `setup.ps1` writes it with `Set-Content` at four sites. Both write in place. If a write stops partway, for example on a full disk, the file can be left truncated (backlog 0000091). Claude Code then can't parse it, so every hook and permission in it is lost.

`settings.json` is the one file setup writes that also holds the person's own entries. The boot file and the flags marker are setup's own output, and a rerun rewrites them whole.

## Decision

1. Every `settings.json` write in both scripts writes `settings.json.planifest-tmp` in the same folder first.
2. `setup.sh` then renames it over the target with `fs.renameSync`.
3. `setup.ps1` moves it over the target with `Move-Item -Force`, which works on Windows PowerShell 5.1 whether or not the target exists.
4. If the write fails, setup removes the temporary file and leaves the original unchanged. Each site keeps its current failure behaviour, whether a warning or a stop.
5. Each run overwrites any leftover temporary file.
6. Setup removes any leftover temporary file before writing, then creates it exclusively, so a planted link at that path is never followed.
7. The temporary file takes the original's mode. A read-only `settings.json` stays unchanged. In `setup.sh`, a symlinked `settings.json` is written through to its real file.
8. The boot file, flags marker, and setup record keep their current writes.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Back up `settings.json` before each write | The original survives any failure | Leaves a backup file for the person to clean up, and still risks a truncated target | A rename gives the same safety with no leftover |
| Temporary file in the system temp folder | No file appears in `.claude/` | A rename across file systems isn't atomic | Same-folder rename is the property that matters |
| Atomic writes for every file setup writes | One rule everywhere | Wider change, and those files hold no user entries | Out of scope. A rerun repairs them |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero (`setup.sh`) | Three write sites change to a temporary write and a rename |
| planifest-zero (`setup.ps1`) | Four write sites change the same way |
| planifest-zero (tests) | New suite forces a failed write and compares output with the `v0.4.0` script |

## Consequences

**Positive:**
- `settings.json` is always the old file or the new one.
- The person's own entries in it can't be lost to a partial write.

**Negative:**
- A hard stop between write and rename leaves `settings.json.planifest-tmp` in `.claude/` until the next run.
- The PowerShell sites get static checks only, because no `pwsh` runner exists.

**Risks:**
- A rename that a virus scanner or sync client holds open on Windows fails, and setup reports the failure. The original stays intact.

## Related ADRs

- ADR-0118 - related-to (both make setup safe to re-run)
- ADR-0116 - related-to (the cleanup that writes `settings.json` on every run)

## Supersedes

- None

## Superseded By

- None

## Revision

**2026-10-16, v0.1.1 (P5 security fix, classification: additive).** The P5 review found three Medium issues in the first version. A planted symlink at the temporary path was followed. The rename reset the file mode. `Move-Item -Force` deletes the target first, so a failed move lost both copies. Decisions 3, 6, and 7 now close them.
