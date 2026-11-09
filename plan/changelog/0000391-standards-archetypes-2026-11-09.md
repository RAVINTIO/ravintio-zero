# Changelog (0000391-standards-archetypes, 09 Nov 2026)

**Feature:** Standards archetypes
**Version:** set by the merge queue from the step Bump.
**PR:** 148

## What changed

- `resolve-override.mjs` returns an override from `ravintio-overrides/standards/` or `templates/` before the pack copy. `archetypes/protected.json` lists the hook-enforced files, and the resolver never overrides those.
- `ravintio-zero/archetypes/` holds four archetypes: `us-writing`, `restricted-stack`, `language-standards`, and `strict-testing`. Each has an `archetype.json` manifest and a `files/` folder.
- `archetype.mjs` adds `archetype list` and `archetype use {kind}/{name}`. `setup.sh` and `setup.ps1` dispatch to it. It checks clashes first and writes nothing on failure.
- `archetype-gates.mjs` runs at P3 and exits 1 on a failed gate. The validate skill reads its output.
- The writing standard resolves through the override layer.
- ADRs 0291 to 0294 record the decisions.

## Why

Teams need to swap a default standard or add a stricter rule without editing the pack. Hook-enforced rules must stay fixed.

## Deviations

None from the design. Two P2 rework cycles fixed a banned word in a sample file and two test checks that diffed against `HEAD`. Postmortems and backlog entries 0000415 and 0000416 record them.

## Validation results

The full suite passed 371 feature suites and 19 regression suites. A clean clone passed 369 and failed 2 suites that fail on the base commit. The security review found no critical or high finding. Running the commands checked eight acceptance criteria.

## Skipped phases

None.
