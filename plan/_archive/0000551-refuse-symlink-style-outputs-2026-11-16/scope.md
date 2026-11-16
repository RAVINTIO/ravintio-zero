---
title: "Scope - Refuse a symlink at the writing style output paths"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Refuse a symlink at the writing style output paths

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000551-refuse-symlink-style-outputs
**Version:** 0.137.0

## In Scope

- A link check at the style file path and its folder, in `setup.sh` and `setup.ps1`.
- A link check at `AGENTS.md` before the writing block write, in both scripts.
- A fixed refusal line per path, and exit status 0.
- One test per shell for both cases.
- An update to `docs/architecture-overview.md`.

## Out of Scope

- The `AGENTS.md` boot file write by `write_boot_file`.
- The `settings.json` write path.

## Deferred

- Refuse a link at the boot file write. Nothing waits on it.
