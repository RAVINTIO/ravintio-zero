---
title: "Security Report - 0000316-hooks-fail-closed"
summary: "No critical or high finding."
---
# Security Report - 0000316-hooks-fail-closed

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| If `guard-run.mjs` itself is missing, its command exits 1 and the guards allow. | `ravintio-zero/hooks/enforcement/guard-run.mjs` | Medium | Setup copies it with the hooks, and the setup rerun check runs every hook. Not mitigated in code. This is the same exposure as before this step, limited to one file. |
| The launcher runs a script named on its command line. It accepts only a plain `.mjs` file name and resolves it beside itself, so a path or `..` is refused. | `guard-run.mjs:36-40` | Low | Tests cover `../ok.mjs`. |
| The Codex command embeds the project path. Single quotes in `setup.sh` and double quotes in `setup.ps1` stop expansion. | `ravintio-zero/setup.sh:424-428`, `ravintio-zero/setup.ps1` | Low | `setup.sh` escapes single quotes in the path. |
| The advisory marker file sits in the OS temp folder, named by a hash of the script path. A planted file only silences one report line. | `guard-run.mjs:50-60` | Low | No decision depends on it. |
| The change blocks more than before and allows nothing new. | all hooks | Low | The guard tests pass unchanged apart from the command form. |

**Overall risk rating:** low.

**Risk register:** R-001 closed: guard tests and the launcher test show the same exit codes and output. R-002 stays open: a guard crash now blocks, and the message names the script. R-003 stays accepted. R-004 stays open: only CI runs `setup.ps1` on Windows. A-001 stays open until the setup rerun check.

**Top actions before production:** none.
