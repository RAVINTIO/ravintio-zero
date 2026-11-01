# Design - 0000327-squash-before-main

## Feature
- Problem: A chore or hotfix branch reaches `main` with every commit it holds, because `main` takes merge commits only and nothing squashes or checks the branch.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000327-squash-before-main
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I want the agent to squash a branch to one commit before it asks me to merge, so that `main` gains one titled commit per chore or hotfix.
  - US-002: As a maintainer, I want only `initiative/*`, `chore/*`, and `hotfix/*` branches to target `main`, so that a feature never skips an initiative.
  - US-003: As a maintainer, I want CI to fail a PR that breaks the rule, so that the rule holds when the agent forgets.
  - US-004: As a maintainer, I want a run outside an initiative to cut a `hotfix/` branch, so that the branch name says it targets `main`.
- Acceptance criteria confirmed: 6, from entry 0000326
- Constraints: code and docs land together. No new library. The force-push permission covers `chore/*` only.
- Integrations: GitHub Actions workflow

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. The script reads git refs and a branch name. The workflow passes the head ref through an environment variable and adds no token scope. No regulated data.
- Data privacy: no regulated data.
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script (built-in modules only), Markdown skills and standards, Bash tests, GitHub Actions
- Components: `ravintio-zero`
- Data ownership: none
- Deployment: pack files copied by setup. The tracked `.github/workflows/ravintio.yml` changes with the pack copy `ravintio-zero/hooks/ravintio.yml`.
- API versioning: not applicable
- Design choices:
  - `ravintio-zero/scripts/check-pr-into-main.mjs --head-ref {name} --base {ref} --head {ref} [--root dir]` exits 1 when the PR breaks the rule and 2 on a usage or git error. A head ref starting `initiative/` exits 0 before any git call. A head ref starting `chore/` or `hotfix/` passes with exactly one commit in `{base}..{head}` and fails with more or none. Any other head ref fails.
  - A new CI job `squash-before-main` runs on `pull_request` with `base_ref == 'main'`. It checks out with `fetch-depth: 0`, `permissions: contents: read`, and passes `github.head_ref` through an environment variable.
  - The ship skill gains a section `## PRs into main`. It limits the PR bases and branch prefixes, tells the agent to squash a `chore/*` branch in place and push with `git push --force-with-lease origin {branch}`, and tells it to build a replacement PR for a `hotfix/*` branch with more than one commit. It never force-pushes `hotfix/*`, `feat/*`, `main`, or `initiative/*`. It waits for green CI on the single-commit head before it asks for the merge. Hard Limit 5 points to the section.
  - The squash commit title follows `commit-standards.md` and names the PR number. The body lists the squashed titles.
  - `roadmap-standards.md` and `docs/main-ruleset.md` name the three branch prefixes that may target `main`.
  - Discovery Start Actions step 2 offers `git checkout -b hotfix/{feature-id}` for a run outside an initiative.

## Scope
- In: the script, the CI job in both workflow files, the ship skill, Discovery Start Actions step 2, the roadmap standards, `docs/main-ruleset.md`, tests, docs.
- Out: any hook, `CLAUDE.md`, `custom-001-local-git-only.md`, applying the GitHub ruleset.
- Deferred: none.

## Assumptions
- Full checkout makes `origin/{head ref}` readable in CI - impact if wrong: the script exits 2 and the job fails closed.
- Human-owned `CLAUDE.md` and `custom-001` still say `feat/` - impact if wrong: none, the build report flags both for the human.

## Risks
- A `chore/*` PR with a merge from `main` inside it counts more than one commit. Likelihood low, impact low: CI fails and the author rebases.
- `--force-with-lease` overwrites a push the agent did not see. Likelihood low, impact low: the lease refuses the push in that case.

## Dependencies
- Upstream: steps 1 to 9 are merged.
- Downstream: I-E Delivery.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - check script | ravintio-implement | Script with a test |
| REQ-002 - CI job | ravintio-implement | Workflow change with a test |
| REQ-003 - ship skill rules | ravintio-implement | Skill text with a test |
| REQ-004 - branch prefixes in standards and ruleset doc | ravintio-implement | Standards text with a test |
| REQ-005 - hotfix cut in Discovery Start Actions | ravintio-implement | Skill text with a test |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Version
0.47.0 -> 0.48.0 (step 10 Bump: minor)

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 1 Nov 2026
