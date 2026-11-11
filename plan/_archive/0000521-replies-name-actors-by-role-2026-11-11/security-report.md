# Security Report - Replies name actors by role

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000521-replies-name-actors-by-role
**Version:** 0.103.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `pronounBreaches` in `src/ravintio-zero/hooks/enforcement/check-reply-writing.mjs` runs two fixed regular expressions over reply text, which is capped at 20000 characters. Neither expression nests a quantifier, so a crafted reply cannot cause catastrophic backtracking. | None. | mitigated |
| S-002 | informational | data exposure | ravintio-zero | The note quotes at most 40 characters of up to 3 sentences, and the quote strips control characters. The hook writes no log file. | None. | mitigated |
| S-003 | informational | permissions | ravintio-zero | The change adds no allowlist entry and widens no guard. The hook never blocks and exits 0 on every input. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | accept-risk |

## Threat Model

The hook reads reply text from its own Stop payload and prints a note. It builds no path, query, or command from the text. The other changes are Markdown and Bash test suites that read files.

## Risk register cross-reference

- R-001 (the hook flags a quoted "I" or "you"): mitigated for code and `>` lines. The hook stays advisory.
- R-002 (the orchestrator skill passes 9000 bytes): mitigated. It holds 8,937 bytes.
- R-003 (a test pins old text): mitigated. The step updated the pins in 0000450 and 0000151, and both pass.
- R-004 (`CLAUDE.md` keeps the old text): open by design. Setup regenerates it after the merge.
