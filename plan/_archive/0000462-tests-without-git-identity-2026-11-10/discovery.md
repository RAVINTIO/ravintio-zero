---
title: "Discovery - 0000462-tests-without-git-identity"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000462-tests-without-git-identity

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000462-tests-without-git-identity`, cut from `initiative/0000360-backlog-sweep` at `a7a9a1b2`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.80.1`. The chart bump for step 35 is `minor`.
- Prior features (`plan/_archive/`): `0000382-install-lifecycle` added `doctor`, `commit_workspace_pack`, and the PR #136 fixes. `0000315-isolated-test-state` added the RAVINTIO variable clearing in the runners.
- Constraining ADRs (unless superseded): ADR-0284 (runner shards). The runners clear RAVINTIO variables per suite.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- PR #136 passed locally and failed two CI jobs. `commit_workspace_pack` relied on the global git identity, and `doctor` matched a first line without stripping a BOM from `CLAUDE.md`.
- `commit_workspace_pack` in `assert.sh` now passes `-c user.email` and `-c user.name`. The runners still leave the global git config in place, so a suite that commits without an identity passes on a developer machine.
- 53 bash suites mention `git commit`. Some of them set no identity.
- Three readers take a first line of a boot file: `doctor` in `install-lifecycle.mjs` (fixed), `preserve_developer_boot_file` in `setup.sh` (line 214), and the boot-file checks in `setup.ps1`.
- No suite writes a `CLAUDE.md` with a BOM.
- Backlog pickup: 0000414, named by the step 35 row.
- Queue: no item names step 35.
- Migration 0009 stays pending. Its migrator asks y/n and a step session has no human.

## Coaching record

None. An initiative step self-confirms its design.
