# Design - 0000386-unit-dispatch

## Feature
- Problem: small content units cost three subagents each and log a departure when run inline. Dispatch picks one model tier per phase, with no effort level and no per-unit class.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000386-unit-dispatch
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a pipeline maintainer, I run a small content unit inline with RED before GREEN, so that the build log shows no departure.
  - US-002: As a pipeline maintainer, I see a class, tier, and effort on every `Done:` line, so that dispatch follows one rule.
  - US-003: As a pipeline maintainer, I read rework by class and tier, so that I can tune the table from evidence.
- Acceptance criteria confirmed: 5
  - AC-1: `ravintio-implement` names the inline unit rule: a unit that applies agreed text or changes one file.
  - AC-2: An inline unit logs `RED:` before `GREEN:`. `build-log-check.mjs` accepts it, and reports a `GREEN:` marker with no earlier `RED:`.
  - AC-3: A unit that misses the rule still runs the test-writer, implementer, and refactor subagents.
  - AC-4: `agent-dispatch-standards.md` maps class and signals to tier and effort. `Done:` lines carry `{class}, {tier}, {effort}`, and `resume-detect.mjs` still matches them.
  - AC-5: `workflow-metrics.mjs` reports units and rework by class and tier.
- Constraints: classes are `content`, `code`, `test`, and `config`. An inline unit is class `content`. The two-failure retry on the primary tier stays.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: not applicable
- Scalability target: not applicable
- Security: no new input surface. The scripts read the build log as data.
- Data privacy: no regulated data
- Observability: the `Done:` line and the metrics report
- Cost boundary: not constrained. The table lowers cost for small units.

## Engineering Layer
- Stack: Node.js scripts, bash tests, Markdown skills and standards
- Components: `ravintio-zero`, the pack that holds the skills, standards, scripts, and tests
- Data ownership: `ravintio-zero` owns every file it changes
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`. The step changes skills, so the driver takes a `Setup:` stop after the merge.
- API versioning: not applicable

## Component Paths
- ravintio-zero/skills/
- ravintio-zero/standards/
- ravintio-zero/scripts/
- ravintio-zero/templates/
- ravintio-zero/tests/
- docs/
- plan/

## Scope
- In: inline unit rule, `RED:` and `GREEN:` markers, the `build-log-check.mjs` check, the class, tier, and effort table, the extended `Done:` line, and the `workflow-metrics.mjs` section.
- Out: a separate classifier skill, a human override of a tier at the design gate, and Langfuse evaluation (0000254).
- Deferred: tuning the table from metrics. Later runs do it.

## Assumptions
- The Agent tool accepts an `effort` value on Claude Code. Impact if wrong: the dispatch omits it and the table still records it.
- The only readers of the `Done:` line are `resume-detect.mjs`, `build-log-check.mjs`, and `workflow-metrics.mjs`. Impact if wrong: a reader breaks on the new fields. Tests cover the three.

## Risks
- Low likelihood, medium impact: the longer `Done:` line breaks resume matching. A test pins the match on the unit name.
- Medium likelihood, low impact: the first table values are wrong. The metrics report shows it, and a later run tunes them.

## Dependencies
- Upstream: 0000043 progress markers, 0000173 workflow metrics, 0000385 test runs
- Downstream: every later step that dispatches units
- Approved dependencies: none

## Version
- Bump: minor, from 0.70.0 as charted. The merge queue sets the released version.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - inline unit rule | ravintio-implement | Skill and standards text, one marker check |
| REQ-002 - class, tier, effort table | ravintio-implement | Standards text, template, and resume check |
| REQ-003 - metrics by class and tier | ravintio-implement | One script and its test |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: split independent units into parallel subagents, or state why not.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 09 Nov 2026 @ 02:56 p.m. GMT. Recorded as draft-accepted (initiative) from the chart of initiative 0000360. [source: draft-accepted (initiative)]
