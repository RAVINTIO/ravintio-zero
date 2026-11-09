# Changelog (0000395-pack-prose-to-the-standard, 09 Nov 2026)

**Feature:** Pack prose to the standard
**Version:** set by the merge queue at merge
**PR:** pending, updated at Step 9

## What changed

- Rewrote the prose of about 370 Markdown files under `ravintio-zero/`, `docs/` including the ADRs, `ravintio-overrides/`, and the repository root.
- Lowered `plan/state/prose-baseline.json`. No file outside `plan/` keeps an entry, except six applied migrations.
- Moved seven test needles and two fixtures to the rewritten wording.
- Removed one stale row and its comment from the brand guard allowlist.

## Why

Agents copy the pack's style. The pack broke its own writing standard in about 2,300 places, and the breaches spread to consumer repos. Entry 0000302 asked for the rewrite.

## Deviations

- Six files in `ravintio-zero/migrations/_done/` keep their baseline entries. `test-0000160-req-001-pack-identifiers.sh` pins applied migrations to `main` byte for byte.
- The docs edit pass skipped the 176 ADRs, which are historical records.

## Validation results

- The full suite fails only the two inherited suites, `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`.
- `prose-check.mjs check` exits 0.
- The security review found no critical or high finding.

## Skipped phases

None
