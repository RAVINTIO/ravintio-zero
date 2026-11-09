---
title: "ADR 001: RAVINTIO rename map"
summary: "Every brand word, path, identifier, and variable moves from planifest to ravintio under one map. Prose writes RAVINTIO in block caps. Identifiers use lowercase. History folders stay as written."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000160-ravintio-rebrand"
---
# ADR-0164 - RAVINTIO rename map

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Component:** ravintio-zero
**Date:** 2026-10-24

## Context

The product joins the RAVINTIO ecosystem. Every path, name, and doc still says Planifest. A discovery pass on 2026-10-24 found 295 tracked files with the old word on 1,743 lines. The scope excludes `plan/_archive/` and `plan/changelog/`. The pack folder holds 327 files, and 158 test files carry the old word in their names.

ADR-0109 set the folder name `planifest-zero/` and the product id. Those names now change. The rename needs one map so that every file uses the same new name.

## Decision

The brand word changes everywhere outside history. The writing rule depends on where the word appears.

- Prose writes RAVINTIO in block caps: "RAVINTIO Zero" and "RAVINTIO Framework".
- Identifiers use lowercase `ravintio`. These are paths, skill names, file names, and ids.
- Environment variables use the `RAVINTIO_` prefix.
- OTEL labels use the `ravintio.` prefix.
- `plan/_archive/`, `plan/changelog/`, and `ravintio-zero/migrations/_done/` stay as written.

### Rename map

| Old | New |
|-----|-----|
| `planifest-zero/` | `ravintio-zero/` |
| `planifest-overrides/` | `ravintio-overrides/` |
| `planifest-*` skills | `ravintio-*` skills |
| `.github/workflows/planifest.yml`, `hooks/planifest.yml` | `ravintio.yml` |
| `refresh-planifest-zero-dir.ps1` | `refresh-ravintio-zero-dir.ps1` |
| `.planifest-setup-flags`, `.planifest-manifest`, `.planifest-session`, `.planifest-tmp` | `.ravintio-*` |
| `planifest-overrides:instructions` markers | `ravintio-overrides:instructions` |
| `planifest-em-dash-allow` | `ravintio-em-dash-allow`, with the old sentinel still accepted in 1.x |
| `PLANIFEST_*` | `RAVINTIO_*`. `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS` stay as fallbacks in 1.x |
| `planifest.roadmap`, `planifest.step` OTEL labels | `ravintio.roadmap`, `ravintio.step` |
| `product.yml` and `component.yml` id `planifest-zero` | `ravintio-zero` |
| Test files named `*planifest*` | `*ravintio*` |
| `github.com/planifest/...`, `planifest.github.io/...` | `github.com/ravintio/...`, `ravintio.github.io/...` |

### Rules for applying the map

- Each token changes in its own pass, and each pass uses a byte-exact tool. A blanket replace can corrupt files such as the mojibake sequence in `setup.ps1`.
- A rename and every reference to it change in the same commit.
- The sibling repos keep their names. The local clone folder is out of scope.
- The org rename and the repo rename happen after the human merges the pull request. Links to the new org fail until the org rename lands.
- The release is version 1.0.0, because the rename breaks consumer paths.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Rename prose only and keep identifiers | No consumer migration | The brand and the paths disagree. Readers see two names | The human wants paths to match the brand |
| Use "Ravintio" in prose | Reads as a normal word | Differs from the strategy document, which uses block caps | The brand is RAVINTIO in block caps |
| Rename in a 0.x release | Smaller version jump | Hides a breaking change behind a minor number | Consumer paths break, so the major version must change |
| Keep a `planifest-zero/` symlink | Old paths keep working | Setup refuses symlinks, and two names confuse readers | Adds a second name to maintain |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Renamed from `planifest-zero`. Every file under it changes where it holds the old word |

## Consequences

**Positive:**
- Paths, skills, and prose all use one brand name.
- A single map lets a reviewer check any rename against one table.

**Negative:**
- Every consumer must run a migration and update links.
- Old URLs break until the org rename lands.

**Risks:**
- A replace pass corrupts a file. Per-token passes and a full run of every suite on all three shells reduce this risk.

## Related ADRs

- ADR-0165 - related-to: the environment variable fallbacks
- ADR-0166 - related-to: the consumer migration
- ADR-0167 - related-to: the guard test that enforces this map

## Supersedes

- ADR-0109 (folder rename and product identity), in part. The folder name `planifest-zero/` and the product id `planifest-zero` change. The `refresh` script deriving its own path stands.

## Superseded By

- None
