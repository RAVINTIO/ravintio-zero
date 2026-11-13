---
title: "ADR 002: Clean-tree check with no bypass"
summary: "Setup refuses uncommitted pack and override files, and test workspaces commit their pack."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000382-install-lifecycle"
---
# ADR-0329 - Clean-tree check with no bypass

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

Backlog 0000299 asks for a check with no bypass flag. About 90 suites run setup in a temporary workspace that has no commit.

## Decision

Setup runs `git status --porcelain -- ravintio-zero ravintio-overrides` before it changes anything. It fails on any output and on a missing git repo. The check has no flag and no environment switch. A shared helper, `commit_workspace_pack`, makes each test workspace a repo and commits the pack. The update command commits its copied files before it reruns setup.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| An environment switch for tests | No suite changes | A bypass in the shipped script | The entry bans a bypass |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Setup scripts and about 90 suites change |

## Consequences

**Positive:**
- Setup installs only reviewed files.

**Negative:**
- Each test workspace pays for one commit.

**Risks:**
- See the risk register.

## Related ADRs

- ADR-0328 - related-to

## Supersedes

- None

## Superseded By

- None
