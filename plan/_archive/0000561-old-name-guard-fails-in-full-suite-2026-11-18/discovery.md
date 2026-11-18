---
title: "Discovery - 0000561-old-name-guard-fails-in-full-suite"
summary: "Raw discovery-pass findings for initiative step 17."
---
# Discovery - 0000561-old-name-guard-fails-in-full-suite

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000561-old-name-guard-fails-in-full-suite`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.143.0`
- Prior features (`plan/_archive/`): 0000577 is the latest. 0000189 and 0000192 built the old-name guard.
- Constraining ADRs: none that affect the guard.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy.

## Step inputs

- Backlog entry 0000527. Problem: `test-0000189-req-007-old-name-guard.sh` fails in some full-suite runs and passes alone. It prints an allowlisted path such as `ravintio-zero/migrations/0005-initiative-rename.md:45`.
- Wanted outcome: a full-suite run and a solo run give the same result. A test plants the earlier suite's change and expects the guard to pass.
- Chart row: keep the allowlist as it is. Make the guard read a stable copy of the tree, or fix the earlier suite that changes it.
- The guard uses `git grep -n` on the working tree, so an earlier suite that edits a tracked file changes its input.
- Chart rows also cover pack edits in both trees, known baseline failures, in-step pin updates, and the docs-unit `RED:` and `GREEN:` rule.
- Queue: no item names step 17.
