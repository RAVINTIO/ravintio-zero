---
title: "Verification Report - 0000381-setup-safety"
summary: "Execution evidence for each acceptance criterion of step 5."
---
# Verification Report - 0000381-setup-safety

Setup ran with `bash ravintio-zero/setup.sh claude-code` in a temporary project. The project held a copy of the pack, a developer `CLAUDE.md`, a capability skill with `references/`, and a retired `retrofit.md` command. A planted manifest line pointed at a folder outside the project.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| Manifest lines are relative, and an outside line is skipped | Side effect | verified | First manifest line read `.claude/skills/ravintio-file-backlog`. Re-run printed `Warning: manifest entry outside the skills directory, skipped`, and the outside file survived. |
| No suite changes `.claude/skills/` | CLI | verified | The full run ended with 0 changed skills paths. |
| Capability skill installs whole | Side effect | verified | `.claude/skills/s/references/r.md` existed. |
| First install keeps `CLAUDE.md` content | Side effect | verified | `ravintio-overrides/instructions/original-CLAUDE.md` existed. |
| Retired and own commands | Side effect | verified | `.claude/commands/` held only `feature-pipeline.md` after setup. The own-command case is covered by the suite. |
| Shell parity | CLI | verified | The paired `.ps1` suites passed under `pwsh`. |
| Migration 0008 helpers | CLI | verified | Both helpers removed the three files, kept a developer command, and exited 0 on a second run. |
