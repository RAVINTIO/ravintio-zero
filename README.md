# RAVINTIO Zero

RAVINTIO Zero is a specification-first pipeline for Claude Code. It requires the agent to produce a complete, reviewable execution plan, validated against templates and schemas, before it generates code.

RAVINTIO Zero is distinct from RAVINTIO Framework, the product in the [`ravintio/planifest-framework`](https://github.com/ravintio/planifest-framework) repository. RAVINTIO Zero began as a cut-down copy of that product.

RAVINTIO Zero treats the human as product owner and architect. The agent is the implementer, working within constraints the human sets.

Version `0.5.0` targets Claude Code alone and follows the [Agent Skills specification](https://agentskills.io/specification).

---

## Rationale

Agile prefers iteration over heavy upfront planning. That preference is tuned to a specific bottleneck. When implementation takes weeks, a detailed plan goes stale before it ships, so small reversible steps beat big documents.

Agentic coding tools do not remove that bottleneck. They move it. Implementation is now cheap and fast, so waste shows up earlier. It arrives as plausible-but-wrong output built on unstated assumptions, rather than as a plan that aged out.

RAVINTIO applies agile's own instinct to the new bottleneck. Do not do work that will not survive contact with reality. Three mechanisms follow:

1. **The plan is the reviewable artifact.** When an agent writes the code, the prompt and plan largely determine the output. RAVINTIO makes the plan explicit and reviewable, so architectural choices are visible before code exists.
2. **Context is recorded per component.** Each component keeps a manifest. Each feature keeps its execution plans and ADRs. That gives an agent or a human the context to modify a component, or the specification to rebuild it.
3. **Gaps trigger questions, not guesses.** If the feature brief has gaps, the agent stops and asks rather than filling them with assumptions.

Whether the trade-off pays off depends on the work. See [Limitations](#limitations-and-non-goals).

---

## How it works

The pipeline runs five phases. Every change, however small, takes the same route. A small change is a small run.

1. **The human writes a feature brief.** What to build, why, and within what constraints.
2. **Discovery.** The orchestrator assesses the brief and asks questions until the context is complete.
3. **Plan.** The agent produces requirements, an execution plan, and Architecture Decision Records behind one confirmation gate.
4. **Implement.** Code, tests, and documentation land together.
5. **Validate and accept.** CI checks and a security review run, then the human accepts.
6. **Ship.** The plan is archived, the run is assessed, and the pull request is raised.

Every agent response carries a phase prefix, from `P0 Discovery:` to `P4 Ship:`, so you always know where you are. Every artifact follows a template, so output stays consistent across sessions and models.

To run several features from one approval, chart a roadmap initiative. A driver script runs each step through P0 to P4, and the agent squash-merges each step into the initiative branch. You merge the final initiative PR. See [roadmap-standards.md](ravintio-zero/standards/roadmap-standards.md).

---

## Repository structure

```
repo/
├── ravintio-zero/   ← The pack. Drop in, don't modify per-project.
│   ├── skills/            ← Agent instructions: the 12 pipeline skills
│   ├── templates/         ← File format templates for every artifact
│   ├── schemas/           ← JSON Schema validation definitions
│   ├── standards/         ← Code quality and design standards
│   ├── hooks/             ← Enforcement hooks, git hooks, CI workflow
│   ├── workflows/         ← The feature pipeline route definition
│   ├── scripts/           ← Deterministic tooling
│   └── tests/             ← The pack's own test suite
│
├── plan/                  ← Feature briefs, execution plans, ADRs, risk registers,
│                            and scope docs. Everything describing WHAT to build
│                            and WHY. See plan/feature-structure.md for the layout.
│
├── src/                   ← Component code, tests, config, and manifests.
│                            Each component carries a component.yml.
│
└── docs/                  ← Living documentation: component registry, architecture
                             overview, decisions index, dependency graph. Kept
                             current by the implement phase, read by agents and humans.
```

A typical feature produces five plan-phase artifacts by default: execution plan, requirements, scope, risk register, and domain glossary. OpenAPI spec, cost model, SLO definitions, and operational model arrive only when their trigger condition applies. See [feature-pipeline.md](ravintio-zero/workflows/feature-pipeline.md).

---

## Getting started

See [getting-started.md](ravintio-zero/getting-started.md) for step-by-step setup.

Quick start:

```bash
# macOS or Linux
./ravintio-zero/setup.sh claude-code

# Windows
.\ravintio-zero\setup.ps1 claude-code
```

The setup script copies skills into `.claude/skills/`, prunes retired skills, wires the enforcement hooks and git hooks, and writes the `CLAUDE.md` boot file.

To install for Codex, replace `claude-code` with `codex`. Setup then writes `AGENTS.md`, copies skills into `.agents/skills/`, and wires the `merge-guard` hook in `.codex/hooks.json`. Codex runs no other RAVINTIO hook, so `AGENTS.md` states those rules as instructions. Codex also skips `merge-guard` until you trust it with `/hooks`.

One optional flag:

| Flag | Effect |
|------|--------|
| `--strict-orchestrator` | Writes `plan/.orchestrator-strict`, so the orchestrator must acknowledge each new session before work proceeds. See [strict mode](ravintio-zero/project-operations.md#strict-orchestrator-mode). |

---

## Key principles

**Specification before code.** The agent does not write code until the spec is complete. If the spec has gaps, it stops and asks.

**The human decides, the agent executes.** The human chooses the architecture, the stack, the data ownership, and the scope.

**One route.** Every change is a feature change through the five-phase pipeline. There is no side door for "trivial" fixes, so every diff carries its plan and docs.

**Decompose big initiatives.** Split work into features small enough for one agent session, then group features into waves. That is how RAVINTIO manages context at scale.

**Everything is traced.** Every artifact records the skill that produced it, the tool it ran in, and the model that generated it.

**The PR gate is the backstop.** A human reviews the output before it ships.

---

## The pack

| Folder | Contents |
|--------|----------|
| [skills/](ravintio-zero/skills/) | The 12 pipeline skills: the orchestrator, four phase skills, the TDD trio, and four support skills |
| [templates/](ravintio-zero/templates/) | File format templates for every pipeline artifact, each with a guide where applicable |
| [schemas/](ravintio-zero/schemas/) | Shared type definitions and the domain document envelope |
| [standards/](ravintio-zero/standards/) | Code quality, API design, database, deployment, infrastructure, monorepo, observability, and testing standards |
| [docs/](ravintio-zero/docs/) | Setup docs for settings the human applies outside the repository, such as the `main` ruleset |
| [setup/](ravintio-zero/setup/) | The Claude Code tool config, as a `.sh` and `.ps1` pair |
| [hooks/](ravintio-zero/hooks/) | Enforcement hooks, git hooks, and the CI workflow |
| [workflows/](ravintio-zero/workflows/) | The feature pipeline route definition |
| [scripts/](ravintio-zero/scripts/) | Consistency checks, version derivation, regression promotion, and the initiative driver |
| [tests/](ravintio-zero/tests/) | Per-feature test scripts plus the promoted regression pack |
| [migrations/](ravintio-zero/migrations/) | Pending and completed pack migrations, applied by the `ravintio-migrator` skill |
| [skills-inbox/](ravintio-zero/skills-inbox/) | Drop-in intake for a new capability skill, processed at the next discovery |

---

## Hard limits

These apply regardless of model or configuration:

1. **Requirement gaps are surfaced, then resolved or explicitly deferred, before implementation begins.** Every deferral is recorded in that feature's `plan/current/scope.md`, so the claim is checkable rather than asserted.
2. **No direct schema modification.** A migration proposal is required, and the human approves it.
3. **Destructive schema operations require human approval.**
4. **Data is owned by one component.** Never write to another component's data.
5. **Code and documentation are written together.** Never one without the other.
6. **Credentials are never in the agent's context.** Capabilities only.

---

## Limitations and non-goals

RAVINTIO trades upfront ceremony for traceability. That trade is not always worth making.

- **Overhead is real.** The pipeline scales down for small changes, but never to zero. Prototypes and exploratory work may not repay it.
- **It depends on review discipline.** The PR gate is only a backstop if humans read the plans and the diffs. RAVINTIO structures the review. It cannot perform it.
- **Plans do not prevent all bad output.** A complete specification reduces assumption-driven errors. It does not guarantee correct code.
- **No comparative benchmarks exist.** Nothing here measures outcomes with and without RAVINTIO Zero. Claims about quality rest on design rationale and our own use.
- **It is not a project management method.** RAVINTIO structures agent sessions, not teams.
- **The plan and docs parity check is a presence check.** CI confirms that some file under `plan/`, `docs/`, or a `component.yml` changed alongside `src/`. It does not verify that the file's content corresponds to the code change. Reviewers check that themselves.

---

## Status

RAVINTIO is under active development. Template and skill formats may change between versions.

## Contributing

Issues and pull requests are welcome. Agent skills and templates are the areas most likely to benefit from outside contributions.

---

## Documentation

`planifest-docs` holds the human documentation: architecture notes, research, and the roadmap. Agents do not need these. They work from the skills and templates in `ravintio-zero/`. It is available as a [git repository](https://github.com/ravintio/planifest-docs) and a [GitHub Pages site](https://ravintio.github.io/planifest-docs/).

| Document | Purpose |
|----------|---------|
| [Master Plan](https://github.com/ravintio/planifest-docs/blob/main/planifest-docs/p001-planifest-master-plan.md) | Architecture overview |
| [Product Concept](https://github.com/ravintio/planifest-docs/blob/main/planifest-docs/p002-planifest-product-concept.md) | Vision and commercial model |
| [Functional Decisions](https://github.com/ravintio/planifest-docs/blob/main/planifest-docs/p003-planifest-functional-decisions.md) | Decision log with rationale |
| [Pathway to Agentic Development](https://github.com/ravintio/planifest-docs/blob/main/planifest-docs/p004-the-pathway-to-agentic-development.md) | Background and rationale |
| [Pipeline](https://github.com/ravintio/planifest-docs/blob/main/planifest-docs/p015-planifest-pipeline.md) | Pipeline phase descriptions |
| [Roadmap](https://github.com/ravintio/planifest-docs/blob/main/planifest-docs/p014-planifest-roadmap.md) | Deferred items and future features |

These documents describe an older, multi-tool design of RAVINTIO and do not yet match RAVINTIO Zero.

---

## Licence

[Apache License 2.0](LICENSE.txt), chosen over MIT primarily for its explicit patent grant.
