# Design - 0000388-replies-and-questions

## Feature
- Problem: Replies carry no time, the prefix warning confuses the human, and the agent takes vague replies as agreement.
- Adoption mode: standard-iterative (signal: `plan/_archive/` has feature dirs)
- Feature ID: 0000388-replies-and-questions
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a human on the loop, I see `hh:mm` before every reply and driver line, so that I know when each happened.
  - US-002: As a human on the loop, I see a prefix warning that names the check, quotes the reply, and names the session, so that I don't read it as a stopped run.
  - US-003: As a human on the loop, I am asked for "Yes, I agree" and one permission per question, so that the agent acts only on permissions I grant.
  - US-004: As a human on the loop, I get a choice menu for closed decisions and plain text for open questions, so that closed decisions take one click.
- Acceptance criteria confirmed: 10 (see `feature-brief.md`)
- Constraints: the prefix hook never blocks a turn. Orchestrator `SKILL.md` stays at or under 9000 bytes. Rules sit behind rule anchors.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No fail-closed hook widens. Data classification: public repo text.
- Data privacy: no regulated data. The warning quotes at most the first 80 characters of a reply, as the miss log does.
- Observability: the miss log `plan/.prefix-misses.log` stays.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js hooks and scripts. Bash and PowerShell tests. GitHub Actions CI. Build target ci-only.
- Components: `ravintio-zero` (component-pack): hooks, scripts, skills, standards, templates.
- Data ownership: pack files are owned by `ravintio-zero`.
- Deployment: installed by `setup.sh` and `setup.ps1`.
- API versioning: not applicable

## Scope
- In: time in `check-design` and `check-reply-prefix`. Time in driver and watcher lines. The 0000258 warning. Reply Conventions text. The agreement rule. The question rule in the coaching reference.
- Out: the writing standard (0000300). Changes to fail-closed hooks.
- Deferred: the question rule in the writing standard, blocked until step 13 creates it.

## Assumptions
- A step session sets `RAVINTIO_INITIATIVE_STEP=1` and the coordinator does not - impact if wrong: the coordinator warning stays on.
- The driver lock `plan/.initiative-runner.lock` marks "a step runs" - impact if wrong: the skip misfires.

## Risks
- Tests pin the old warning or the old driver lines: likelihood high, impact low. Update pins and log `Rework:`.
- The orchestrator skill nears its 9000 byte cap: likelihood medium, impact medium. Put new text in references.

## Dependencies
- Upstream: none
- Downstream: step 13 adds the question rule to the writing standard.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Time in hooks and driver | ravintio-implement | Code with tests |
| Warning rewrite | ravintio-implement | Hook code with tests |
| Agreement and question rules | ravintio-implement | Skill and reference text with anchored tests |

## Repo Instructions
Git permissions and granular commits. Subagent decomposition. Ship pushes and raises the PR and never merges to `main`. Standing setup refresh approval for the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 07 Nov 2026 @ 10:00 PM UTC
