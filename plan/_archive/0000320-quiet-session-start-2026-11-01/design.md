# Design - 0000320-quiet-session-start

## Feature
- Problem: The load instruction fires on every prompt, inapplicable migrations appear in every finding, and the prefix check warns about replies that have a prefix.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000320-quiet-session-start
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a developer, I see the load instruction once per session, so that I read it when it matters.
  - US-002: As a developer, I see a migration finding only while it needs action, and I keep finished migrations outside the pack, so that a pack update does not bring one back.
  - US-003: As a developer, I get a prefix warning only when the final reply lacks a prefix, so that I trust the warning.
- Acceptance criteria confirmed: 4, from the three backlog entries
- Constraints: code and docs land together. Hooks stay advisory and exit 0. The step covers migration findings only.
- Integrations: Claude Code hook payloads (`session_id`, `last_assistant_message`)

## Architecture Layer
- Latency target: `resume-detect.mjs` stays inside the 2 second hook limit
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. Hooks print no repo text. No regulated data.
- Data privacy: no regulated data.
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts (built-in modules only), Markdown skills and migrations, Bash tests
- Components: `ravintio-zero`
- Data ownership: `plan/state/migrations.md` (tracked ledger) and `plan/.orchestrator-loaded` (ignored session record), both owned by `ravintio-zero`
- Deployment: pack files copied by setup. The hook adds `plan/.orchestrator-loaded` to `.git/info/exclude`, as `check-reply-prefix.mjs` does for its log. This repo also lists it in `.gitignore`. Setup needs no change.
- API versioning: not applicable
- Design choices:
  - The auto-trigger hook writes the session id to `plan/.orchestrator-loaded` when it emits the instruction. The instruction then fires only when the id differs. With no `session_id`, it fires as today.
  - `check-orchestrator-presence.mjs` shares the rule for its advisory banner.
  - The ledger holds one row per migration: id, result (`done` or `not applicable`), and pack version. The migrator writes it and no longer moves files into `_done/`.
  - A migration file may carry a `**Detect:**` line with path-exists checks, so `resume-detect.mjs` can see a condition turn true. The script only reads.
  - `resume-detect.mjs` reports a migration unless the ledger holds `done`, or `not applicable` at the current pack version with no `Detect:` condition true.
  - Migration 0006 copies the pack's `_done/` records into the ledger. This step applies it to this repo and records it.
  - `check-reply-prefix.mjs` checks `last_assistant_message`. If the field is absent, it checks only an assistant message with no `tool_use` after the last user prompt, rereads the transcript for about one second, then exits silently.

## Scope
- In: the three hooks and script above, the migrator skill, migration 0006 and its helper, the ledger, the `.gitignore` line, tests, docs.
- Out: the pack-version check (entry 0000272), any blocking hook.
- Deferred: none.

## Assumptions
- The host passes `session_id` and `last_assistant_message` - impact if wrong: the hooks fall back to today's behaviour or exit silently.
- The pack version bumps each step in this repo - impact if wrong: none. Each bump makes a `not applicable` row stale, so the finding returns once per release.

## Risks
- A `Detect:` check misreads a path. Likelihood low, impact low: it reports a migration that the migrator then skips.
- Once-per-session hides the reminder after compaction. Likelihood medium, impact low: the entry accepts it, and a new session id restores it.

## Dependencies
- Upstream: steps 1 to 7 are merged.
- Downstream: step 9 and I-E Delivery.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - once-per-session trigger | ravintio-implement | Hook with a test |
| REQ-002 - migration ledger, detect, and reporting | ravintio-implement | Script with a test |
| REQ-003 - migrator skill and migration 0006 | ravintio-implement | Skill text, migration, and a test |
| REQ-004 - final-reply prefix check | ravintio-implement | Hook with a test |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Version
0.45.0 -> 0.46.0 (step 8 Bump: minor)

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 1 Nov 2026
