---
title: "Risk Register - initiative history checks"
summary: "Risks for the history checks."
status: "active"
version: "0.45.0"
---
# Risk Register - initiative history checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Version:** 0.45.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The push trigger starts `release-tag` on an initiative push and tags the wrong commit. | low | high | `release-tag` gets an `if` on the ref. A test pins it. | open |
| R-002 | technical | The main check misreads a squash whose title lacks the titled form. | medium | low | The ruleset blocks the squash first. The check is the second defence. | open |
| R-003 | operational | The history script fails an initiative branch that holds an old untitled commit, with no exception list. | medium | medium | `## History check` in `initiative.md` sets the response: list the commits and stop for the human. | open |
| R-004 | technical | A merge of `main` into the initiative branch adds an untitled first-parent commit. | low | medium | The script reports it. The coordinator avoids merging `main` into the branch. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | GitHub writes `Merge pull request #n from owner/initiative/...` for a merge commit and `{title} (#n)` for a squash. | The main check misses a squash. | open |
