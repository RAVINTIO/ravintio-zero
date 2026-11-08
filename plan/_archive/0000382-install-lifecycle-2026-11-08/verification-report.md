---
title: "Verification Report - 0000382-install-lifecycle"
summary: "Execution evidence for each acceptance criterion of step 6."
---
# Verification Report - 0000382-install-lifecycle

Setup ran with `bash ravintio-zero/setup.sh claude-code ...` in temporary git repositories that held a committed copy of the pack. PowerShell ran under `pwsh` in the same way.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| Uncommitted file blocks setup, ignored file does not, no git fails | CLI | verified | Exit 1 and `ravintio-zero/hooks/pre-push` named for a mode change. Exit 1 with `git repository` outside git. An ignored file let setup exit 0. |
| Doctor fails before setup and on a bad hook | CLI | verified | Exit 1 with `setup has not run`. Exit 1 with `hook ravintio-zero/hooks/pre-push is not executable`. Exit 0 and `Doctor found no problems` after setup. |
| Update commits the pack and keeps the flags | CLI | verified | `git log` showed `Update the RAVINTIO Zero pack`. The rerun printed `--strict-orchestrator` and `plan/.orchestrator-strict` survived. |
| Setup creates `plan/current/` | Side effect | verified | The folder existed after the first run. |
| Uninstall reverses setup and keeps own work | CLI | verified | `core.hooksPath` unset. `settings.json` held only the developer's hook and key. A developer skill and command survived. `plan/state/claude-code.md` survived. |
| Uninstall refuses during a run | CLI | verified | Exit 1 with `plan/.orchestrator-active exists`, and again with the driver lock. |
| Strict mode follows the flags | CLI | verified | Plain re-run kept the sentinel. `--no-strict-orchestrator` removed it and printed `strict mode off`. Both flags exited 1. |
| Help, clean bytes, banner | CLI | verified | `--help` and `-h` exit 0 and list every flag. `iconv` accepted `setup.sh`. The banner is a plain rule. |
| Joining section, commands table, override skills pointer | Side effect | verified | `getting-started.md` holds each heading and the folder name. |
| Hook block messages name a next step | Hook / gate | verified | A suite checks each hook source. `merge-guard` gained `Next step:` text. |
| Session-start install check | Hook / gate | verified | The hook printed `Install check` with `core.hooksPath` once, and nothing on the second prompt of the session. |
| Facts file lists flags and hooks, CI fails when stale | CLI | verified | A suite compared flags and hooks. `--check` exited 1 on a replaced file. The workflow runs the check. |
| Shell parity | CLI | verified | `test-0000382-req-001-004-powershell-lifecycle.ps1` passed 27 checks under `pwsh`. Update under PowerShell was run by hand and committed the pack. |
