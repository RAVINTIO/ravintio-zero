---
title: "Discovery - 0000485-adr-number-collision"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000485-adr-number-collision

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000485-adr-number-collision`, cut from `initiative/0000360-backlog-sweep` at `55a758ff`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.91.0`. The chart bump for step 44 is `minor`.
- Prior features (`plan/_archive/`): 0000456 added `shared-files.mjs`, which resolves the counter files, the backlog index, and two living docs during the queue's base merge. 0000472 is the latest archived run.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. The latest is 0309. ADR-0302 (0000456) sets the shared-file resolution rules.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000479 (evidence from the 0000462 retrospective): steps 32, 33, and 35 each reserved ADR 0301 from their own branch counter. The base merge of step 35 conflicted, and the step renumbered its ADR by hand.
- `merge-queue.mjs` calls `resolveSharedConflicts` when the base merge conflicts. It resolves the counter files and the index rows. It never looks at two ADR files with one number, because their file names differ and git reports no conflict on them.
- Two backlog entries took id 0000479 the same way: `0000479-adr-number-collision` and `0000479-record-baseline-in-p0`. Step 44 renumbered the second one to 0000515 at P0.
- Wanted outcome: two steps that reserve the same ADR number merge with no hand edit, and each ADR keeps one unique number.
- Backlog pickup: 0000479-adr-number-collision, named by the step 44 row. The entry widens no guard.

## Coaching record

None. An initiative step self-confirms its design.
