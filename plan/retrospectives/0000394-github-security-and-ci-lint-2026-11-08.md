---
title: "Retrospective: 2026-11-08 - GitHub security and CI lint"
summary: "A blameless review of a finished run or initiative, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-08 - GitHub security and CI lint

**Mode:** run
**Subject:** 0000394-github-security-and-ci-lint
**Date:** 2026-11-08

## Summary

The step shipped the security files, pinned actions, a workflow lint job, a pre-push brand guard, and a settings checker. Two self-corrections and one human stop marked the run.

## What helped

- A subagent wrote the community files while the main session built the rest (`build-log.md`, P2 block).
- The settings checker showed the human which items were off (`acceptance-evidence.md`, Execution evidence).

## What slowed the work

- The write guard read one path from a two-path line in `design.md` (`build-log.md`, Deviation under P2).
- Three sibling tests scanned the shared allowlist file and broke (`build-log.md`, Rework lines under P2).
- The human stop for GitHub settings held the run for about 453 minutes (`build-log.md`, P3 Question and Resolved lines).

## Keep

- Put the admin-only settings in one checklist with a check command (`ravintio-zero/scripts/github-settings.mjs`).

## Change

- The plan phase does not list tests that read a file the step moves or shares (`build-log.md`, Rework lines under P2).
- The design template does not state that `## Component Paths` takes one path per line (`build-log.md`, Deviation under P2).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Plan phase lists dependent tests for shared files | pack maintainers | `.claude/skills/ravintio-plan/SKILL.md` | review of the next plan | not filed: `reserve-id.mjs` refuses on `initiative/*`. The initiative coordinator files it. |
| State one path per line in the design template | pack maintainers | `ravintio-zero/templates/design.template.md` | template test | not filed, same reason |
