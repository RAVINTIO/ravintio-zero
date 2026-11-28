---
title: "Backlog Entry: 0000645 - Governed living docs with doc manifests"
summary: "Each file in docs/ has a manifest in docs/manifest/ that fixes its scope and rules. Hooks, a skill, and ship enforce as-is facts in ASD-STE100 Simplified Technical English."
status: "open"
priority: "high"
theme: "documentation"
---
# Backlog Entry: 0000645 - Governed living docs with doc manifests

**Source feature:** 0000644-governed-living-docs

**Source phase:** I-A Chart

**Deferral source:** human request on 2026-11-28, chart of initiative 0000613

**Date filed:** 2026-11-28

---

## Problem

Nothing limits what a file in `docs/` holds. Agents add these things:

- change records, such as `Last updated: {feature-id}` lines and "previously" text
- scope that belongs in another doc, in an ADR, or in `plan/`
- long, wordy prose

No rule says what each doc is for. No check stops a doc from drifting out of date or out of scope. The pack installs the same gap in each consumer repo.

## Wanted outcome

The `docs/` folder holds solution documentation that meets three rules:

1. **Scoped and governed.** Each doc has one manifest that fixes its scope and rules.
2. **Living and as-is.** Each doc states only what is true now. It holds no history and no plans.
3. **Concise.** Each doc uses ASD-STE100 Simplified Technical English: short sentences, one instruction per sentence, active voice, and approved words.

### Doc manifests

- Each file under `docs/` has one manifest at `docs/manifest/{doc-path}.yml`.
- A manifest holds these fields:
  - `doc`: the path of the doc it governs
  - `type`: the Diátaxis type, such as `reference` or `explanation`
  - `scope`: one sentence that says what the doc covers
  - `out_of_scope`: the topics the doc must not hold, and where each topic belongs
  - `sections`: the only headings the doc may have, in order
  - `limits`: the most words, and the most items per list
  - `owner`: the step or skill that keeps the doc current
  - `update_when`: the changes that require an update to the doc
- `docs/manifest/` holds its own manifest schema and a README that lists each doc.

### Enforcement

- **Skill.** A docs skill, or a section in the implement and ship skills, reads the manifest before each doc edit. It refuses an edit outside the doc's scope.
- **Write hook.** A write to `docs/` without a manifest fails. The hook names the missing manifest.
- **Check script.** `docs-check.mjs` runs in pre-commit and CI. It fails a doc on any of these:
  - a heading that the manifest does not list
  - a size limit passed
  - a history marker: a date, a version, a feature or backlog id, or a `Last updated:` line
  - a change word, such as "previously", "no longer", "new", "changed", "since", or "will"
  - an STE rule broken: a procedure sentence over 20 words, a descriptive sentence over 25 words, or passive voice
- **Ship.** Ship lists each doc that the manifest's `update_when` names for the run's changes. Ship fails if the run did not update one of them.
- **Setup.** Setup installs the manifests, the hook, and the check in a consumer repo. It writes a starter manifest for each existing doc.

### Existing docs

The step writes a manifest for each existing doc in `docs/`. It rewrites each doc to pass the check and removes every `Last updated:` line.

### ADRs

`docs/adr/` keeps its ADRs under one manifest of type `decision record`. The as-is rule and the history markers do not apply to an ADR. Each ADR is append-only. A later change adds a `## Revision` section and never rewrites the original text. The human chose this on 2026-11-28 over moving ADRs out of `docs/`.

## Tests

- A doc with no manifest fails the write hook and `docs-check.mjs`.
- A doc with a heading outside its manifest fails the check.
- A doc with `Last updated:`, a date, or a feature id fails the check.
- A procedure sentence of 21 words fails the check.
- A run that changes a hook and leaves `docs/architecture-overview.md` unchanged fails ship, if that doc's `update_when` names hooks.
- Every doc in `docs/` passes the check at the end of the step.

## Why Deferred

The human asked for it on 2026-11-28 during I-A Chart of initiative 0000613. It joins that initiative as step 31, after steps 1 to 30.
