# Security Report - Driver runs the approved setup command

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Version:** 0.91.0

> It is advisory. The review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** medium
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | medium | injection | ravintio-zero | `approvedSetup` in `scripts/initiative-run.mjs` runs a command that a chart file names. A bad `Confirmation:` row could name any program | `findSetupCommand` in `scripts/setup-command.mjs` accepts only the pack `setup.sh` path followed by plain words and `--flag` words. The driver runs `bash` with an argument array and no shell. Tests in `test-0000448-req-001` cover `;`, `&&`, `\|`, `$(...)`, `..`, absolute paths, and `setup.ps1` | mitigated |
| S-002 | medium | config | ravintio-zero | The driver runs the `setup.sh` of the merged ref, which a step may have changed. The step PR passed CI and the merge queue, but no human reads the new script before it runs | The human approved the behaviour in the step 28 `## Decisions` row on 2026-11-10. The driver runs the command only when the root holds the merged ref | accepted |
| S-003 | low | config | ravintio-zero | The driver fast-forwards the main working tree when it sits on the initiative branch behind the ref | `git merge --ff-only` changes nothing if the tree has local edits that conflict. The driver then stops with the `Setup:` line | mitigated |
| S-004 | low | injection | ravintio-zero | `isLink` checks only the final path of `setup.sh`, not its parent folders | The path is fixed to the pack folder inside the repo. A symlinked parent needs write access to the root, which the driver already trusts | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | not applicable | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A chart edit runs an arbitrary program | A `Confirmation:` row with another command | ravintio-zero | low | high | Strict command form, no shell, argument array | none |
| A merged step ships a hostile `setup.sh` | A step PR changes `ravintio-zero/setup.sh` | ravintio-zero | low | high | CI, the merge queue, and human review of the initiative PR | The driver runs the script before the human reads it |

## Recommendations

1. Keep the allowed command form narrow. Widen it only with a separate human approval.
2. The human reviews any step that changes `setup.sh` or `setup/` before the initiative PR merges.

## Risk register check

- R-001: mitigated by the strict form and the tests named in S-001.
- R-002: mitigated by the ref check in `approvedSetup`.
- R-003: mitigated. The existing driver suites pass.
- R-004: mitigated. A non-zero exit stops the driver.
