---
title: "ADR 003: One attribution check serves ship and CI"
summary: "A single script holds the attribution patterns for PR bodies. Ship and CI both run it, and the commit-msg hook gains the host-line patterns."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000169-release-hygiene"
---
# ADR-0175 - One attribution check serves ship and CI

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The `commit-msg` hook checks commits. Nothing checks a PR description. The host adds lines such as `Generated with [Claude Code]` and a `Claude-Session:` link, which the hook does not match.

## Decision

`ravintio-zero/scripts/check-attribution.mjs` reads a file or stdin and exits 1 on an attribution line.

- Its patterns are the hook's Rule 1 patterns plus the host lines.
- It prints the line number and rule only, never the text.
- Ship runs it on the PR body before `gh pr create`.
- The `validate-branch` job runs it on the PR description. The body arrives through `env:` and a file, never inside `run:`.
- The hook keeps its own list in Bash and gains the host-line patterns. A test checks that both lists hold the host lines.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Reuse the `commit-msg` hook on the PR body | No new script | Its subject and affirmatory rules misfire on a body | Wrong rules for a body |
| Have the hook call the script | One pattern list | Adds a Node.js start to every commit | The hook stays fast and Bash-only |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, hook patterns, ship Step 9, both workflow files |

## Consequences

**Positive:**
- A PR body faces the same ban as a commit, in ship and in CI.

**Negative:**
- Two pattern lists exist, held in step by a test.

**Risks:**
- A PR that quotes an attribution line fails CI. The author rewords it.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
