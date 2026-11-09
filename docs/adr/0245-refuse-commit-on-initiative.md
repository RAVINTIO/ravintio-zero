---
title: "ADR 002: reserve-id.mjs refuses --commit on initiative/*"
summary: "The script refuses to commit the counter on an initiative branch and names the feat/ route."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000352-coordinator-admin-in-step-prs"
---
# ADR-0245 - reserve-id.mjs refuses --commit on initiative/*

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Component:** ravintio-zero
**Date:** 2026-11-06

## Context

`--commit` commits `plan/backlog/.next-id` alone on the current branch. On `initiative/*` the commit is direct and untitled, which breaks the rule that nothing commits directly on the initiative branch. Entry 0000332 offered two routes: run it on a `feat/` branch, or make the script refuse.

## Decision

The script refuses. Before the reservation, it reads the branch name through `execFileSync` with an argument array. On a name that starts with `initiative/` it prints one line, exits 1, and changes nothing. The line names the `feat/` route. A run without `--commit` stays allowed, so the coordinator can still reserve an id and commit the counter inside its coordinator PR.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Rely on the skill text only | No script change | A skipped line causes a direct commit | Nothing enforces the rule |
| Have the script switch branches | No refusal | Hidden branch changes in a script | Surprises the caller |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `reserve-id.mjs` and three skills change. |

## Consequences

**Positive:**
- A direct counter commit on the initiative branch cannot happen through the script.
- The change tightens a script and widens no guard.

**Negative:**
- A caller that ran `--commit` on `initiative/*` now fails until it moves to a `feat/` branch.

**Risks:**
- A failed branch lookup. The script then keeps the old behaviour.

## Related ADRs

- ADR-0244 - related

## Supersedes

- None.

## Superseded By

- None.
