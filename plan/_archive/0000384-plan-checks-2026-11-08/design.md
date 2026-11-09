# Design - 0000384-plan-checks

## Feature
- Problem: Plan-phase gaps surface at P2 or P3 as rework, and ADRs live only in per-feature archives.
- Adoption mode: standard-iterative
- Feature ID: 0000384-plan-checks
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I want the plan check to flag a shell feature that Bash 3.2 lacks, so that P2 does not rework the design.
  - US-002: As an orchestrator, I want the design template to hold `## Component Paths`, so that `gate-write` passes a subagent's first write.
  - US-003: As a dispatching agent, I want the dispatch template to state the 72-character subject limit and the plan to hold a living docs unit, so that no subagent retries a commit and ship writes no living docs.
  - US-004: As a planner, I want the concurrency plan to name shared runtime resources, so that two units with one port or build folder never share a batch.
  - US-005: As a maintainer, I want every ADR in `docs/adr/` under a repo-wide number, so that no archive pass loses a decision and no number repeats.
  - US-006: As an initiative step, I want P1 to read each human-only setting that the chart names, so that a wrong setting blocks before P2.
- Acceptance criteria confirmed: 6
- Constraints: no hook gains an allowed form. Built-ins only.
- Integrations: `gh api` (read-only GET) for US-006.

## Architecture Layer
- Latency target: `consistency-check.mjs` finishes in under 2 s on a 50-file plan
- Availability target: deferred - recorded in scope (no runtime service)
- Scalability target: deferred - recorded in scope
- Security: no auth. `gh api` calls use GET only, against an endpoint allowlist. Data classification: public repo metadata.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ESM (built-ins), Bash, PowerShell twins for migrations, GitHub Actions CI, build target local
- Components: `ravintio-zero` (the pack), the only component
- Data ownership: `ravintio-zero` owns `docs/adr/` and `docs/adr/.next-id`
- Deployment: files in the repo. The installed copy refreshes at the `Setup:` stop.
- API versioning: not applicable

## Component Paths
- ravintio-zero/skills/
- ravintio-zero/templates/
- ravintio-zero/standards/
- ravintio-zero/scripts/
- ravintio-zero/migrations/
- ravintio-zero/tests/
- ravintio-zero/docs/
- ravintio-zero/component.yml
- docs/
- plan/
- .claude/skills/
- src/ravintio-zero/

## Scope
- In:
  - 0000255: the plan skill names the oldest shell for an ADR that picks a shell feature. Check 9 of `consistency-check.mjs` flags a listed Bash 4 feature in an ADR with no oldest-shell line.
  - 0000263: `design.template.md` gains `## Component Paths` above `## Scope`. P0 lists every folder the plan writes. A test proves `gate-write` passes a listed path.
  - 0000333: the dispatch template states the 72-character subject limit. The plan skill adds a living docs unit. Check 10 of `consistency-check.mjs` fails a plan with no unit that writes under `docs/`.
  - 0000347: the concurrency plan gains an optional `Shared resources` column. Check 8 treats a shared resource like a shared write path.
  - 0000280: `docs/adr/` holds every ADR, named `{NNNN}-{slug}.md`, with `docs/adr/.next-id`. The ADR template gains a `component` field. The plan skill reserves numbers and writes to `docs/adr/`. Ship sets status to `accepted` and updates `docs/decisions-index.md`. Migration 0009 moves archived ADRs and restores features 0000001 to 0000029 from git history. The check resolves references in `docs/adr/`.
  - 0000364: the plan skill reads `Human setting:` rows in the chart `## Decisions` table through `ravintio-zero/scripts/human-settings-check.mjs` and prints `Blocked:` before P2 on a mismatch.
- Out: per-component ADR folders. Any hook change. Light discovery (step 11).
- Deferred: refresh of the installed `.claude/skills/` copy happens at the driver `Setup:` stop.

## Assumptions
- Git history holds the ADRs of features 0000001 to 0000029 - impact if wrong: the migration records each missing feature and skips it.
- Number width is four digits (chart decision) - impact if wrong: filenames sort badly past 9999 ADRs.

## Risks
- Migration renumbers 164 or more ADRs and rewrites references: likelihood medium, impact high. Mitigation: dry-run mode, idempotence suite, one commit per phase.
- New check 10 fails existing plan fixtures: likelihood high, impact low. Mitigation: update the fixtures and log `Rework:`.
- Tests pin text in the plan and ship skills: likelihood high, impact low. Mitigation: update pins in the same step.

## Dependencies
- Upstream: step 7 (merged)
- Downstream: step 11 (light discovery), which reads `## Component Paths`
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 shell version check | ravintio-plan | The edit is to the plan skill and its check |
| REQ-002 component paths | ravintio-plan | The design template feeds the plan phase |
| REQ-003 commit limit and living docs unit | ravintio-plan | The edit is to the plan skill and the dispatch standard |
| REQ-004 shared resources | ravintio-plan | The concurrency plan belongs to the plan skill |
| REQ-005 ADRs in docs/adr | ravintio-plan | The plan skill writes ADRs. Ship and the migrator follow. |
| REQ-006 human settings check | ravintio-plan | P1 runs the check |

## Repo Instructions
Git permissions: fetch, pull, push, and `gh pr create` need no ask. Work on a `feat/` branch. Merging into `main` is human-only. Commit granularly after each meaningful artifact write. Standing instruction: prefer parallel subagent decomposition for long tasks.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 08 Nov 2026 @ initiative chart
