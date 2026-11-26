# RAVINTIO Zero - Mandatory Pipeline Rules

This project uses RAVINTIO Zero, a confirmed-design pipeline. These rules are non-negotiable and apply to every session.

## Hard Limits

1. **No code without a confirmed design.** You MUST NOT generate application code unless a confirmed design exists at plan/current/design.md. If none exists, load the ravintio-orchestrator skill and begin the discovery phase (P0). Do NOT skip to code generation.
2. **No code without documentation.** Every component MUST have a component.yml manifest and docs/ artifacts. Never produce code without its corresponding documentation.
3. **No direct schema modification.** Write a migration proposal at src/{component-id}/docs/migrations/proposed-{desc}.md and STOP for human approval.
4. **Destructive schema operations require human approval.** Drop column, drop table, rename - propose and stop. No exceptions.
5. **One component owns each piece of data.** Never write to data owned by another component.
6. **No credentials in context.** If a credential appears anywhere, flag it immediately and do not use it.
7. **Update documentation after any deviation.** If implementation deviated from the spec, plan, or design decisions, you MUST update the affected artifacts (plan/, docs/, or component.yml). They must reflect what you actually built. Documentation must always match reality.

## Operational Directives

- **Be succinct:** Minimal prose. Format answers in markdown with brevity.
- **Commit messages and PR descriptions:** Never add `Co-Authored-By`, `Generated with [Claude Code]`, `Claude-Session:`, or any AI attribution. The `commit-msg` hook is **blocking**: it rejects AI attribution, affirmatory language, and >72-char subjects. Follow `ravintio-zero/standards/commit-standards.md`.
- **Do not invent APIs:** Only call endpoints that explicitly exist in the provided OpenAPI interfaces.

## Hook Enforcement

Codex runs fewer RAVINTIO hooks than Claude Code. You enforce the other rules yourself. Read `ravintio-zero/standards/hook-enforcement.md` for the active and fallback hooks.

Project hooks run only after a person trusts them. Run `/hooks` in Codex to trust the RAVINTIO hook. Never run a pull request merge command against `main` yourself.

## Reply Conventions

Begin every reply in an active run with the time and a prefix. Use the form `hh:mm {prefix} {Status}: {one-liner}`. Take the time from `date +%H:%M`. The status is Starting, Resuming, Complete, Question, Blocked, or Skipped.

| Prefix | Use for |
|--------|---------|
| `P0 Discovery:` | Discovery |
| `P1 Plan:` | Plan |
| `P2 Implement:` | Implement |
| `P3 Validate:` | Validate and accept |
| `P4 Ship:` | Ship |
| `I-A Chart:` | Initiative chart stage |
| `I-B Activate:` | Initiative activate stage |
| `I-C Run:` | Initiative run stage |
| `I-D Advance:` | Initiative advance stage |
| `I-E Delivery:` | Initiative delivery stage |

Use `Supervise:` for out-of-phase work. Examples are supervising an initiative driver, filing backlog entries, and answering questions while another session runs a step. It takes the same status form, as in `Supervise: Complete: {one-liner}`.

**Reporting rule.** A reply reports results, deviations, failures, and decisions the human must make. A reply never states that the agent followed a standing rule. The exception is a rule that blocked an action or a rule the agent departed from.

**Actor names.** A reply names each actor by role, such as "the human", "the agent", or "step 45". A reply never uses "I" or "you".

## Worktrees

A human session works on a `feat/` branch in the main working tree and creates no worktrees. The initiative driver may run steps in worktrees under `plan/.initiative-worktrees/`.

## Escalation

If anything blocks you, you cannot resolve tests after 5 attempts, or conflicting requirements confuse you, **STOP**. Do not guess. State clearly what is blocking you and ask the human for direction.

<!-- ravintio-overrides:instructions:start -->

### Git Permissions
You may fetch, pull, push, and create pull requests (`gh pr create`) without asking each time. Work on a feat/ branch and push it to origin as you commit. In a human session, don't use git worktrees. Stay on a feat/ branch and work directly in the main working tree. The initiative driver may run steps in worktrees under `plan/.initiative-worktrees/`.

Two actions are human-only, with no exception:

- Committing directly to `main`. Every change lands via a feature branch.
- Merging pull requests into `main`. The human on the loop reviews and merges.

One narrow exception: `gh pr merge --squash` for your own feature PR into `initiative/*`, after a clean P3 and green CI. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

Report back if any remote git or GitHub command fails for any reason.

### Commit Granularly, Continuously
Commit locally after every meaningful artifact write. Do not batch changes while you wait for a phase gate, an approval checkpoint, or task completion. A single requirement doc, ADR, TDD cycle, or config fix is a commit on its own. Don't hold it pending a bigger, later commit. Uncommitted work in the working directory is unrecoverable progress, so commit early and often and leave nothing unsaved.

### Test Override
OVERRIDE-MARKER-0000029

<!-- ravintio-overrides:instructions:end -->

<!-- ravintio-writing:start -->
## Writing standard

- Lead with the answer. Use second person, active voice, and one idea per sentence.
- Keep every sentence under 25 words. Aim for an average near 15.
- Use British English spelling, except in code identifiers, API names, and quoted output.
- Do not use em dashes or semicolons. Use no exclamation marks.
- Write dates as 2026-08-18 or "August 18, 2026".
- Never write `simple`, `simply`, `easy`, `just`, or `obviously`.
- Use "allowlist" and "blocklist". Cut ableist wording and violent metaphors.

Read `ravintio-zero/standards/writing-standards.md` for the full rules.
<!-- ravintio-writing:end -->
