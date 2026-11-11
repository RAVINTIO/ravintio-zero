# Changelog (0000448-driver-runs-approved-setup-command, 11 Nov 2026)

**Feature:** Driver runs the approved setup command
**Version:** set by the merge queue at merge
**PR:** 175

## What changed

- A new script, `setup-command.mjs`, reads the `Confirmation:` row for setup in `## Decisions`. It returns the command only if it is the pack `setup.sh` followed by plain words and `--flag` words.
- `initiative-run.mjs` runs that command at a `Setup:` hit, in the serial and the concurrent path and after the last step. It uses `bash`, an argument array, and no shell. It prints `I-D Advance: Setup: step {n} ran the approved setup command` and carries on.
- A missing row, another form, a root that can't match the merged ref, or a non-zero exit keeps the `Setup:` stop. After a non-zero exit the line adds `The approved setup command failed.`
- A `Restart:` hit still stops the driver. The command runs first, and the stop line drops the `Setup:` part.
- `roadmap-standards.md`, the initiative skill, `component.yml`, and the architecture overview describe the behaviour.
- Three new suites cover the helper, the driver, and the text. The shared queue stub in `helpers/scheduler-fixture.sh` gains a `QUEUE_SETUP_STEP` switch.
- ADR 0310 records the decision.

## Why

Four steps in initiative 0000360 changed hooks, skills, or setup. Each stopped the driver with `Setup:` for the same approved command, and each stop needed a coordinator restart. Backlog entry 0000427 asked the driver to run the approved command.

## Deviations

- P1 and P2 ran inline without subagents, because the units are small and share one driver file.
- The `Confirmation:` row names steps 1 to 21. The helper ignores the step range, so the row covers every step.
- The hook check after setup stays with the coordinator.

## Validation results

- The three new suites failed 16, 18, and 6 checks before the change. They pass 16 of 16, 29 of 29, and 7 of 7 after it.
- The related driver, skill, and standards suites pass.
