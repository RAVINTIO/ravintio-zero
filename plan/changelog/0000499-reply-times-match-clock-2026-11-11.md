# Changelog (0000499-reply-times-match-clock, 11 Nov 2026)

**Feature:** Reply times match the clock
**Version:** set by the merge queue at merge
**PR:** 186

## What changed

- A new `PostToolUse` hook, `clock-context.mjs`, returns the local `hh:mm` in `additionalContext` after every tool call. `setup.sh` and `setup.ps1` wire it once, and `install-lifecycle.mjs` and `pack-facts.json` list it.
- Rule `reply-time-form` in `roadmap-standards.md` requires every timestamp to come from a clock read at that moment. The initiative `SKILL.md`, `pipeline-reference.md`, and `hook-enforcement.md` say the same.
- `check-reply-prefix.mjs` warns at a gap over 2 minutes, down from 5. It also warns on a status outside the allowed list and logs a `status:` line.
- `initiative-watch.mjs` accepts `RAVINTIO_REPLY_CLOCK`, so a test can fix the time that stamps each line.
- Four new suites, `test-0000499-req-001` to `req-004`, cover the hook, the text, the reply check, and the stamp.
- ADR 0319 records the decision.

## Why

On 2026-11-11 step 27 printed reply times 10 to 13 minutes ahead of the clock and used the status `Running:`. Agents estimate times because a step is one long turn and the Stop hook runs once at its end.

## Deviations

- The watcher already stamped every line with its own clock (0000388). The step adds the test override and a pin, and changes no stamp code.
- `test-0000468-req-001-clock-check.sh` moved its margin cases from 5 to 2 minutes.
- P2 ran inline without subagents, because the units share the clock rule.

## Validation results

- The four new suites pass. Each failed before its change.
- The full suite result is in the verification report.

## Skipped phases

None.
