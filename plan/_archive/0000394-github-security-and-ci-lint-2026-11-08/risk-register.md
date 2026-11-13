---
title: "Risk Register - GitHub security and CI lint"
summary: "Risks of the security files, lint job, and brand guard change."
status: "active"
version: "0.1.0"
---
# Risk Register - GitHub security and CI lint

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Version:** 0.61.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The lint job finds an issue only in CI because the tools run locally from a scratch install | medium | medium | Run both tools locally from a temporary install before the push, and allow step CI fixes | open |
| R-002 | operational | The step waits at P3 for the human to change settings | high | low | The stop line names the checklist and the resume command | open |
| R-003 | security | A pinned SHA points at a commit that is not on the tagged release | low | high | Resolve each SHA from the tag through `gh api` and record the tag in a comment | open |
| R-004 | technical | The brand guard flags a consumer repo | low | medium | The guard runs only when `product.yml` declares the id `ravintio-zero` | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Action SHAs resolve through `gh api` | The step stops with the failing action named | open |
| A-002 | `product.yml` id is `ravintio-zero` only in the pack source | The guard runs in a consumer repo | open |
