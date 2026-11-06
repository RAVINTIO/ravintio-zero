# Changelog (0000351-step-titles-and-history-shape, 06 Nov 2026)

**Feature:** Step titles and history shape
**Version:** 0.49.0
**PR:** #111

## What changed

- `ravintio-zero/scripts/check-initiative-history.mjs` reads the `## Steps` table of the chart. It expects one commit per step in chart order, titled `{feature-id}: {Title} (#{n})`, then at most one `{initiative-id}: Initiative admin (#{n})` commit. It takes the chart from `--chart`, from `plan/current-initiative/`, or from the archived chart named by the id in `--head`.
- `initiative.template.md` gains a `Title` column in `## Steps`. P0 uses it as the brief title, and ship uses it as the step PR title.
- The ship skill titles a step PR `{feature-id}: {Feature title}`. `roadmap-standards.md` adds `## Commit titles`, the one-commit PR subject rule, and the `--title` flag in I-D Advance. `commit-standards.md` adds the initiative commit titles.
- The plan skill gains `## Chart formats`. A step that changes a chart format updates the active `initiative.md` in the same step.
- Backlog entries 0000350, 0000339, and 0000268 are pulled in and deleted. Entry 0000345 stays for steps 2 and 3.

## Why

A step squash took its title from free text, so a reader could not match a commit to its feature. The check also ignored the shape of the branch, so coordinator commits between steps passed.

## Deviations

- The archived chart lookup uses `plan/_archive/{id}-*/initiative.md`. The plan assumed `{id}-*-initiative-*`, which matches no real archive folder. REQ-003 and ADR-001 now say so.
- A frozen line in the start-actions reference stays unchanged (test 0000151-req-011). The brief-title note is a new line.
- Two older tests (0000043-req-001 and 0000252-req-003) now expect the seven-column `## Steps` header.

## Validation results

- The full suite passes: 262 feature suites and 19 regression suites. The consistency check is clean.
- 9 criteria verified by execution. 0 not-verifiable. Security review found no critical, high, or medium findings.

## Skipped phases

None.
