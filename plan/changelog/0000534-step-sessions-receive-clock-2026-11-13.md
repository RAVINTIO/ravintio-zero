# Changelog (0000534-step-sessions-receive-clock, 13 Nov 2026)

**Feature:** Step sessions receive the clock
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The driver starts every step session with `--include-hook-events`, on a first run and on a resume. The step log now holds a `hook_response` event for each hook that ran, including the clock.
- A new script, `step-clock-check.mjs {log}`, fails a step log that holds tool calls and no `PostToolUse` output with `Local time: hh:mm`. It exits 0 for a log with clock output or no tool calls, and 2 for a usage error.
- The driver header and the "Step logs" section of the roadmap standards state the flag and the check.
- A new suite, `test-0000534-req-001-003-step-clock`, covers the flag, the check, and the text. The shared helper `driver-args.sh` carries the new flag.
- ADR 0342 records the proof run and the decision.

## Why

On 2026-11-11 step 48 wrote the reply time 20:12 while the human read 21:12. The step log held no `Local time:` line, so nothing showed whether the session received the clock hook output. A headless `claude -p` session does receive and read it. The log could not show it because the driver did not record hook events. The machine zone is `Europe/London`, and 20:12 matched the machine clock at 20:12Z. If the human's clock differs from the machine zone, the human sets `TZ` for the driver.

## Deviations

- The three requirements and the ADR share one script and one test file, so the agent ran every unit in one context.
- The step adds no time zone setting. The proof showed no fault in the delivery of the hook output.

## Validation results

See the build log.

## Skipped phases

None.
