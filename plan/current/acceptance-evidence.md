# Acceptance evidence - 0000562

## Checks

- Six suites named in the P2 block pass in the worktree: `test-0000562-req-001-003-pack-file-edit-cause.sh`, `test-0000246-req-001-test-impact-scan.sh`, `test-0000355-req-003-workflow-marker.sh`, `test-0000383-req-001-005-test-impact-causes.sh`, `test-0000493-req-004-handoff-text.sh`, `test-0000151-req-011-orchestrator-references-split.sh`.
- `consistency-check.mjs` exits 0.
- Self-correction cycles: 0.

## Full suite

The rerun in a clean clone finished at load average 2 to 7 with five failed suites. None touches a changed file.

- `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh` fail in the clone and pass in the worktree. The clone has no `core.hooksPath` and no `origin/initiative/*` ref.
- `test-0000171-req-004-no-skill-bundling.sh` and its `.ps1` twin fail AC-2, because a bundled references folder exists.
- `test-0000450-req-004-report-format.sh` reads `docs/` two levels above the pack and finds nothing. The path assumption is the 0000419 `Path move` cause.

CI on the pull request runs the full suite before merge.

## build-log-check findings for ship

- U1 to U6 inline `Done:` lines have no RED or GREEN lines (P2 records).
- REQ-001 has a `Rework:` line and no `Postmortem:` line.
- Ship fills the P3 and P4 times and the total wall clock.

## Security

One informational finding, S-001, accepted. See `plan/current/security-report.md`.

## Execution

All criteria verified by CLI or file checks. See `plan/current/verification-report.md`.

## Docs edit pass

One changed doc, `docs/architecture-overview.md`. `prose-check.mjs` exits 0. The agent skipped the subagent review and the build log records it.

## RED and GREEN for U1 to U6

The P2 block had no unit-level markers. During the P3 resume the agent checked the base commit and `HEAD`. `Pack file edit` and `test-impact-causes` are absent from `docs/architecture-overview.md` and `component.yml` at the base (RED) and present at `HEAD` (GREEN). The `RED:` and `GREEN:` lines for U1 to U6 record that check and the suite run at 2026-11-14T15:11:51Z.
