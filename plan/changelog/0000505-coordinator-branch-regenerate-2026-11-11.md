# Changelog (0000505-coordinator-branch-regenerate, 11 Nov 2026)

**Feature:** Coordinator branches regenerate shared files
**Version:** set by the merge queue at merge
**PR:** #181

## What changed

- `scripts/coordinator-merge.mjs --base {ref}` merges the initiative branch into a coordinator branch. It resolves conflicts on shared files and then regenerates the backlog index and the counters. It commits any change with the subject `{id}-{slug}: Regenerate shared files`.
- If a conflict touches any other file, the command aborts the merge, names the file, and exits 1. It also exits 1 on a dirty tree. It never pushes.
- Test: `test-0000505-req-001-coordinator-merge.sh`.
- ADR 0314 records the decision. `roadmap-standards.md` and `docs/architecture-overview.md` describe it.

## Why

On 2026-11-11 the coordinator merged the initiative branch into the branch for steps 42 to 50. The merge conflicted in `plan/backlog/index.md`. Coordinator branches had no command that resolves generated files (backlog entry 0000506).

## Deviations

The design's Component Paths gained `component.yml` in the source and installed copies, so the manifest edit passed `gate-write`.

## Validation results

Full suite in a clean clone, 4 shards: 417 suites passed, 2 failed. Both failures also appear in the baseline. Security rating: low.

## Skipped phases

None.
