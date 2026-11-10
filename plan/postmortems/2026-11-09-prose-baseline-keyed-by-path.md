---
title: "Postmortem: 2026-11-09 - the prose baseline keys counts by path"
summary: "A blameless record of why the pack move raised 19 prose baseline counts, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-09 - the prose baseline keys counts by path

> Path: `plan/postmortems/2026-11-09-prose-baseline-keyed-by-path.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool.

**Trigger:** P2 self-correction
**Feature:** 0000397-pack-source-in-src
**Date:** 2026-11-09

## Summary

After the move, `prose-check` reported 19 counts above the baseline in six migration records. The baseline keys counts by file path, so the moved files had no entry.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-09T21:44:27Z | The docs unit committed and reported 19 counts above the baseline in six migration records | commit `c9ef7e54`, `prose-check.mjs check` output |
| 2026-11-09T21:47:13Z | The diff ratchet learned the moved path, and a baseline mirror landed with it | commit `4847ef41` |

First missed chance to catch it: P1 Plan. The plan listed no file that keys data by path.

## 5 whys

1. The check failed because six moved files had no baseline entry under their new path.
2. The baseline in `plan/state/prose-baseline.json` keys counts by file path.
3. The diff ratchet compares each path with its count at HEAD, so a moved path counts as new.
4. A rename of a tracked folder has no rule in the ratchet.
5. The plan scan has no step that lists state files keyed by path.

**Gap:** the prose ratchet has no rename rule, and the plan scan has no cause for a path move.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Let a `src/ravintio-zero/` path keep the count of its old path | done | step 20 | `src/ravintio-zero/scripts/prose-check.mjs` | `test-0000397-req-005-prose-baseline-moved-path.sh` | commit 4847ef41 |
| preventive | Add a `Path move` cause that lists state files keyed by path | filed | pack maintainers | `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | review of the scan list | backlog 0000419 |
| detective | none, because the commit hook already failed on the raised counts | none | pack maintainers | `src/ravintio-zero/hooks/pre-commit` | the hook run | none |
