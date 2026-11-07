# Changelog (0000379-parallel-steps-on-worktrees, 07 Nov 2026)

**Feature:** Parallel steps on worktrees
**Version:** set by the merge queue at merge
**PR:** {pending, updated at Step 9}

## What changed

- The chart `## Steps` table gains `Lane` and `After` columns. `**Concurrency:**` sets how many steps run at once, and the template defaults it to 3.
- `scripts/initiative-chart.mjs` parses the table by header name. It returns each step's lane, `After` list, and status, and `readySteps` names the steps that may start.
- With `**Concurrency:**` in the chart, `initiative-run.mjs` runs a scheduler. It starts ready steps in chart order up to the cap, each in its own worktree at `plan/.initiative-worktrees/step-{n}`.
- The driver copies the setup output into each worktree. It gives each step a control folder at `plan/.initiative-control/step-{n}/`.
- A step under the scheduler ends at ready. It writes the PR number to `$RAVINTIO_INITIATIVE_CONTROL/ready` and prints `I-D Advance: Ready: PR #{n}`.
- The driver runs `merge-queue.mjs run` for each ready PR in a queue worktree, one at a time in ready order.
- A step outside the scheduler runs the merge queue itself after green CI. P4 sets no version in an initiative step, and the step never edits the chart.
- `merge-queue.mjs` also sets `**Position:**` to the lowest step that has not merged.
- A block, a failed session, a queue failure, or a `Restart:` or `Setup:` hit stops new starts. The driver prints `I-C Run: Step {n}: {state}` for every step before it exits 1.
- The watcher prints each running step's activity lines with the step number. The initiative skill reports each running step.
- The boot templates and the repo git override scope the worktree rule to human sessions.
- The roadmap standards, the ship and initiative skills, the living docs, and the live chart describe the concurrent flow. The live chart moves its `## Lanes` table into `## Steps`.

## Why

The driver ran one step at a time in one working tree. A long initiative took as long as all its steps added together. Independent steps now run at once and merge through the queue, so versions still follow merge order.

## Deviations

- A chart without `**Concurrency:**` keeps the serial driver path unchanged (ADR-002).
- The committed chart holds only `pending` and `merged`. The driver derives `running` and `ready` from the control area (ADR-001).
- The orchestrator skill gained no text. Its rule to end a step turn at `I-D Advance: Complete:` predates the `Ready:` line, and the roadmap standards name both.

## Validation results

- Recorded at P3.

## Skipped phases

None
