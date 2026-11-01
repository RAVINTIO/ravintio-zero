# Design - 0000319-initiative-history-checks

## Feature
- Problem: Nothing checks the first-parent titles of an initiative branch, runs CI on direct pushes to it, or flags a squash of an initiative PR on `main`.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000319-initiative-history-checks
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I run a script that lists the first-parent commits of an `initiative/*` branch and fails on an untitled one, so that a direct commit shows before the PR to `main`.
  - US-002: As a reviewer, I see CI run the script on each PR from `initiative/*` to `main`, so that a bad history fails the PR.
  - US-003: As a maintainer, I see I-E Delivery run the script and put the merge commit instruction in the PR title and body top, so that the landing button shows how to merge.
  - US-004: As a maintainer, I see CI run on each push to `initiative/**` while `release-tag` stays on `main` and `master`, so that a direct push runs the suite.
  - US-005: As a maintainer, I see CI fail a push to `main` whose newest commit came from an initiative PR and has one parent, and I find the ruleset setting in the setup docs, so that a squash is flagged at once.
- Acceptance criteria confirmed: 5 stories, from the three backlog entries
- Constraints: code and docs land together. The history script has no exception list. No hook changes.
- Integrations: GitHub Actions

## Architecture Layer
- Latency target: not applicable
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. CI keeps `permissions: contents: read` and adds no token scope. Data classification: no regulated data.
- Data privacy: no regulated data.
- Observability: not applicable
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts (built-in modules only), GitHub Actions YAML, Markdown standards and skills, Bash tests
- Components: `ravintio-zero`
- Data ownership: none
- Deployment: pack files copied by setup. The tracked `.github/workflows/ravintio.yml` changes in the same step as the pack template.
- API versioning: not applicable

## Scope
- In: `check-initiative-history.mjs`, `check-main-merge.mjs`, both workflow copies, I-E Delivery text, the ruleset doc, tests, docs.
- Out: applying the ruleset, hook changes, the driver reporting CI state.
- Deferred: the driver or initiative skill reporting a failed CI run before the next step.

## Assumptions
- GitHub merge commits carry `from {owner}/initiative/...` and squashes carry `(#n)` in the subject - impact if wrong: the main check misses a squash and the ruleset remains the defence.

## Risks
- The main check misdetects an initiative PR. Likelihood medium, impact low: it reads the merge message only, as the chart decided, and the ruleset blocks the squash first.
- The push trigger starts `release-tag` on initiative pushes. Likelihood low, impact high: the job gets an `if` on the ref, and a test pins it.

## Dependencies
- Upstream: steps 1 to 6 are merged. Step 6 requires titled coordinator PRs.
- Downstream: I-E Delivery of this initiative runs the script.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - history script | ravintio-implement | Node script with a test |
| REQ-002 - CI history job and push trigger | ravintio-implement | YAML with a test |
| REQ-003 - delivery check and PR title | ravintio-implement | Standards and skill text with a test |
| REQ-004 - main merge check | ravintio-implement | Node script and YAML with a test |
| REQ-005 - ruleset doc | ravintio-implement | Docs with a test |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Version
0.44.0 -> 0.45.0 (step 7 Bump: minor)

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 1 Nov 2026
