---
title: "Backlog Entry: 0000346 - CodeQL and the P3 review miss incomplete escaping in step PRs"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "high"
theme: "security-checks"
---
# Backlog Entry: 0000346 - CodeQL and the P3 review miss incomplete escaping in step PRs

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** human request
**Date filed:** 2026-11-01

---

## Problem

Step 6 of initiative 0000312 (feature 0000321, PR #96) shipped `backlog-index.mjs` with an escape that handled pipes but not backslashes. A title holding `\|` could break the index table. Two checks missed it:

- **P3 security review.** The checklist in `ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md` names injection points but not incomplete escaping or sanitising. The step 6 security report raised no finding.
- **CodeQL.** The repo uses GitHub default setup, with no workflow in `.github/workflows`. Default setup scans PRs into `main` only. CodeQL raised alert `js/incomplete-sanitization` on PR #101, the initiative PR, not on PR #96 into `initiative/*`.

The fix shipped as fast path 0.48.1 in PR #101. See `plan/changelog/0000321-backlog-triage-2026-11-01.md`.

Related open entry: entry 0000323 covers turning on CodeQL default setup.

## Suggested Action

1. Run CodeQL on PRs into `initiative/*`. Default setup can't target other branches, so this needs advanced setup: a `.github/workflows/codeql.yml` workflow for JavaScript and GitHub Actions, triggered on PRs into `main` and `initiative/**`. Switching to advanced setup turns default setup off, so entry 0000323 should change to match.
2. Add incomplete escaping to the injection points item of the P3 security review checklist. It covers any escape or sanitiser that misses a character, such as a backslash before an escaped pipe, quote, or delimiter.

Tests could check that the workflow names both branch patterns and that the checklist names incomplete escaping.

## Why Deferred

The initiative had delivered when CodeQL raised the alert. The change edits a workflow and a skill, which needs its own step.
