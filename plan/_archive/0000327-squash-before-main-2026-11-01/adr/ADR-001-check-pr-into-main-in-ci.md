---
title: "ADR 001: CI checks the branch and commit count of a PR into main"
summary: "A script that CI runs on every PR into main enforces the prefix and single-commit rule."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - CI checks the branch and commit count of a PR into main

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Component:** ravintio-zero
**Date:** 2026-11-01

## Context

`main` accepts merge commits only. A chore branch with several commits adds each one to the history of `main`. Skill text asks the agent to squash first, but a human can raise a PR by hand and an agent can forget.

## Decision

Add `ravintio-zero/scripts/check-pr-into-main.mjs` and a CI job `squash-before-main` on every PR into `main`. The script ignores `initiative/*`, passes a `chore/*` or `hotfix/*` PR with one commit, and fails everything else. The ship skill limits `--force-with-lease` to `chore/*` and uses a replacement PR for `hotfix/*`. No hook changes, because no hook blocks a force-push today.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A hook that blocks a PR with several commits | Stops it before CI | Widens a fail-closed hook family and needs the PR count at call time | Entry asks for a CI check |
| Skill text only | No script | Nothing catches a PR raised by hand | Fails the wanted outcome |
| Squash-merge on the ruleset | No agent step | Drops step tags for initiative PRs, so `main` takes merge commits only | Contradicts `docs/main-ruleset.md` |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, CI job in two workflow files, ship skill section, standards text |

## Consequences

**Positive:**
- Each chore or hotfix adds one titled commit under its merge commit.
- A feature branch cannot skip an initiative.

**Negative:**
- A chore author must squash and force-push before merge.
- The force-push limit rests on skill text, and CI checks only the result.
