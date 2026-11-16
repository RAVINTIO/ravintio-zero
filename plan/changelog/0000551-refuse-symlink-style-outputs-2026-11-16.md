# Changelog (0000551-refuse-symlink-style-outputs, 16 Nov 2026)

**Feature:** Refuse a symlink at the writing style output paths
**Version:** set by the merge queue at merge
**PR:** #239

## What changed

- `setup.sh` and `setup.ps1` refuse a link at the style file, its `output-styles` folder, or `AGENTS.md`.
- Each refusal prints a fixed `! Refused:` line, skips the write, and exits 0.
- One suite per shell covers a linked file, a broken link, a linked folder, and the unchanged plain install.

## Why

A link at a style output path redirected the setup write to another file. Backlog entry 0000408 recorded the gap.

## Deviations

- The agent ran units U1 to U4 inline in one tree and dispatched no subagent, because each unit is small.
- Unit U4 (docs) has no executable check. Backlog 0000410 tracks the rule.
- The boot file write of `AGENTS.md` still follows a link. The brief deferred it.

## Validation results

- The clean-clone suite shows 475 feature suites passed and 3 failed, and 19 regression suites passed. All 3 failures also fail on the base commit.
- The new suites pass with 20 checks in bash and 16 in PowerShell.
- The agent verified every criterion by running `setup.sh` with planted links. Security risk is low.

## Skipped phases

None.
