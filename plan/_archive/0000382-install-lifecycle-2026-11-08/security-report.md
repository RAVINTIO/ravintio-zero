---
title: "Security Report - 0000382-install-lifecycle"
summary: "Security review of the update, doctor, uninstall, and clean-tree changes."
---
# Security Report - 0000382-install-lifecycle

**Overall risk rating:** Low

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Uninstall removes guards | `ravintio-zero/scripts/install-lifecycle.mjs` `uninstall` | Medium | Mitigated. It refuses while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists, prints each removal, and needs the explicit `--uninstall` flag. The chart approves this widening. |
| Uninstall removes a developer file | `uninstall`, skills and commands steps | Medium | Mitigated. It removes a skill only when the manifest lists it and the pack or capability skills name it. It removes a command only when the pack ships that file name. A link is never followed. A file that differs from the pack copy stays. |
| Update copies an untrusted source | `update`, `mirror` | Medium | Mitigated. The human names the source. The script skips links, refuses the installed pack as source, refuses uncommitted pack files, and commits the copy so the diff shows in git. |
| Manifest path escape in uninstall | `uninstall` | Low | Mitigated. A line with `..` or a parent other than the skills directory is skipped, as in setup. |
| Settings edit damages developer entries | `removeSettingsHooks` | Low | Mitigated. It removes only commands that name the enforcement folder and a pack hook module. It writes through a temporary file and a rename. |
| Clean-tree check has a bypass | `setup.sh`, `setup.ps1` | Low | Mitigated. There is no flag or environment switch. A test proves an unknown flag does not bypass it. |
| Credentials | all changed files | None found | Not applicable |
| Dependencies | none added | None | Not applicable |

No guard gains an allowed form. The risk register entries R-001 to R-005 are mitigated by the suites named in the acceptance criteria. R-005 (the update commit trips a repo hook) is mitigated by a stop with the git error.

Top action before release: run `setup.sh claude-code --doctor` in the main checkout after the merge, because its installed copy lags the pack.
