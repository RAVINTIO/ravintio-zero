---
title: "Backlog Entry: 0000272 - Stop comparing the pack version with the product version"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000272 - Stop comparing the pack version with the product version

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-30

---

## Problem

`ravintio-zero/scripts/resume-detect.mjs` reports `pack version differs from docs/about.md` in a consumer repo on every session start. It compares the pack version in `ravintio-zero/component.yml` with `docs/about.md`. In a consumer repo, `docs/about.md` holds the product's own version.

The `ravintio-docs` repo shows it. The pack is `0.37.0` and the product is `0.4.0`, so the finding never clears.

The pack is a dependency. Its version must never affect the product version, and nothing should compare the two. `ravintio-zero/standards/pack-update-policy.md`, under "Detection signal", item 1, also treats `docs/about.md` as the last recorded pack version.

## Suggested Action

Record the last confirmed pack version in its own place, such as a `plan/state/` file, and compare against that. State in the pack update policy and the `about.md` template that `docs/about.md` holds the product version only.

## Why Deferred

The human found it in the `ravintio-docs` repo during P0 resume detection. The fix belongs in the Zero pack, not in the consumer repo.
