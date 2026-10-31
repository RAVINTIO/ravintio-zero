---
title: "ADR 001: Block forced adds with a guard and a CI check"
summary: "A Bash guard plus a CI check stop ignored files reaching a commit."
status: "active"
version: "0.43.0"
---
# ADR-001 - Block forced adds with a guard and a CI check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Component:** ravintio-zero
**Date:** 2026-10-31

## Context

`git add -f plan` committed driver files in initiative 0000238. No rule forbade it. Most driver paths sit only in `.git/info/exclude`, so a fresh clone and CI do not see them as ignored.

## Decision

Add a Bash guard, `block-forced-add.mjs`, wired through `guard-run.mjs guard`. List the driver paths in the tracked `.gitignore`. Run `git ls-files -ci --exclude-standard` in ship and in CI. Add the rule to the orchestrator skill.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Rule text only | No code | A step can forget it | Does not enforce |
| CI check only | Catches every route | Finds the file after the push is denied | Late |
| Pre-commit hook | Catches every route locally | Does not run for the pack's agent hooks model and is bypassable | Weaker than a guard |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new hook, both setup scripts, `.gitignore`, two workflows, two skills, tests |

## Consequences

**Positive:**
- A forced add stops before it runs.
- CI catches any other route.

**Negative:**
- A command that only mentions `git add -f` in text is blocked.
- A tracked file that matches an ignore rule on purpose needs a negation rule.

**Risks:**
- The guard misses an unusual form. The CI check covers it.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
