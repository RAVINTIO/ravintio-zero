# Security report - 0000466-version-files-completeness-check

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Injection: the test passes fixed paths to `git` and `node` as arguments, with no shell string | `src/ravintio-zero/tests/test-0000466-req-001-version-list-complete.sh` | Low | Not applicable. Arguments are quoted and come from `mktemp` |
| Path traversal: the test reads tracked files under the repo root only | same file | Low | `git ls-files` lists paths inside the root |
| Credentials: none read or written | same file | Low | Not applicable |
| Dependencies: none added | none | Low | Not applicable |
| Data exposure: the test prints file paths only | same file | Low | Not applicable |

Overall risk rating: low. Critical and high findings: none. Risk register R-001 to R-003 stay mitigated by the scan skips, the git-rooted paths, and the no-commit fixtures.
