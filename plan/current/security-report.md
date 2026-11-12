# Security Report - Check every hook after setup

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Version:** 0.110.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review, dependency audit

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `src/ravintio-zero/scripts/hook-check.mjs:91` runs each command from `.claude/settings.json` with `sh -c`. A person who edits that file can run any command. | None. Setup writes the file and the human already trusts it. The check adds no new reach, because Claude Code runs the same commands. | accepted |
| S-002 | low | data-exposure | ravintio-zero | `hook-check.mjs` passes the full process environment to each hook. | None. The hook runs with the environment Claude Code gives it. | accepted |
| S-003 | low | config | ravintio-zero | `initiative-run.mjs` runs `scripts/hook-check.mjs` from the pack folder that setup installed. The driver refuses a symlinked script. | None. The driver applies the same symlink refusal that it applies to `setup.sh`. | mitigated |
| S-004 | informational | injection | ravintio-zero | Sample file paths point at a fresh `mkdtemp` folder outside the project, so a write guard sees no in-project write. Both folders are removed on exit. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | not applicable | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A sample changes repo state | A hook writes to its working directory | ravintio-zero | low | medium | Each hook runs in a temporary directory, and a test compares `git status` before and after | none |
| A missing guard passes as a block | `guard-run.mjs` exits 2 for a missing guard script | ravintio-zero | high | high | Any `[RAVINTIO] guard-run:` stderr line fails the hook, with a test | none |

## Risk register cross-reference

- R-001: mitigated by the temporary directory and the clean-tree test.
- R-002: mitigated by the printed hook, event, and exit code, and by pinned pass codes in the test.
- R-003: accepted, see S-001.
- R-004: mitigated, because a hook with no sample fails.
- R-005: mitigated by the launcher-line rule.

## Recommendations

No critical or high finding is open. Nothing blocks production.
