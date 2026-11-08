# Changelog (0000382-install-lifecycle, 08 Nov 2026)

**Feature:** Install lifecycle
**Version:** set by the merge queue at merge
**PR:** #136

## What changed

- Setup copies only committed files in `ravintio-zero/` and `ravintio-overrides/`. It lists each uncommitted file, copies nothing, and fails outside a git repository. It has no bypass flag (0000299).
- `--doctor` checks the install and names each problem. `--update {source}` copies a newer pack from a local folder, commits it, and reruns setup with the recorded flags. Setup creates `plan/current/` (0000283).
- `--uninstall` reverses the setup changes, keeps the developer's own entries and every `plan/` record, and refuses while a run is active (0000292).
- A re-run keeps strict mode as it is. `--no-strict-orchestrator` turns it off. The session-start hook reports a clone that has no wired git hooks (0000291).
- `--help` works, the banner prints a plain rule, the guide gains joining, commands, and override-skill sections, and `merge-guard` names a next step. The skill count reads sixteen (0000298).
- `scripts/pack-facts.mjs` writes `ravintio-zero/pack-facts.json`, and CI fails when it is stale (0000286).
- The lifecycle logic lives in `scripts/install-lifecycle.mjs`, so `setup.sh` and `setup.ps1` share it.

## Why

A developer could not update, check, or remove a Zero install with one command. Setup also accepted unreviewed pack edits and turned strict mode on for good.

## Deviations

- Uninstall also removes `plan/.orchestrator-strict` and `plan/.orchestrator-ack`, because they belong to the guards it removes. It deletes no other file under `plan/`.
- The update command reads a local folder only. Downloading a release stays out of scope.
- About 70 existing suites now commit their pack in the test workspace through `commit_workspace_pack`.
- The TDD loop ran inline, with no subagents, because the units edit the same two scripts.

## Validation results

- Full run: 317 feature suites and 19 regression suites passed, including the PowerShell suites.
- Every acceptance criterion verified by running setup in temporary repositories.
- Security review: no open critical or high findings.

## Skipped phases

None
