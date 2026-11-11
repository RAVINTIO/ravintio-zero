# Security Report - Reply times match the clock

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Version:** 0.101.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `src/ravintio-zero/hooks/enforcement/clock-context.mjs` reads no stdin and runs no input. It reads `RAVINTIO_REPLY_CLOCK` only through the regex `^([0-2][0-9]):([0-5][0-9])$`. | None. | mitigated |
| S-002 | low | injection | ravintio-zero | `isUnknownStatus` in `check-reply-prefix.mjs` matches reply text with `startsWith` and one fixed regex. It builds no `RegExp`, shell string, or path from the reply. | None. | mitigated |
| S-003 | low | data exposure | ravintio-zero | The hook appends the first 80 characters of a reply with an unknown status to `plan/.prefix-misses.log`. The log is git-ignored through `.git/info/exclude`, and the existing prefix check logs the same snippet. | None. | accepted |
| S-004 | low | configuration | ravintio-zero | `setup.sh` and `setup.ps1` add one `PostToolUse` entry and keep user entries. The entry runs through `guard-run.mjs` in advisory mode, so a launcher failure cannot block a tool call. | None. | mitigated |
| S-005 | informational | availability | ravintio-zero | Both hooks exit 0 in every case. The reply check sits inside the existing `try` block. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | accept-risk |

## Threat Model

The clock hook prints a fixed JSON object with a time. The reply hook reads the final reply as data and writes one log line. No guard widens, and no hook blocks.

## Risk register cross-reference

- R-001 (margin warns after a long tool call): open by design. The hook only warns.
- R-002 (setup drops a user `PostToolUse` entry): mitigated. `test-0000499-req-001-clock-hook.sh` checks that a user entry survives two runs.
- R-003 (`SKILL.md` size cap): mitigated. The orchestrator `SKILL.md` stays unchanged.
- R-004 (one line of context after each tool call): accepted. The line is 22 characters.
