---
title: "Security Report - 0000462-tests-without-git-identity"
summary: "Findings for the git isolation in the runners and the BOM fix in setup.sh."
---
# Security Report - 0000462-tests-without-git-identity

**Overall risk rating:** low. The change touches test runners and one string compare in `setup.sh`.

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The temporary git config is created with `mktemp` in `TMPDIR` and removed on exit | `src/ravintio-zero/tests/helpers/git-isolation.sh`, `isolate_git_env` | Low | `mktemp` gives a unique file with mode 600. The Bash runner removes it with an `EXIT` trap, and the PowerShell runner removes it in a `finally` block |
| `setup.sh` pipes the boot file through `sed` before `grep -qxF` | `src/ravintio-zero/setup.sh`, `preserve_developer_boot_file` | Low | The path is quoted, and the marker follows `--`. The `sed` program is a fixed string. The change reads the file and writes nothing new |
| Injection, credentials, path traversal, dependencies, data exposure | the changed files | none found | The runners read no external input. The change adds no library, no network call, and no credential |

## Risk register

- R-001 (the isolation exposes suites with no identity): mitigated. The full run passed 389 of 389, so no suite needed a fix.
- R-002 (a suite needs another global setting): mitigated for the same reason.
- R-003 (the runners drift apart): mitigated. AC-2 of REQ-001 reads both.

## Top actions before production

None.
