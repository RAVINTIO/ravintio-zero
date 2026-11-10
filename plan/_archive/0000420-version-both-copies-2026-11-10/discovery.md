---
title: "Discovery - 0000420-version-both-copies"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000420-version-both-copies

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000420-version-both-copies`, cut from `initiative/0000360-backlog-sweep` at `c952df2c`. Main is not the base: the PR targets the initiative branch. |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.76.0`
- Prior features (`plan/_archive/`): `0000378-merge-time-versioning` wrote `version-files.mjs` and the list. `0000397-pack-source-in-src` moved the pack source to `src/ravintio-zero/` and added `sync-installed.mjs --check` to CI.
- Constraining ADRs (unless superseded): 0000378 ADR-002, one list of version files that `check` and `set` both read.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, owns the scripts. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/`.

## Problem findings

- `src/ravintio-zero/version-files.txt` lists `docs/about.md`, `product.yml`, and `ravintio-zero/component.yml`. It does not list `src/ravintio-zero/component.yml`.
- On PR #150, the queue's commit `52f9973b` set 0.76.0 in the installed copy only. `validate-branch` failed at `sync-installed.mjs --check` with `differs: component.yml` (run 42725820833).
- Step 20 patched the source copy by hand in `95f646bf`, and the list stayed the same. Step 21's bump would fail the same way.
- `readVersions` and `setVersions` throw `file not found` for any missing entry, and a consumer repo has no `src/`.
- `merge-queue.mjs` stages `readList(list)` with `git add`, which fails on a missing path.
- `test-0000378-req-001-version-files.sh` asserts the exact shipped list.
- Backlog pickup: none.

## Coaching record

The coordinator found this while unblocking step 20. It runs under the human's standing approval for fixes that keep the queue moving.
