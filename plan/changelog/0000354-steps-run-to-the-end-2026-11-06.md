# Changelog (0000354-steps-run-to-the-end, 06 Nov 2026)

**Feature:** Steps run to the end
**Version:** 0.52.0
**PR:** 114

## What changed

- `initiative-run.mjs` resumes a step that exits 0 with no `Blocked:` line and an unchanged position. It reads the last `session_id` from the stream events, checks it, and runs `claude -p --resume {session}` with a continue prompt, up to two times. A third unmerged exit prints `I-C Run: Blocked:` and exits 1. A non-zero exit, a block, or a missing session id never resumes.
- The orchestrator skill states that a step session never ends its turn before `I-D Advance: Complete:` or a `Blocked:` line.
- `setup.sh` and `setup.ps1` leave `plan/state/{tool}.md` unchanged when only `writtenAt` would change, and print `= plan/state/{tool}.md (unchanged)`. The ignored marker keeps its timestamp.
- `ravintio-zero/tests/helpers/driver-args.sh` holds the `claude` arguments. Three driver suites and the resume suite read it.
- `initiative-watch.mjs` prints `I-C Run: waiting for the build log` once when `plan/current/build-log.md` is missing and skips the stale check. It names the running step from the newest `step-{n}.log`.
- The chart template holds `**Step CI fixes:**` (`allowed` or `stop`, default `stop`). `roadmap-standards.md` states the rule at I-D Advance step 4, and adds a `#### Resume` section.
- `run-tests.sh` lists the new helper.
- Backlog entries 0000334, 0000343, 0000256, 0000270, and 0000344 are pulled in and deleted.

## Why

A step session that ended its turn after P2 stopped the driver with no stated cause. Each `Setup:` stop cost a PR for one timestamp. The watcher reported a stale log before a step wrote one.

## Deviations

- `test-0000032-req-001-bash-write-to-plan-state.sh` (c) expected a second run to change `writtenAt`. It now expects the record unchanged.

## Validation results

- The full suite passes: 271 feature suites and 19 regression suites, after one fix that listed the new helper in `run-tests.sh`. The consistency check, the backlog index check, and the self-description check pass.
- 12 criteria verified by execution. 0 not-verifiable. Security review found no critical, high, or medium findings. A run of `setup.ps1` was not made. The PowerShell file parses with 0 errors.

## Skipped phases

None.
