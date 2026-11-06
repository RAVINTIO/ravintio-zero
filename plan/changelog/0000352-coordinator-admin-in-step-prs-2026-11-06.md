# Changelog (0000352-coordinator-admin-in-step-prs, 06 Nov 2026)

**Feature:** Coordinator admin in step PRs
**Version:** 0.50.0
**PR:** pending

## What changed

- `ravintio-zero/scripts/reserve-id.mjs --commit` refuses on a branch that starts with `initiative/`. It exits 1, changes nothing, and names the `feat/` route. A run without `--commit` is unchanged.
- `roadmap-standards.md` defines a queue item as a folder in `plan/.initiative-queue/`. Its `item.md` holds `**Step:**` and `**Destination:**`. The step commits the items that name it before P4 raises the PR. Admin that fits no step lands through a `chore/` PR.
- A queued backlog entry carries an `{id}` placeholder, and the step reserves the id.
- `## Coordinator PRs` and the initiative skill name `gh pr merge --squash --delete-branch {n}`.
- The initiative, postmortem, and retrospective skills say that `--commit` refuses on `initiative/*`. The ship skill and the start-actions reference point to I-C Run for the queue.
- Backlog entry 0000332 is pulled in and deleted. Entry 0000345 stays for step 3 (rule 3).

## Why

Initiative 0000312 put 13 coordinator squashes between its 10 step squashes. Aligned admin now rides in the step PR, and the id counter no longer commits directly on the initiative branch.

## Deviations

- The coordinator cannot reserve an id while the driver runs, because it never edits the working tree then. A queued entry carries an `{id}` placeholder and the step reserves the id. The plan assumed the coordinator would do it. REQ-003, REQ-005, and ADR-001 now say so.

## Validation results

- The full suite passes: 265 feature suites and 19 regression suites. The consistency check is clean.
- 7 criteria verified by execution. 0 not-verifiable. Security review found no critical, high, or medium findings.

## Skipped phases

None.
