---
title: "Acceptance Evidence - 0000397-pack-source-in-src"
summary: "Checks, security findings, and execution evidence for the pack source move."
---
# Acceptance Evidence - 0000397-pack-source-in-src

## Checks

- Full suite from `src/ravintio-zero/tests/` in a clean clone: 373 feature suites passed, 19 regression suites passed, 2 failed.
- Both failures come from the base commit. `test-0000037-req-004-remove-old-folder.sh` needs local git config and `test-0000318-req-004-merge-guard-pinned.sh` needs an `origin` ref. Both fail in any clone at base `2adff7e3`.
- The same suite from `ravintio-zero/tests/` gave the same result apart from one timing suite that passed alone.
- Archetype gates: none installed.
- Self-corrections: 8 (43 suites fixed for repo-root paths, the prose baseline path, 3 whole-repo scans, and the sync parity refreshes).
- Docs edit pass: 7 docs, 1 cycle, `prose-check.mjs` exit 0.

## Security

- 0 critical, 0 high, 1 medium (mitigated by 44 assertions across both paths), 5 low.
- See `plan/current/security-report.md`.

## Execution evidence

- `git log --follow src/ravintio-zero/setup.sh` lists 66 commits from before the move.
- The move commit shows 0 changed lines across 681 rows.
- `sync-installed.mjs --check` exits 0 on the final tree and exits 1 on a scratch repo with one changed file.
- A scratch consumer install keeps `ravintio-zero/` and creates no `src/ravintio-zero`.
- `not-verifiable`: the Windows suite on the new depth, until the first CI run.
