---
title: "Pack Update Policy"
version: "1.0.0"
---
# Pack Update Policy

Canonical definition of how the pipeline detects, confirms, and trusts a `ravintio-zero/` dependency update. This is the document backlog entries mean when they reference "the Pack Update Policy".

---

## What this covers

Distinguishes two cases. In the first, the `ravintio-zero/` folder updates to a newer version. In the second, someone pushes unrecognised code from an unknown source. The two look identical at the file-diff level because both touch files under `ravintio-zero/`. Only the first is a trusted, provenance-tracked update. Treat only the first as trusted without question.

This policy has a different scope from `ravintio-migrator`. That skill owns the narrower "read one pending migration file, present findings, apply confirmed changes, archive it" flow. The orchestrator still invokes it from the same discovery area when a migration file exists. This policy's detection-and-confirmation step runs first and independently, whether or not any migration accompanies the update.

## Where this runs

At the orchestrator's Resume Detection step (`ravintio-orchestrator/SKILL.md`), positioned alongside the existing migration-scan step, before any other discovery work, including ordinary feature-brief coaching Q&A. The orchestrator surfaces it as its own distinct decision. It never applies the update silently and never conflates it with that coaching flow.

## Detection signal

The pipeline detects a candidate `ravintio-zero/` dependency update when either of the following is true:

1. **Version mismatch**: the version declared in the installed `ravintio-zero/component.yml` differs from the version in `plan/state/pack-version.md`. That file holds a fenced `json` block such as `{"packVersion": "0.37.0", "confirmedAt": "2026-11-09T10:00:00Z"}`. If the record is absent, resume detection raises no finding. `docs/about.md` holds the product version only and is never a pack version source.
2. **Newer pack files present**: files under `ravintio-zero/` declare a version newer than the version this repo last ran a pipeline against.

Detection keys on new or changed files under `ravintio-zero/` since the last recorded pipeline run, not solely the version string in isolation. A repo that manually edited `component.yml`'s version field without an actual pack update is a known false-positive risk (ADR-002, Risks). File-level change detection avoids it.

## Human confirmation gate

Detecting a candidate update is not sufficient to treat it as trusted. Every path through this policy terminates in one of two explicit outcomes. There is no implicit pass-through:

- **Explicit confirmation**, or
- **Explicit rejection.**

Confirmation requires the human to affirm both of the following, as two separate facts. A blanket "yes, update it" satisfies neither:

1. **That this is in fact a `ravintio-zero/` update**: as opposed to an arbitrary, unrelated code push that happens to touch the same paths.
2. **Its provenance**: the specific source release, commit, or migration identifier that produced the arriving files. The human must confirm a specific, named origin, not agree that an update is happening.

On confirmation, write `plan/state/pack-version.md` with the current pack version and the time. Record the outcome, confirmed with its stated provenance, or rejected, in `plan/current/build-log.md` before discovery proceeds. If the human rejects it, treat the arriving `ravintio-zero/` files as untrusted. Do not act on them silently, and ask the human how to proceed.

## Relationship to `ravintio-migrator`

Unchanged by this policy. `ravintio-migrator` continues to own reading a single pending migration file, presenting its findings, applying confirmed changes, and archiving it. This policy's detection-and-confirmation step happens first, independent of whether a migration file exists. `ravintio-migrator` may still run afterward for any migration that accompanies the confirmed update.

## Related

- `ravintio-orchestrator/SKILL.md` Resume Detection: the discovery step invoking this policy.
