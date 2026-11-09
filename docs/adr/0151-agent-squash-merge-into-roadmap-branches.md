---
title: "ADR 003: Agent squash-merge into roadmap branches"
summary: "The agent may run gh pr merge --squash for its own feature PR into roadmap/* after a clean P3 with green CI. merge-guard enforces this. Merging into main stays human-only."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000043-autonomous-roadmaps"
---
# ADR-0151 - Agent squash-merge into roadmap branches

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

The 0000042 run-mode ADR says the agent never merges a pull request and never commits to `main`. That rule holds in every run mode. A roadmap chain breaks against it. Step two builds on step one, so step one must be on the roadmap branch before step two starts. If a human merges every step, the chain stops after each one.

The human asked for this narrow change: the agent may run `gh pr merge --squash` only into `roadmap/*`, only after a clean P3 with green CI, and a hook must enforce it. The human also chose squash merges for steps and a merge commit for the roadmap PR, so each feature keeps one commit on `main`. The human limited merging to `gh`, so no local-git path exists.

This decision amends the merge rule of the 0000042 run-mode ADR. The exception stops in that ADR still apply to every step.

## Decision

**What the agent may do.** The agent may run `gh pr merge --squash` when all of these hold:

- The PR base is a branch that matches `roadmap/*`.
- The PR is the agent's own feature branch for the current step.
- P3 finished clean and CI is green.

**What stays human-only.** Merging into `main`, including the roadmap PR, stays human-only. So does committing to `main`. The roadmap PR body asks for a merge commit.

**Enforcement.** `merge-guard` is a PreToolUse hook on Bash. It inspects every `gh pr merge` command.

- It blocks the command unless the PR base matches `roadmap/*` and the flag is `--squash`.
- It reads the base from the hook input or from `gh pr view`. If it cannot read the base, it blocks. It fails closed.
- It blocks other merge flags, such as `--merge`, `--rebase`, and `--admin`, and any merge with no flag.
- A blocked merge exits 2 with a message that names the base it found, or says it could not read one.

**Order.** The agent waits for green CI, runs the merge, fetches, then tags the squash commit (see ADR-0153).

The credential stop and the other exception stops still halt a step before it merges.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| The human merges every step | Keeps the 0000042 run-mode rule whole. No hook | The chain stops after each step. This breaks autonomy | Fails US-005. The point is a chain that runs without the human |
| A local `git merge` into the roadmap branch | Works with no remote or `gh` | Skips the PR record and CI. Needs a second guard for local merges | The human chose `gh` only. A local path is out of scope |
| Merge commits at both levels | One merge style to explain | Each step adds its branch commits to the roadmap history. `main` gets noise | The human chose squash into `roadmap/*` so each feature keeps one commit |
| A prose rule with no hook | No code to write | An agent error could merge into `main` | The human required hook enforcement. `main` must stay human-only |
| Allow any `roadmap/*` merge flag | Fewer blocked commands | A merge commit lands branch history on the roadmap branch | The design fixes the flag as `--squash` |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Gains `merge-guard`. The orchestrator merge rule, `custom-001-local-git-only.md`, and `custom-004-ship-push-and-raise-pr.md` gain the carve-out text. `setup.sh` and `setup.ps1` register the hook |

## Consequences

**Positive:**
- A step lands on the roadmap branch with no human, so the next step builds on it.
- The hook blocks a wrong-base merge even if the agent misreads a skill.
- The human still reviews and merges everything that reaches `main`.

**Negative:**
- The agent can now merge, so the "never merge" rule has an exception to remember.
- The fail-closed rule blocks a valid merge if `gh pr view` fails, and the human must then act.
- A reader of the 0000042 run-mode ADR must also read this ADR to see the full merge rule.

**Risks:**
- A regex on the command text could miss an unusual form of `gh pr merge`. Unit tests cover quoting, flags, and chained commands.
- Hook input may not include the PR base. Then merge-guard calls `gh pr view`, which adds a network call per merge.
- Without branch protection on `main`, the hook is the only barrier. The test repo enables protection to check both layers.

## Related ADRs

- ADR-0149 - depends-on (the hook is one Node file)
- ADR-0150 - related-to (the roadmap branch holds the active roadmap)
- ADR-0153 - related-to (tag after the squash merge)

## Supersedes

- None. It amends the merge rule of the 0000042 run-mode ADR, which stays accepted.

## Superseded By

- None
