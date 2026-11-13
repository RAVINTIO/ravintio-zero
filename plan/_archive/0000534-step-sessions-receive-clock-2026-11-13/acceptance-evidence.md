# Acceptance evidence - 0000534-step-sessions-receive-clock

## Checks

- The new suite `test-0000534-req-001-003-step-clock.sh` passes: 19 passed, 0 failed.
- Three existing driver suites pinned the argument line. The agent updated the shared helper `driver-args.sh` and one literal in `test-0000444-req-001-003-queue-items.sh`. All three pass.
- The clean-clone run shows 448 feature suites and 19 regression suites passed, with 3 failed. All 3 are on the baseline list.
- `baseline-failures.mjs check` reports 3 `inherited:` suites and no `new:` suite.
- The agent ran 1 self-correction cycle in P2. The new test found the repo root from the source folder only.
- `consistency-check.mjs` reports clean. `archetype-gates.mjs` reports no gates installed.

## Security

- 0 critical or high findings. Overall risk is low (see `plan/current/security-report.md`).

## Execution evidence

- 7 criteria verified by running the driver and the check (see `plan/current/verification-report.md`). 0 are not-verifiable.
- Proof run: a headless `claude -p` session with `--include-hook-events` received `Local time: 04:20` from the `PostToolUse` hook and reported it. `step-clock-check.mjs` passes that log.
- The check fails the real step 48 log: 201 tool calls and no clock output. That log came from a driver that did not pass the flag.
- Driver change: `src/ravintio-zero/scripts/initiative-run.mjs:639`.
- Finding for the human: the machine zone is `Europe/London`. Step 48 wrote 20:12, which was the machine clock at 20:12Z. If the human's clock differs, set `TZ` for the driver (ADR-0342).

## Docs edit pass

- Changed docs: `docs/adr/0342-step-sessions-receive-the-clock.md`, `docs/decisions-index.md`. The standards text in `src/ravintio-zero/standards/roadmap-standards.md` also changed.
- Cycles: 1. A fresh-context reviewer split one long sentence and moved the exit codes into a list. Final `prose-check.mjs` exit code: 0.

## Note for the coordinator

The step changes `initiative-run.mjs`, so the merge triggers a `Restart:` stop. The agent refreshed the installed copy `ravintio-zero/`. A new driver passes the flag, and `step-clock-check.mjs` then passes on the next step log.
