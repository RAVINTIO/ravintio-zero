# Security Report - Parallel steps reserve distinct ids

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Version:** 0.92.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `src/ravintio-zero/scripts/id-collisions.mjs` builds a `RegExp` from an ADR slug. The code escapes the slug with `escapeRe`, and the slug comes from a tracked file name that the PR author controls. | None. The escape covers every regex metacharacter. | mitigated |
| S-002 | low | config | ravintio-zero | `writeCounter` in `id-collisions.mjs` writes `docs/adr/.next-id` and `plan/backlog/.next-id` with no symlink check, while `rewrite` skips symlinks. A PR could track a counter as a symlink. | Match `reserve-id.mjs` and refuse a symlinked counter. Low impact, because the queue runs on branches that the maintainers review. | open |
| S-003 | informational | injection | ravintio-zero | Every git call in `id-collisions.mjs` and the new `renumberIds` in `merge-queue.mjs` passes an argument array. No shell string is built from file text. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | accept-risk |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A crafted file name rewrites an unrelated file | A PR adds `docs/adr/0301-x.md` with a slug that matches other text | ravintio-zero | low | low | The module rewrites only lines that the PR added, plus the renamed file | None found |
| A path escapes the repo | A tracked name holds `..` | ravintio-zero | low | medium | `git ls-files` returns repo-relative names and the ADR and backlog patterns exclude `/` in the slug | None found |

## Recommendations

1. Refuse a symlinked counter in `writeCounter` (S-002). Not blocking.
