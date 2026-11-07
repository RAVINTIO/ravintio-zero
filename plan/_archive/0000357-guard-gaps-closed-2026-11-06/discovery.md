---
title: "Discovery - 0000357-guard-gaps-closed"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000357-guard-gaps-closed

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and pack sources sit beside it |
| Git pre-flight | `feat/0000357-guard-gaps-closed` cut from `initiative/0000349-clean-initiative-history` at f6a11a71, tree clean, initiative step session |
| Skills inbox | empty (no `ravintio-zero/skills-inbox/`) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.53.0`. The step bump is minor, so the target is `0.54.0`.
- Prior features (`plan/_archive/`): latest is 0000355-codeql-and-branch-cleanup (2026-11-06).
- Constraining ADRs: 0000316 ADR-001 (every hook runs through `guard-run.mjs`) and 0000317 ADR-001 (the forced-add guard).
- Component map: the pack is one product (`product.yml` id `ravintio-zero`).
- Backlog entries pulled in: 0000340 (a missing launcher fails open), 0000341 (forced-add guard gaps and Codex), 0000342 (prefix-misses log ignore rule). Queue empty.
- Chart decisions for step 6: setup writes each guard hook command so a missing `guard-run.mjs` exits 2 and `setup.ps1` changes in the same step. The forced-add guard blocks `git stage -f`, subshells, flags in variables, and any segment it can't parse. Codex gets the forced-add guard, or a backlog entry if the Codex hook model can't express it. `plan/.prefix-misses.log` goes into the `.gitignore` that setup writes and into this repo's `.gitignore`.
- Findings from the code read: `guard-run.mjs` already fails closed for a missing hook script. The gap is the launcher itself, which makes `node` exit 1. Codex already runs `merge-guard` as a PreToolUse group for Bash, so the same group form carries the forced-add guard. Setup copies `ravintio-zero/.gitignore` to the project root only when no `.gitignore` exists.
- Pending migrations 0004 and 0005 do not apply here.
