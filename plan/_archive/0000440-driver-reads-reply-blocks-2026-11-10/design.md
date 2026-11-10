# Design - 0000440-driver-reads-reply-blocks

## Feature
- Problem: The driver reads blocks only from the build log. A step that cannot write it gives a `Blocked:` reply the driver never sees. The driver then resumes twice.
- Adoption mode: standard-iterative (only signal: `plan/_archive/` beside source)
- Feature ID: 0000440-driver-reads-reply-blocks
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)
- Track: light (chart accepts it)
- Version: last known 0.77.1, minor bump, the merge queue sets the released version

## Product Layer
- User stories:
  - US-001: As the human on the loop, I want the driver to stop on a reply block, so that a step with no log stops.
  - US-002: As the human on the loop, I want `I-D Advance: Blocked:` to count as a block, so that no resume follows it.
  - US-003: As a step session, I want the continue prompt to skip a missing log, so that I read only files that exist.
- Acceptance criteria confirmed: 3
- Constraints: Node.js with no packages. The driver loads once, so the Restart stop fires after merge.
- Integrations: `claude -p` stream-json output

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Reply text is data. The driver never passes it to a shell or builds a path from it. Stop lines stay under 500 characters.
- Data privacy: no regulated data. Step logs stay private (mode 600).
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ES modules, Bash tests with a stub `claude`, GitHub Actions CI, build target local
- Components: ravintio-zero driver (`ravintio-zero/scripts/initiative-run.mjs`) reads blocks and resumes sessions
- Data ownership: the driver owns `plan/.initiative-logs/`
- Deployment: none, a script in the pack
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/scripts/
- ravintio-zero/scripts/
- src/ravintio-zero/tests/
- ravintio-zero/tests/
- src/ravintio-zero/standards/
- ravintio-zero/standards/
- plan/current/
- plan/backlog/
- plan/changelog/
- docs/

## Scope
- In: read the final `result` text from the step log and apply `blockIn`. Accept a short prefix before `Blocked:`. Name the archived log or none in the continue prompt. Update the roadmap standards to match.
- Out: merge queue, watcher, and ready-file helper changes. Any change to `Resolved:` handling.
- Deferred: nothing deferred.

## Assumptions
- The final `result` event carries the reply in a string field `result` - impact if wrong: the driver misses the block and behaves as today.
- A step log is private to the user - impact if wrong: reply text could be read by another user.

## Risks
- Reply text that quotes an older `Blocked:` line stops a healthy step. Likelihood low, impact medium. Mitigation: read only events written since this session started, and let a later `Resolved:` line clear the block.
- A malformed event line throws. Likelihood low, impact medium. Mitigation: parse each line in a try block.

## Dependencies
- Upstream: none
- Downstream: step 25 (ready file helper) edits the same driver
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - driver-reply-block | ravintio-implement | One script change with tests |

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
### Prefer Subagent Decomposition for Longer Tasks
When a task within any phase is long-running or spans multiple independent units of work, look for ways to split it into parallel subagents. Independent units include multiple requirements, multiple files with no cross-references, and multiple independent searches or reviews. Do not work through the units sequentially in one context. This is a standing instruction, not a per-run choice. Default to decomposing before defaulting to sequential inline work. The orchestrator's Parallelism Rules and Agent Dispatch Template define the mechanics, as does each phase skill's own dispatch checklist. This override raises the bar for when you attempt decomposition at all. If a task genuinely cannot be split, state the reason rather than defaulting to sequential work silently. A task cannot be split in three cases. It has shared mutable state, one unit depends on another's output, or it is too small to justify subagent overhead.

#### custom-004-ship-push-and-raise-pr.md
### Ship: push and raise the PR, never merge

In the ship phase, push every change and raise the pull request yourself, without asking. Push the feature branch, then run `gh pr create`. CI tags the merge commit on `main`. In the ship skill's push/PR decision, always take option [1].

Never merge the pull request into `main`, and never push or commit to `main`. Merging into `main` is human-only. The one exception is `gh pr merge --squash` for your own feature PR into `initiative/*`, after validation finished clean and CI is green. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

If a push or `gh pr create` fails, report the exact error and stop. Don't retry with force or merge as a workaround.

#### custom-006-standing-setup-refresh-approval.md
### Standing approval for the setup refresh

You may run the `ravintio-refresh-setup` skill without asking first, if the command is exactly this:

```bash
ravintio-zero/setup.sh claude-code --strict-orchestrator
```

This approval replaces the skill's Step 4 confirmation for that command only. The human gave it on 2026-10-27, during initiative 0000195 step 13.

If the tool, a flag, or the script differs in any way, ask first, as Step 4 requires. That includes an added flag, a removed flag, and `setup.ps1`. Report the command you ran and its result in your reply.


## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 01:35 PM local
