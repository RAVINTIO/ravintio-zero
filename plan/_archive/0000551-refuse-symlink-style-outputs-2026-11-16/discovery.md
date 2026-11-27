---
title: "Discovery - 0000551-refuse-symlink-style-outputs"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000551-refuse-symlink-style-outputs

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source in `src/` beside `plan/_archive/` |
| Git pre-flight | Branch `feat/0000551-refuse-symlink-style-outputs`, cut by the initiative driver. Pre-flight question skipped for an initiative step. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.136.0`. Step bump `minor` plans `0.137.0`. The merge queue sets the released version.
- Prior features: `plan/_archive/`. The nearest is 0000389-writing-standard, which added the writing style install.
- Constraining ADRs: none found for the style install paths.
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`, mirrored to `ravintio-zero/`.
- Source: backlog entry 0000408. Setup writes `.claude/output-styles/ravintio-writing.md` and the `AGENTS.md` writing block with no symlink check.
- Code: `install_writing_style_claude` and `install_writing_style_codex` in `setup.sh`. `Install-ClaudeWritingStyle` and `Install-CodexWritingBlock` in `setup.ps1`.
- Finding: `write_boot_file` also writes `AGENTS.md` through a symlink. That write is outside the entry. Deferred.
- Repo instructions: four override files in `ravintio-overrides/instructions/`.
- Decisions rows for step 7: listed in the build log.
