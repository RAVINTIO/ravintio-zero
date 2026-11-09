---
title: "Scope - GitHub security and CI lint"
summary: "Boundaries of what step 18 delivers."
status: "active"
version: "0.1.0"
---
# Scope - GitHub security and CI lint

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Version:** 0.61.0

## In Scope

- Security and community files under the repo root and `.github/`
- SHA pins for every action in the workflows and the consumer template
- Dependency review and Scorecard workflows
- The `workflow-lint` job and the fixes that make it pass
- The shared brand guard allowlist, the guard script, and the `pre-push` check
- The settings script, its doc, and the human stop

## Out of Scope

- The agent's own GitHub account
- Edits to the `Protect Main Branch` ruleset (the checklist lists the required check for the human)
- Discussions

## Deferred

- Artifact attestations (`actions/attest-build-provenance`). Blocked until `release-tag` publishes an artifact.
