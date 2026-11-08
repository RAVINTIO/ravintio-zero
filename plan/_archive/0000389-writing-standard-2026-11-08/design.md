# Design - 0000389-writing-standard

## Feature
- Problem: A developer who installs Zero gets no writing standard, and `formatting-standards.md` conflicts with the British Google variant on dates and semicolons.
- Adoption mode: standard-iterative
- Feature ID: 0000389-writing-standard
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a developer who installs Zero, I get `writing-standards.md`, so that my agent writes to one documented standard.
  - US-002: As a maintainer, I see `formatting-standards.md` and `writing-standards.md` agree on dates and semicolons, so that the agent gets no conflicting rule.
  - US-003: As a Claude Code user, I get an output style generated from the standard, so that the main session follows it.
  - US-004: As a Codex user, I get a writing section in `AGENTS.md`, so that Codex follows the standard.
  - US-005: As a developer with my own style, I can skip the install, so that Zero never overrides my choice.
  - US-006: As a maintainer, I see every subagent and step-session brief name the standard, so that output styles reach subagents.
- Acceptance criteria confirmed: 6
- Constraints: setup never overwrites an existing `outputStyle`. The orchestrator skill stays under its size cap.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Setup writes inside the repo only, through the existing atomic settings writer. No credentials.
- Data privacy: no regulated data
- Observability: standard defaults. Setup prints one line per file it writes or leaves.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell, Node (no packages) / pack test suites / GitHub Actions / build target local
- Components: `ravintio-zero` - the pack that holds the standard, the generator, and setup
- Data ownership: `ravintio-zero` owns every pack file and the files setup writes into the target repo
- Deployment: files installed by `setup.sh` and `setup.ps1`
- API versioning: not applicable

## Scope
- In: the standard, a generator script, Claude Code and Codex install, `--no-writing-style`, agreement on dates and semicolons, the `em-dash-guard.mjs` suggestion, the standard named in dispatch and step briefs
- Out: rewriting existing pack prose (step 19), a prose linter (step 14), rewriting archived dates
- Deferred: archetype overrides of the standard (step 15)

## Assumptions
- Claude Code reads project output styles from `.claude/output-styles/` and `outputStyle` from `.claude/settings.json` - impact if wrong: the style installs but the session ignores it. P1 checks the docs.

## Risks
- Pinned tests fail on the `DD MMM YYYY` rule - likelihood medium, impact low. Update the pin in the same step.
- `setup.sh` and `setup.ps1` drift - likelihood medium, impact medium. The parity suite covers it.

## Dependencies
- Upstream: none
- Downstream: step 14 (prose checks), step 15 (archetypes), step 19 (pack prose)
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| US-001 to US-006 | ravintio-implement | Scripts, setup, and standards land with tests |

## Repo Instructions
### Git Permissions
You may fetch, pull, push, and create pull requests (`gh pr create`) without asking each time. Work on a feat/ branch and push it to origin as you commit. In a human session, don't use git worktrees. Stay on a feat/ branch and work directly in the main working tree. The initiative driver may run steps in worktrees under `plan/.initiative-worktrees/`.

Two actions are human-only, with no exception:

- Committing directly to `main`. Every change lands via a feature branch.
- Merging pull requests into `main`. The human on the loop reviews and merges.

One narrow exception: `gh pr merge --squash` for your own feature PR into `initiative/*`, after a clean P3 and green CI. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

Report back if any remote git or GitHub command fails for any reason.

### Commit Granularly, Continuously
Commit locally after every meaningful artifact write — do not batch changes waiting for a phase gate, an approval checkpoint, or task completion. A single requirement doc, ADR, TDD cycle, or config fix is a commit on its own; don't hold it pending a bigger, later commit. Uncommitted work in the working directory is unrecoverable progress — commit early and often so nothing sits unsaved.
---
target: ravintio-orchestrator
---
### Prefer Subagent Decomposition for Longer Tasks
When a task within any phase is long-running or spans multiple independent units of work (multiple requirements, multiple files with no cross-references, multiple independent searches or reviews), look actively for ways to split it into multiple subagents dispatched in parallel rather than working through the units sequentially in one context. This is a standing instruction, not a per-run choice - default to decomposing before defaulting to sequential inline work. The orchestrator's Parallelism Rules and Agent Dispatch Template (and each phase skill's own dispatch checklist) define the mechanics; this override raises the bar for when decomposition is attempted in the first place. If a task genuinely cannot be split (shared mutable state, one unit depends on another's output, or it is too small to justify subagent overhead), state the reason rather than defaulting to sequential work silently.
---
target: ravintio-ship
---
### Ship: push and raise the PR, never merge

In the ship phase, push every change and raise the pull request yourself, without asking. Push the feature branch, then run `gh pr create`. CI tags the merge commit on `main`. In the ship skill's push/PR decision, always take option [1].

Never merge the pull request into `main`, and never push or commit to `main`. Merging into `main` is human-only. The one exception is `gh pr merge --squash` for your own feature PR into `initiative/*`, after validation finished clean and CI is green. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

If a push or `gh pr create` fails, report the exact error and stop. Don't retry with force or merge as a workaround.
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
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 08 Nov 2026 @ 01:15 AM UTC
