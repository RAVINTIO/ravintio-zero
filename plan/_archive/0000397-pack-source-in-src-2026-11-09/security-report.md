---
title: "Security Report - 0000397-pack-source-in-src"
summary: "Security review of the pack source move, the sync script, and the guards that now cover two paths."
---
# Security Report - 0000397-pack-source-in-src

**Overall risk rating:** Low

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The sync script deletes files in the installed folder that the source no longer has | `src/ravintio-zero/scripts/sync-installed.mjs:88` | Low | It builds each deleted path from a walk of the installed folder, so no input names a path. It refuses a symlink at either root and dies on a symlink in the source. |
| `--root` lets a caller point the script at any folder | `src/ravintio-zero/scripts/sync-installed.mjs:26` | Low | The script only reads `src/ravintio-zero/` and writes `ravintio-zero/` under that root. The test uses it on a scratch repo. |
| A guard that names `ravintio-zero/` could miss `src/ravintio-zero/` | `src/ravintio-zero/hooks/enforcement/em-dash-guard.mjs`, `hooks/pre-push`, `scripts/brand-guard.sh`, `scripts/initiative-run.mjs` | Medium | Mitigated. `test-0000397-req-005-guards-cover-both.sh` makes 44 assertions on both paths. |
| The brand-guard allowlist gained `src/` forms | `src/ravintio-zero/tests/brand-guard-allowlist.txt` | Low | Mitigated. The test compares the list with the version at `b419da39^` and finds only the `(src/)?` mirror of existing entries. |
| The prose baseline ratchet accepts a count for a moved path | `src/ravintio-zero/scripts/prose-check.mjs:240` | Low | The ceiling is the old path's count. A path with no old twin gets no allowance, and `docs/src/ravintio-zero/` gets none. Four assertions in `test-0000397-req-005-prose-baseline-moved-path.sh`. |
| The installed copy can lag the source, so hooks run old rules | `ravintio-zero/` | Low | CI runs `sync-installed.mjs --check` and fails on drift. |
| Credentials in the diff | whole diff | None found | The step touched no credential, token, or environment value. |

## Risk register cross-check

- R-001 (guard misses the new path): mitigated by the per-guard test.
- R-002 (move commit gains an edit): mitigated. `git diff -M --numstat` shows 0 changed lines in 681 rows.
- R-003 (tests pin the old path): mitigated. The suite passes from both folders.
- R-004 (installed copy lags): mitigated by the CI parity step.
- R-005 (Windows suite on a longer path): open until the first CI run on the PR.

## Top actions before merge

1. Confirm the Windows job passes on the PR.
