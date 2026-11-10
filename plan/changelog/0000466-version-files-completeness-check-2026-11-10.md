# Changelog (0000466-version-files-completeness-check, 10 Nov 2026)

**Feature:** Version files completeness check
**Version:** set by the merge queue at merge
**PR:** 170

## What changed

- `test-0000466-req-001-version-list-complete.sh` lists the tracked files that carry the product version. It fails and names each one that `version-files.txt` omits.
- A tracked `docs/about.md`, `product.yml`, or `component.yml` counts, as does any other `.md` or `.yml` file whose own `version:` line equals the product version. Files under `plan/`, `docs/adr/`, and `fixtures/` do not count.
- The same test fails and names a required list entry whose file does not exist. An optional entry counts as listed.

## Why

Backlog entry 0000433 found that the layout move in 0000397 left `version-files.txt` stale. The queue bumped one copy of `component.yml`, and CI failed at `sync-installed.mjs --check`. No check tied the list to the real files.

## Deviations

- P2 ran inline without subagents, because the change is one test file.
- The test passed on first run, because it checks existing data. Fixture cases cover each failing branch.

## Validation results

- The new suite passes 11 checks on the source and on the installed copy.
- `sync-installed.mjs --check` exits 0.

## Skipped phases

None.
