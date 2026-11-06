# Security Report - Guard gaps closed

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Version:** 0.54.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review of `ravintio-zero/hooks/enforcement/block-forced-add.mjs`, the guard commands and the Codex install in `ravintio-zero/setup.sh` and `ravintio-zero/setup.ps1`, and the two ignore files

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | The forced-add guard reads command text only. A forced add hidden in a script file, an alias, or an encoded string passes the hook. | Keep the CI check on `git ls-files -ci --exclude-standard` as the backstop. | accepted |
| S-002 | low | config | ravintio-zero | The suffix ` || exit 2` needs a POSIX shell. A shell without `||` fails to parse the command, and a parse failure is not exit 2. Claude Code on Windows uses Git Bash, which parses it. | Test a Windows install when one is available. | open |
| S-003 | informational | injection | ravintio-zero | The guard never runs the command text. It splits on separators, parentheses, braces, and backticks, then reads words. Nineteen cases ran, among them `git${IFS}add -f x`, `$(...)`, backticks, `git stage -f`, and a variable flag. Each blocked. A plain add and a commit message with `$` passed. | none | mitigated |
| S-004 | informational | auth | ravintio-zero | A missing `guard-run.mjs` now exits 2 for all eight guard commands, in Claude Code and Codex. Advisory commands keep exit 1 on a missing launcher, which does not block, as intended. | none | mitigated |
| S-005 | informational | config | ravintio-zero | The Codex forced-add command holds the absolute project path in single quotes. `setup.sh` escapes a single quote in the path. `setup.ps1` writes the path in double quotes as it does for `merge-guard`. | none | mitigated |

## Dependency Audit

No dependency added or changed.

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Every guard fails open at once | The launcher file is removed or never installed | Claude Code and Codex hooks | low | high | The suffix turns exit 1 into exit 2 | none |
| A forced add of an ignored file | `git stage -f`, a subshell, or a variable flag | `block-forced-add.mjs` | medium | medium | The widened guard and the CI check | Script files and aliases |
| A damaged install blocks all guarded calls | The launcher is missing | Claude Code and Codex hooks | low | low | The message tells the person to rerun setup | none |

## Risk register cross-check

- R-001: mitigated. The hook filter, hook parity, and setup hardening suites read the suffix.
- R-002: accepted as S-001, with the CI backstop.
- R-003: narrowed. A commit message that holds `$` now passes. `git add "$f"` still blocks.
- R-004: open as S-002.
- R-005: accepted.

## Recommendations

1. Run setup once on a Windows machine with Git Bash and confirm a guarded call blocks with the launcher removed (S-002).
2. Keep the CI ignored-file check (S-001).
