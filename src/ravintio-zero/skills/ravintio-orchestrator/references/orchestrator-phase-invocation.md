# Orchestrator reference: phase invocation

> Read this file before you invoke P1, P2, P3, or P4. The orchestrator `SKILL.md` points here from its Pack Index.

## Phase Invocation (P1 to P4)

Conventions for every downstream phase:

- <!-- rule: phase-build-log-first --> **Build log first:** append a `### P<n>: {Phase Name}` block before any phase work (Hard Limit 9).
- <!-- rule: phase-load-skill --> **Load the phase skill before acting.** Read it in full first.
- <!-- rule: phase-commit-artifacts --> **Commit** all new artifacts before presenting the gate summary.
- <!-- rule: phase-push-cadence --> **Push cadence:** after each gate commit, push the feature branch if you hold a remote push grant. A standing override in `ravintio-overrides/instructions/` or a per-session entry in the build log gives that grant. A failed push is an exception stop (see Exception Stops).
- <!-- rule: phase-skills-inbox --> **Skills inbox:** re-check at each transition.
- <!-- rule: phase-run-mode --> **Run mode:** read `plan/.run-mode` at each transition and apply that phase's STOP rule below.
- <!-- rule: phase-run-speed --> **Run speed:** read `plan/.run-speed`. At `fast`, dispatch the phase's fast batch.
- <!-- rule: phase-close-block --> **Close the block:** when a phase completes, read the clock with `date -u +%Y-%m-%dT%H:%M:%SZ`, fill `End` and `Wall clock`, and add a `Complete: P<n> ({time})` line. Never type a time.

| Phase | Invoke | Gate condition | STOP rule |
|-------|--------|----------------|-----------|
| P1 Plan | ravintio-plan | Artifact set complete (requirements, ADRs, OpenAPI where applicable) | Gated: STOP for confirmation. Autonomous: no stop. |
| P2 Implement | ravintio-implement | Implementation matches the spec, and docs land with code | Gated: STOP for confirmation. Autonomous: no stop. |
| P3 Validate and Accept | ravintio-validate-and-accept | CI green plus acceptance evidence | Gated: STOP for acceptance. Autonomous: no stop. The evidence goes in the PR description. |
| P4 Ship | ravintio-ship | Archive, build report, changelog, tag, and PR (or PR description) | Gated: STOP before the PR. Autonomous: no stop. Raise the PR, then end the run. |

<!-- rule: phase-context-size --> **Context size at gates.** At each phase gate in a gated run, state the approximate context size before you ask for approval. The P0 design gate counts, and so do the P1, P2, and P3 gates and the P4 ship gate.

- <!-- rule: phase-context-usage-figure --> Use the usage figure the host reports, such as the context meter in Claude Code.
- <!-- rule: phase-context-estimate --> If the host reports none, give a stated estimate, labelled as an estimate.
- <!-- rule: phase-context-clear --> If the size passes about 150,000 tokens, recommend `/clear` or a new session before the next phase. The `plan/current/` artifacts carry the state, so a clear loses none. Tell the human to start the new session and let Resume Detection continue from the build log.
- <!-- rule: phase-context-advisory --> The statement is advisory. It never blocks, delays, or skips a gate.
- <!-- rule: phase-context-autonomous --> An autonomous run or an initiative step does not report context size. Each initiative step already starts a fresh session.

<!-- rule: phase-before-p2 --> **Before P2:** check the declared stack against installed capability skills and recommend loading relevant ones. Then apply subagent decomposition for every requirement. Consult `## Skill Map` in `design.md` for the best-fit skill, select the model tier, and dispatch per the dispatch standards below.

<!-- rule: phase-after-p4 --> **After P4:** apply the Context Hygiene reset so the next session starts cold.

<!-- rule: phase-merge-human-only --> **Merge is human-only.** Merging into `main` stays human-only in every run mode, and the agent never commits to `main`. The one exception is `gh pr merge --squash` for the agent's own feature PR into `initiative/*`, after a clean P3 and green CI. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

