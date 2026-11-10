---
title: "Discovery - 0000460-narrow-brand-guard-self-entry"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000460-narrow-brand-guard-self-entry

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000460-narrow-brand-guard-self-entry`, cut from `initiative/0000360-backlog-sweep` at `7db9f89e`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.77.1`. The chart bump for step 34 is `patch`.
- Prior features (`plan/_archive/`): `0000394-github-security-and-ci-lint` wrote the brand guard. `0000397-pack-source-in-src` moved the pack source to `src/ravintio-zero/`.
- Constraining ADRs (unless superseded): ADR-0281, one brand guard allowlist file read by the CI test and `pre-push`.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- `src/ravintio-zero/tests/brand-guard-allowlist.txt` holds a self-entry row at line 87. Its path regex matches the allowlist file and its line regex is `.`. It lets every line of the allowlist file pass the brand guard.
- No `## Decisions` row approved that widening of a fail-closed guard.
- `scripts/brand-guard.sh` and `test-0000160-req-006-brand-guard.sh` both apply the allowlist. The test builds its scope from `git ls-files` and has its own `allowed` function.
- Entry 0000432 and the queued instruction ask for an exact-path skip in the script, with no pattern and no allowlist row.
- The human chose on 2026-11-10 that the skip covers both `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt`.
- The allowlist entry for the guard's own test (`test-0000160-req-006-brand-guard.sh`) is a separate row and stays.
- Backlog pickup: 0000432, named by the step 34 row.
- Queue: `narrow-brand-guard-self-entry` names step 34.

## Coaching record

None. An initiative step self-confirms its design.
