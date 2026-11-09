# Design - 0000390-prose-checks

## Feature
- Problem: Only the em dash has a prose check, so sentence length, banned words, semicolons, and passive voice grow unchecked, and nothing reviews changed docs or replies.
- Adoption mode: standard-iterative
- Feature ID: 0000390-prose-checks
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see a script check Markdown and commit messages against the writing standard, so that new breaches fail the check.
  - US-002: As a maintainer, I see old breaches recorded per file, so that only new or raised counts fail and the baseline only shrinks.
  - US-003: As a maintainer, I see the linter run in pre-commit, CI, and `commit-msg`, so that breaches stop at commit time.
  - US-004: As a maintainer, I see a fresh-context subagent review changed user-facing docs at P3, so that the problems a script misses get fixed before ship.
  - US-005: As a developer, I get a short note when a reply drifts from the standard, so that I can see the drift without a block.
- Acceptance criteria confirmed: 6
- Constraints: Node with no packages. Hooks install as one file beside `read-stdin.mjs`. The Stop hook never blocks. No guard changes.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The script reads files and writes only the baseline file. No credentials.
- Data privacy: no regulated data
- Observability: the script prints `file:line rule` for each breach. The Stop hook prints one advisory note.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell, Node (no packages) / pack test suites / GitHub Actions / build target local
- Components: `ravintio-zero` - the pack that holds the rules module, the linter, the hook, the skill text, and setup
- Data ownership: `ravintio-zero` owns every pack file and `plan/state/prose-baseline.json`
- Deployment: files installed by `setup.sh` and `setup.ps1`
- API versioning: not applicable

## Component Paths
- ravintio-zero/
- plan/state/
- docs/
- .github/
- .claude/

## Scope
- In: shared rules module, linter script with `check`, `update`, and `diff`, per-file baseline, pre-commit, CI, and `commit-msg` wiring, P3 edit pass text, advisory Stop hook with setup wiring in both setup scripts, docs
- Out: rewriting existing pack prose (step 19), archetype overrides (step 15), any guard change
- Deferred: baseline path handling for the pack source move (step 20)

## Assumptions
- The passive-voice check is a heuristic - impact if wrong: false positives become baseline entries.
- The `commit-msg` hook can call a Node script, as the attribution check already does - impact if wrong: P1 picks another route.

## Risks
- Baseline paths break when step 20 moves the pack source - likelihood high, impact low. Step 20 reads the note in the build report.
- `setup.sh` and `setup.ps1` drift on the new hook - likelihood medium, impact medium. The parity suites cover it.
- A skill size cap fails on the edit pass text - likelihood medium, impact low. Put the detail in a reference file.
- A commit message check blocks a valid commit - likelihood low, impact medium. Test merge commits and trailers.

## Dependencies
- Upstream: step 13 (writing standard), step 6 (install lifecycle)
- Downstream: step 15 (archetypes), step 19 (pack prose)
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| US-001 to US-005 | ravintio-implement | Scripts, hooks, skill text, and setup land with tests |

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
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 09 Nov 2026 @ 02:57 p.m. UTC
