---
title: "Retrospective: 2026-11-01 - guards, history, and test noise"
summary: "A blameless review of a finished run or initiative, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-01 - guards, history, and test noise

> Path: `plan/retrospectives/{feature-id}-{date}.md` for a run, `plan/retrospectives/{id}-{slug}-initiative-{date}.md` for an initiative. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Mode:** initiative
**Subject:** 0000312-guards-history-and-test-noise
**Date:** 2026-11-01

## Summary

All 10 steps shipped as charted, from `v0.41.0` to `v0.48.0`, with no step build log holding a `Blocked:` line. The driver stopped once outside a planned setup stop, when step 7 ended its session after P2.

## What helped

- The `## Decisions` table answered every fork with no human present. Steps 6 to 10 logged 14 `Decision applied (initiative chart)` lines between them (`plan/_archive/00003{18,19,20,21,27}-*/build-log.md`).
- The `Setup:` stop from step 1 kept each later step on installed hooks that matched the pack. All 9 wired hooks resolved and ran at every setup rerun from step 7 onwards (PRs #93, #95, #97, #99).
- Coordinator PRs kept the initiative branch linear. Its history holds one squash per PR and no merge commits (`git log --first-parent`, PRs #78 to #99).
- Step 7's history check found the one untitled commit before delivery, as `## History check` planned (`check-initiative-history.mjs`, commit `8c01e3d2`).

## What slowed the work

- Step 7 stopped after P2. Its session ended its turn with `P2 Implement: Complete: ... Next is P3 Validate.` and no background task pending, so `claude -p` exited. The driver found the step unmerged and stopped (`plan/.initiative-logs/step-7.log`). Filed as entry 0000334.
- Step 7's earlier attempt reached the host usage limit, so step 7 took 2 hours 30 minutes against about 30 minutes for most steps (`plan/.initiative-logs/step-7.attempt-2.log`).
- Each setup stop needed a coordinator PR to commit one `writtenAt` timestamp, at 12 to 20 minutes each (PRs #83, #86, #88, #90, #93, #95, #97).
- Step 7 reserved id 0000334 on a branch cut before PR #91 took that id, so two entries shared it. PR #93 renumbered one to 0000335. Open entry 0000332 covers id reservation on a feature branch.
- Several steps ran three or four full suites, mostly to find hard-coded hook counts one batch at a time (`supervision-notes.md` at `bb099387`, retrospective input).
- Two steps departed from chart rules with no check to catch it. Step 5 ran independent units inline on cost alone, against `## Parallel work in each step`. Step 6 recorded no scope lock path lines, where steps 1 to 5 each recorded four (`plan/_archive/0000317-*/build-log.md`, `plan/_archive/0000318-*/build-log.md`).
- Step 3 fixed its own CI failure in `cc98715` instead of stopping, though the chart lists a step CI failure as a stop. Filed as entry 0000344.
- A CI job rerun reuses the original event payload, so an edited PR body needs a close and reopen to start a fresh run (PR #91).

## Initiative questions

1. Charted versus shipped (steps, bumps, versions): every step, bump, and version matched the chart at activation (`f557cdd8`). Tags `v0.41.0` to `v0.48.0` each sit on the matching step squash.
2. Friction that repeated across steps:
   - Typed phase times. Steps 1, 2, and 4 logged round times such as `19:55:00Z`, and step 7 rewrote its P3 and P4 times at ship. Open entries 0000266 and 0000335 cover this.
   - The test-impact scan missed suites that name a wired module or a workflow job, in steps 4, 5, and 10 (`plan/retrospectives/0000316-*`, `0000317-*`, `0000327-*`). Open entry 0000338 covers this.
   - Subagent briefs left out commit rules. Step 6 subagents lacked the subject limit, and step 8 tracks committed each other's paths (`plan/retrospectives/0000318-*`, `0000320-*`). Open entries 0000333 and 0000336 cover this.
3. Each stop and how long each step took:

   | Step | Feature | Duration | Stop after the step |
   |------|---------|----------|---------------------|
   | 1 | 0000313-driver-setup-stop | 50 min | `Restart:`, setup rerun |
   | 2 | 0000314-step-logs-stay-in-place | 30 min, from typed times | `Setup:` |
   | 3 | 0000315-isolated-test-state | 22 min | none |
   | 4 | 0000316-hooks-fail-closed | 45 min | `Setup:` |
   | 5 | 0000317-block-forced-adds | 37 min | `Setup:` |
   | 6 | 0000318-titled-coordinator-prs | 26 min | `Restart:` and `Setup:` |
   | 7 | 0000319-initiative-history-checks | 2 h 30 min | Early exit after P2, then `Restart: Setup:` |
   | 8 | 0000320-quiet-session-start | 26 min | `Setup:` |
   | 9 | 0000321-backlog-triage | 31 min | `Setup:` |
   | 10 | 0000327-squash-before-main | 24 min | Planned setup rerun before delivery |

   Durations run from the first `Start` to the last `End` in each step build log. Every planned stop ended with the confirmed setup command and a new driver. The step 7 early exit ended with a driver restart, after the coordinator filed entry 0000334.
4. Initiative tooling gaps:
   - The driver sends one prompt and treats a clean exit as the end of the step (entry 0000334).
   - A missing guard launcher lets every guarded call through (entry 0000340).
   - The forced-add guard misses some forms and has no Codex copy (entry 0000341).
   - The watcher reports false stale lines before a step writes its build log (open entry 0000270).

## Keep

- Chart-time `## Decisions` rows, including `Confirmation:` rows for the setup command. They let 10 steps run with no fork stop (`plan/_archive/0000312-guards-history-and-test-noise-initiative-2026-11-01/initiative.md`).
- A hook check after every setup rerun, before the next driver starts (PRs #93 to #99).

## Change

- Keep a step session running until `I-D Advance: Complete:` or a `Blocked:` line (entry 0000334).
- Stop committing a timestamp-only setup record at each setup stop (entry 0000343).
- Give a one-commit coordinator PR the titled commit subject (entry 0000339).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Keep a step session running to the end of the step | pack maintainers | `ravintio-zero/scripts/initiative-run.mjs`, orchestrator skill | A driver test with a session that exits after P2 | entry 0000334 |
| Use the titled form for a one-commit squash subject | pack maintainers | `ravintio-zero/standards/roadmap-standards.md` | `check-initiative-history.mjs` on the next initiative | entry 0000339 |
| Block the call when the guard launcher is missing | pack maintainers | `setup.sh`, `setup.ps1` hook wiring | A test that removes `guard-run.mjs` | entry 0000340 |
| Close the forced-add guard gaps and add it to Codex | pack maintainers | `ravintio-zero/hooks/enforcement/block-forced-add.mjs` | A test case for each form | entry 0000341 |
| Ignore the prefix-misses log in `.gitignore` | pack maintainers | `.gitignore`, setup | A setup test | entry 0000342 |
| Skip timestamp-only setup records | pack maintainers | `setup.sh`, `setup.ps1` | Two setup runs leave a clean tree | entry 0000343 |
| Let the chart say whether a step may fix its own CI | pack maintainers | `ravintio-zero/templates/initiative.template.md` | A template test | entry 0000344 |
