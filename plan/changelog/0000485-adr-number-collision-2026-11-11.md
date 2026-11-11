# Changelog (0000485-adr-number-collision, 11 Nov 2026)

**Feature:** Parallel steps reserve distinct ids
**Version:** set by the merge queue at merge
**PR:** 178

## What changed

- A new module, `id-collisions.mjs`, finds an ADR or a backlog entry that a PR added under an id the base also holds. It gives the PR's file the next free id and renames it. It fixes the heading, the title, the index row, and the lines the PR wrote that cite the old id. It also raises the counter and rebuilds the backlog index.
- `merge-queue.mjs` runs the module after the base merge, in the clean path and after a shared-file resolution. It commits the change with the subject `{id}: Renumber colliding ids` and prints `renumbered: {adr|backlog} {old} -> {new}` for each change.
- `roadmap-standards.md` gains a `#### Colliding ids` section under the merge queue.
- Two new suites, `test-0000485-req-001-id-collisions.sh` and `test-0000485-req-002-queue-renumbers.sh`, cover the module and the queue.
- `test-0000464-req-001-002-queue-branches.sh` copies the new module beside its stub queue.
- At P0 the second entry that took id 0000479 became 0000515, and the 0000442 retrospective points at the new id.
- ADR 0312 records the decision.

## Why

Steps 32, 33, and 35 of initiative 0000360 each reserved ADR 0301 from their own branch, and step 35 renumbered its ADR by hand. Two backlog entries also took 0000479. Git reports no conflict on files with different names, so the queue never saw the collision.

## Deviations

- P2 ran inline without subagents, because the units share one module.
- The queue clears a collision only for files the PR added. A reference in a file the PR did not change stays as written.

## Validation results

- The module suite passes 27 of 27 checks and the queue suite 19 of 19. Both failed before the module existed.
- The full suite result is in the verification report.

## Skipped phases

None.
