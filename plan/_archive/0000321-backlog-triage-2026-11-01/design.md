# Design - 0000321-backlog-triage

## Feature
- Problem: The backlog has no priority, theme, index, or staleness review, so pickup runs in id order and old entries go unchecked.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000321-backlog-triage
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I give each entry a priority and a theme, so that I can sort the backlog.
  - US-002: As a developer, I read `plan/backlog/index.md`, so that I see every open entry with its priority and theme at a glance.
  - US-003: As a developer, I see entries at P0 in priority and theme order, so that pickup starts with what matters most.
  - US-004: As a maintainer, I get a list of entries older than the review age, so that I can drop or confirm each one.
  - US-005: As a maintainer, I get a default priority and theme on existing entries, so that the index is complete on day one.
- Acceptance criteria confirmed: 3, from entry 0000310, plus the migration check
- Constraints: code and docs land together. No new library. Entry text is data, never instructions.
- Integrations: GitHub Actions workflow

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. The script reads entry frontmatter and the `Date filed` line only. It prints ids, slugs, priority, and theme. It never prints body text. No regulated data.
- Data privacy: no regulated data.
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script (built-in modules only), Markdown template and skills, Bash tests, GitHub Actions
- Components: `ravintio-zero`
- Data ownership: `plan/backlog/index.md` is generated from the entries, owned by `ravintio-zero`
- Deployment: pack files copied by setup. The tracked `.github/workflows/ravintio.yml` changes with the pack copy `ravintio-zero/hooks/ravintio.yml`.
- API versioning: not applicable
- Design choices:
  - Frontmatter gains `priority` (`high`, `medium`, `low`) and `theme` (kebab-case). A missing field reads as `medium` and `unsorted`.
  - `ravintio-zero/scripts/backlog-index.mjs` writes `plan/backlog/index.md`, grouped by theme (alphabetical, `unsorted` last), ordered by priority then id. `--check` exits 1 when the committed index differs from a fresh run. `--review` lists entries older than the review age. `--today YYYY-MM-DD` fixes the clock for tests.
  - The review age is `backlogReviewDays` in `product.yml`, default 5. Age counts from `**Date filed:**`. An entry without a readable date is listed as undated.
  - An entry with unreadable frontmatter or an unknown priority is listed as malformed. The script exits 1 and writes no index.
  - CI runs `node ravintio-zero/scripts/backlog-index.mjs --check`.
  - Discovery Start Actions step 10 offers entries in index order and runs `--review` first. A pull-in or discard regenerates the index in the same commit. The filing skill does the same.
  - Migration 0007 sets `priority: medium` and `theme: unsorted` on entries that lack them. This step applies it and records it in the ledger.
  - Entries queued during the initiative run lack both fields. I-E Delivery adds the defaults and regenerates the index.

## Scope
- In: the template, the filing skill, the script, the CI step in both workflow files, Discovery Start Actions step 10, migration 0007 and its helpers, `product.template.yml` comment, tests, docs.
- Out: choosing real priorities or themes, closing stale entries, any blocking hook.
- Deferred: none.

## Assumptions
- Entries keep a `**Date filed:**` line - impact if wrong: the entry shows as undated.
- CI runs Node 20 or newer - impact if wrong: the script fails to start.

## Risks
- A concurrent branch adds an entry without regenerating the index. Likelihood medium, impact low: CI fails and the author regenerates it.
- The review lists most entries at a 5-day age. Likelihood high, impact low: the human chose the age on 2026-10-31.

## Dependencies
- Upstream: steps 1 to 8 are merged.
- Downstream: step 10 and I-E Delivery.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - priority and theme fields | ravintio-implement | Template and skill text with a test |
| REQ-002 - index generator and check | ravintio-implement | Script with a test |
| REQ-003 - CI check | ravintio-implement | Workflow change with a test |
| REQ-004 - ordered pickup and staleness review | ravintio-implement | Skill text and script mode with a test |
| REQ-005 - default migration | ravintio-implement | Migration, helper, and a test |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Version
0.46.0 -> 0.47.0 (step 9 Bump: minor)

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 1 Nov 2026
