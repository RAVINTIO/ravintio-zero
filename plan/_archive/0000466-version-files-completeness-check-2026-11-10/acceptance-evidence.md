# Acceptance evidence - 0000466-version-files-completeness-check

- Checks: new suite passes 11 of 11. Full suite in four shards passes 403 suites with 0 failures. Self-corrections: 0.
- Baseline: the two known inherited suites passed in this run. 0 new failures.
- Lint, typecheck, build: none declared for the pack. `archetype-gates.mjs` found no gates installed.
- `sync-installed.mjs --check` exits 0. `version-files.mjs check` exits 0 at 0.87.0.
- Security: 0 critical, 0 high. See `plan/current/security-report.md`.
- Execution: 3 of 3 criteria verified. Removing the `? src/ravintio-zero/component.yml` line from the list made the real-repo check fail and name the file.
- Docs edit pass: 2 changed docs, 1 cycle, `prose-check.mjs` exit 0.
- OS gap: local run on macOS only. CI runs the other platforms.
- Not-verifiable: none.
