# Design - 0000395-pack-prose-to-the-standard

## Feature
- Problem: The pack's Markdown breaks the pack's own writing standard in about 2,300 places, and agents copy that style.
- Adoption mode: standard-iterative
- Feature ID: 0000395-pack-prose-to-the-standard
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I run the prose linter over the pack and see no breach, so that consumer repos copy a clean style
  - US-002: As a pack maintainer, I see the baseline drop with each fix, so that new breaches cannot hide behind old ones
- Acceptance criteria confirmed: 3
- Constraints: Meaning and structure stay the same. Only the prose changes. Rule anchors and parsed headings stay intact.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no data classification beyond public repository text
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown and Node.js 20, shell tests, GitHub Actions CI
- Components: `ravintio-zero` - the pack
- Data ownership: `ravintio-zero` owns `plan/state/prose-baseline.json`
- Deployment: none
- API versioning: not applicable

## Component Paths
- ravintio-zero/
- docs/
- plan/state/
- plan/current/
- plan/backlog/
- README.md
- CONTRIBUTING.md
- SECURITY.md
- CODE_OF_CONDUCT.md

## Scope
- In: Rewrite the prose of every Markdown file the linter scans, outside the linter's own skips. Lower the baseline with each batch. Update tests that pin rewritten wording.
- Out: Code, SQL, data values, `plan/_archive/`, `ravintio-zero/tests/`, `CLAUDE.md`, `AGENTS.md`, and the linter rules.
- Deferred: Nothing deferred.

## Assumptions
- Subagents rewrite disjoint file sets in parallel. - impact if wrong: two agents edit one file and one rewrite disappears.
- A file the linter scans has no breach that needs a rule change. - impact if wrong: the step stops with a Blocked line.

## Risks
- A rewrite changes a rule's meaning. Likelihood medium, impact high. The diff review and the suite catch it.
- A rewrite breaks a wording pin in a test. Likelihood high, impact low. The step updates the pin and logs a Rework line.
- A rewrite changes a heading that a script parses. Likelihood low, impact medium. The suite catches it.

## Dependencies
- Upstream: steps 1 to 18 merged, including the linter from step 14 and the rule anchors from step 4.
- Downstream: step 20 moves the pack source to `src/ravintio-zero/` after this step.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - rewrite pack prose | ravintio-implement | Content units dispatched in parallel batches |
| REQ-002 - empty the baseline | ravintio-implement | A script check closes each batch |

## Repo Instructions
Four overrides in `ravintio-overrides/instructions/`: local git only (001), prefer subagent decomposition (002), ship pushes and raises the PR (004), standing setup refresh approval (006).

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: draft-accepted (initiative)
