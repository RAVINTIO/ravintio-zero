# Design - 0000561-old-name-guard-fails-in-full-suite

## Feature
- Problem: `test-0000189-req-007-old-name-guard.sh` fails in some full-suite runs and passes alone, and its hit sits on an allowlisted file.
- Adoption mode: standard-iterative (signal: archive beside source in `plan/_archive/`)
- Feature ID: 0000561-old-name-guard-fails-in-full-suite
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)
- Track: light
- Version: minor bump from 0.143.0, per the chart row. The merge queue sets the released version.

## Product Layer
- User stories:
  - US-001: As a maintainer, I run the full suite, so that the old-name guard gives the result it gives alone.
  - US-002: As a maintainer, I plant the earlier suite's change, so that a test proves the guard ignores it.
- Acceptance criteria confirmed: 4
- Constraints: the allowlist keeps its current entries. The old-name pattern and the planted-name checks keep their rules.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth change. No credentials involved. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash test suites, Node scripts, no new libraries. Build target: local.
- Components: `ravintio-zero` (the pack). The change sits in its test tree.
- Data ownership: the pack owns no data.
- Deployment: none. The pack ships as files.
- API versioning: not applicable
- Approach: reproduce the failure first. Then make the guard read a stable copy of the tree, or fix the earlier suite that changes it. Add a test that plants that suite's change.

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: find the cause, stabilise the guard input, add the planted-change test, and update docs and pins that name the guard.
- Out: any change to the allowlist, the old-name pattern, or the planted-name rule.
- Deferred: nothing deferred.

## Assumptions
- An earlier suite changes a tracked file or the working folder before the guard runs - impact if wrong: reproduction finds another cause. The fix then targets it.
- The guard may read `HEAD` or a copy of the tree - impact if wrong: a temporary repo with staged files needs the index mode.

## Risks
- A fix that reads `HEAD` misses an uncommitted old name. Likelihood: medium. Impact: low, because CI reads committed files.
- The failure resists reproduction. Likelihood: medium. Impact: medium, because the fix then rests on the log evidence of steps 4, 47, and 51.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - stable-guard-input | ravintio-implement | One guard change with a test. |

## Repo Instructions

#### custom-001-local-git-only.md
### Git Permissions
You may fetch, pull, push, and create pull requests (`gh pr create`) without asking each time. Work on a feat/ branch and push it to origin as you commit. In a human session, don't use git worktrees. Stay on a feat/ branch and work directly in the main working tree. The initiative driver may run steps in worktrees under `plan/.initiative-worktrees/`.

Two actions are human-only, with no exception:

- Committing directly to `main`. Every change lands via a feature branch.
- Merging pull requests into `main`. The human on the loop reviews and merges.

One narrow exception: `gh pr merge --squash` for your own feature PR into `initiative/*`, after a clean P3 and green CI. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

Report back if any remote git or GitHub command fails for any reason.

### Commit Granularly, Continuously
Commit locally after every meaningful artifact write. Do not batch changes while you wait for a phase gate, an approval checkpoint, or task completion. A single requirement doc, ADR, TDD cycle, or config fix is a commit on its own. Don't hold it pending a bigger, later commit. Uncommitted work in the working directory is unrecoverable progress, so commit early and often and leave nothing unsaved.

#### custom-002-prefer-subagent-decomposition.md
---
target: ravintio-orchestrator
---
### Prefer Subagent Decomposition for Longer Tasks
When a task within any phase is long-running or spans multiple independent units of work, look for ways to split it into parallel subagents. Independent units include multiple requirements, multiple files with no cross-references, and multiple independent searches or reviews. Do not work through the units sequentially in one context. This is a standing instruction, not a per-run choice. Default to decomposing before defaulting to sequential inline work. The orchestrator's Parallelism Rules and Agent Dispatch Template define the mechanics, as does each phase skill's own dispatch checklist. This override raises the bar for when you attempt decomposition at all. If a task genuinely cannot be split, state the reason rather than defaulting to sequential work silently. A task cannot be split in three cases. It has shared mutable state, one unit depends on another's output, or it is too small to justify subagent overhead.

#### custom-004-ship-push-and-raise-pr.md
---
target: ravintio-ship
---
### Ship: push and raise the PR, never merge

In the ship phase, push every change and raise the pull request yourself, without asking. Push the feature branch, then run `gh pr create`. CI tags the merge commit on `main`. In the ship skill's push/PR decision, always take option [1].

Never merge the pull request into `main`, and never push or commit to `main`. Merging into `main` is human-only. The one exception is `gh pr merge --squash` for your own feature PR into `initiative/*`, after validation finished clean and CI is green. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

If a push or `gh pr create` fails, report the exact error and stop. Don't retry with force or merge as a workaround.

#### custom-006-standing-setup-refresh-approval.md
---
target: ravintio-refresh-setup
---
### Standing approval for the setup refresh

You may run the `ravintio-refresh-setup` skill without asking first, if the command is exactly this:

```bash
ravintio-zero/setup.sh claude-code --strict-orchestrator
```

This approval replaces the skill's Step 4 confirmation for that command only. The human gave it on 2026-10-27, during initiative 0000195 step 13.

If the tool, a flag, or the script differs in any way, ask first, as Step 4 requires. That includes an added flag, a removed flag, and `setup.ps1`. Report the command you ran and its result in your reply.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 18 Nov 2026 @ 07:52 AM GMT
