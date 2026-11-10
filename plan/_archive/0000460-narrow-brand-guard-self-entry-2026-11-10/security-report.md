---
title: "Security Report - 0000460-narrow-brand-guard-self-entry"
summary: "Findings for the exact-path skip in the brand guard."
---
# Security Report - 0000460-narrow-brand-guard-self-entry

**Overall risk rating:** low. The change narrows a fail-closed guard.

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The skip compares whole strings, so a look-alike path or a path with a prefix is not skipped | `src/ravintio-zero/scripts/brand-guard.sh`, `brand_guard_skips_path` | Low | Not needed. `test-0000460-req-001-exact-path-skip.sh` plants six look-alikes |
| A path that reaches the guard in another form, such as `./src/...`, is not skipped | `brand-guard.sh` main loop | Low | Fails closed: the guard reports the allowlist file. `git ls-files` and `pre-push` give root-relative paths |
| Injection, credentials, path traversal, dependencies, data exposure | the changed files | none found | The function reads no input beyond a `case` match. The change adds no library, no file access, and no network call |

## Risk register

- R-001 (the CI test and the script drift apart): mitigated. Both call one function and AC-3 pins that.
- R-002 (CI test fails on the allowlist file): mitigated. The test scope skips both paths.

## Top actions before production

None.
