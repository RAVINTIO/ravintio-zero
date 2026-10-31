---
title: "Security Report - 0000317-block-forced-adds"
summary: "No critical or high finding."
---
# Security Report - 0000317-block-forced-adds

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The guard checks command text and never runs it. Input is parsed as a string, with no shell or `eval`. | `ravintio-zero/hooks/enforcement/block-forced-add.mjs` | Low | Tests cover quoted flags, abbreviations, compound commands, and malformed stdin. |
| A forced add through an alias, a variable, or a command substitution can pass the text check. | `block-forced-add.mjs:forcesAdd` | Medium | The CI check on `git ls-files -ci --exclude-standard` fails any ignored file that reaches a pull request. Not mitigated in the hook. |
| Codex does not run the guard. | `ravintio-zero/setup/codex.sh` | Low | Out of scope in the brief. The CI check covers every tool. |
| The guard can block a command that only names `git add -f` in text. | `block-forced-add.mjs` | Low | The message points to the Write tool. |
| The new `.gitignore` entries and the CI step widen nothing. The guard blocks more than before and allows nothing new. | `.gitignore`, `.github/workflows/ravintio.yml` | Low | Existing guard suites pass unchanged apart from the entry counts. |

**Overall risk rating:** low.

**Risk register:** R-001 stays open: the CI check is the second layer. R-002 stays open. R-003 stays open: only CI runs `setup.ps1` on Windows, and the local `pwsh` suites pass. R-004 stays open. A-001 closed: `git ls-files -ci --exclude-standard` lists no file.

**Top actions before production:** none.
